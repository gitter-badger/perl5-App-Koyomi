package App::Koyomi::DataSource::Job;

use strict;
use warnings;
use 5.010_001;
use Carp qw(croak);

use version; our $VERSION = 'v0.3.1';

sub instance     { croak 'Must implement in child class!'; }
sub gets         { croak 'Must implement in child class!'; }
sub get_by_id    { croak 'Must implement in child class!'; }
sub update_by_id { croak 'Must implement in child class!'; }

1;

__END__

=encoding utf8

=head1 NAME

B<App::Koyomi::DataSource::Job> - Abstract datasource class for job entity

=head1 SYNOPSIS

    use parent qw(App::Koyomi::DataSource::Job);

    # Your implementation goes below
    sub instance { ... }
    sub gets { ... }
    sub get_by_id { ... }
    sub update_by_id { ... }

=head1 DESCRIPTION

Abstract datasource class for koyomi job entity.

=head1 METHODS

=over 4

=item B<instance>

Construct datasource object.
Probably it's singleton.

=item B<gets>

Fetch all job data as array.

=item B<get_by_id>

Fetch one job data including job_times data.

=item B<update_by_id>

Update one job data including job_times data.

=back

=head1 SEE ALSO

L<App::Koyomi::Job>

=head1 AUTHORS

YASUTAKE Kiyoshi E<lt>yasutake.kiyoshi@gmail.comE<gt>

=head1 LICENSE

Copyright (C) 2015 YASUTAKE Kiyoshi.

This library is free software; you can redistribute it and/or modify it under
the same terms as Perl itself.  That means either (a) the GNU General Public
License or (b) the Artistic License.

=cut

