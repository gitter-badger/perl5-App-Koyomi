package App::Koyomi::CLI;

use strict;
use warnings;
use 5.010_001;
use Class::Accessor::Lite (
    ro => [qw/ctx/],
);
use File::Temp qw(tempfile);
use Getopt::Long qw(:config posix_default no_ignore_case no_ignore_case_always);
use Log::Minimal env_debug => 'KOYOMI_LOG_DEBUG';
use Perl6::Slurp;
use Smart::Args;
use Text::ASCIITable;
use YAML::XS ();

use App::Koyomi::Context;
use App::Koyomi::JobTime::Formatter qw(str2time);

use version; our $VERSION = 'v0.3.1';

my @CLI_METHODS = qw/add list modify delete/;

sub new {
    my $class = shift;
    my %args  = @_;
    my $ctx   = App::Koyomi::Context->instance;
    return bless +{ ctx => $ctx }, $class;
}

sub parse_args {
    my $class  = shift;
    my $method = shift or return;
    my @args   = @_;

    unless (grep { $_ eq $method } @CLI_METHODS) {
        warnf('No such method:%s', $method);
        return;
    }

    Getopt::Long::GetOptionsFromArray(
        \@args,          \my %opt,
        'job-id|jid=i', 'editor|e=s',
    );
    my %cmd_args;
    $cmd_args{job_id} = $opt{'job-id'} if $opt{'job-id'};
    $cmd_args{editor} = $opt{editor}   if $opt{editor};

    my %property = ();
    return ($method, \%property, \%cmd_args);
}

sub list {
    my $self = shift;

    my @job_cols  = qw/id user command/;
    my @time_cols = qw/Y m d H M weekday/;
    my $t = Text::ASCIITable->new();
    $t->setCols(@job_cols, @time_cols);

    my @time_keys = qw/year month day hour minute weekday/;

    my $ctx  = $self->ctx;
    my @jobs = $ctx->datasource_job->gets(ctx => $ctx);
    for my $job (@jobs) {
        my @job_row = map { $job->$_ } @job_cols;
        for my $time (@{$job->times}) {
            my @row = (@job_row, map { $time->$_ } @time_keys);
            $t->addRow(@row);
        }
    }

    print $t->draw;
}

sub modify {
    args(
        my $self,
        my $job_id => 'Int',
        my $editor => +{ isa => 'Str', default => $ENV{EDITOR} || 'vi' },
    );

    my $ctx = $self->ctx;
    my $job = $ctx->datasource_job->get_by_id(
        id  => $job_id,
        ctx => $ctx
    );
    croakf(q/No such job! id=%d/, $job_id) unless $job;

    my %data = (
        user    => $job->user || q{},
        command => $job->command,
        memo    => $job->memo,
    );

    my @times = map { $_->time2str } @{$job->times};
    $data{times} = \@times;

    my $yaml = YAML::XS::Dump(\%data);

    my ($fh, $tempfile) = tempfile();
    print $fh $yaml;
    close $fh;
    system($editor, $tempfile);
    my $new_yaml = slurp($tempfile);
    unlink $tempfile;

    my $new_data = YAML::XS::Load($new_yaml);
    my @new_times = map { str2time($_) } @{$new_data->{times}};
    $new_data->{times} = \@new_times;

    $ctx->datasource_job->update_by_id(
        id => $job_id, data => $new_data, ctx => $ctx
    );

    infof('[modify] Finished.');
}

1;

__END__

=encoding utf8

=head1 NAME

B<App::Koyomi::CLI> - Koyomi CLI module

=head1 SYNOPSIS

    use App::Koyomi::CLI;
    my ($method, $props, $args) = App::Koyomi::CLI->parse_args(@ARGV);
    App::Koyomi::CLI->new(%$props)->$method(%$args);

=head1 DESCRIPTION

I<Koyomi> CLI module.

=head1 METHODS

=over 4

=item B<new>

Construction.

=item B<add>

Create a job schedule.
NOT implemented yet.

=item B<list>

List scheduled jobs.

=item B<modify>

Modify a job schedule.

=item B<delete>

Delete a job schedule.
NOT implemented yet.

=back

=head1 SEE ALSO

L<koyomi-cli>,
L<App::Koyomi::Context>

=head1 AUTHORS

YASUTAKE Kiyoshi E<lt>yasutake.kiyoshi@gmail.comE<gt>

=head1 LICENSE

Copyright (C) 2015 YASUTAKE Kiyoshi.

This library is free software; you can redistribute it and/or modify it under
the same terms as Perl itself.  That means either (a) the GNU General Public
License or (b) the Artistic License.

=cut

