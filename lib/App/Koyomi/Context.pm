package App::Koyomi::Context;

use strict;
use warnings;
use 5.010_001;
use Class::Accessor::Lite (
    ro => [qw/config/],
);

use App::Koyomi::Config;

our $VERSION = '0.01';

my $CONTEXT;

sub get {
    my $class = shift;
    $CONTEXT //= sub {
        return bless +{
            config => App::Koyomi::Config->get,
        }, $class;
    }->();
    return $CONTEXT;
}

1;

__END__

=encoding utf8

=head1 NAME

B<App::Koyomi::Context> - koyomi application context

=head1 SYNOPSIS

    use App::Koyomi::Context;
    my $ctx = App::Koyomi::Context->get;

=head1 DESCRIPTION

This module represents Singleton context object.

=head1 METHODS

=over 4

=item B<get>

Fetch schedule singleton.

=back

=head1 AUTHORS

YASUTAKE Kiyoshi E<lt>yasutake.kiyoshi@gmail.comE<gt>

=head1 LICENSE

Copyright (C) 2015 YASUTAKE Kiyoshi.

This library is free software; you can redistribute it and/or modify it under
the same terms as Perl itself.  That means either (a) the GNU General Public
License or (b) the Artistic License.

=cut
