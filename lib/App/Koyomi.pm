package App::Koyomi;

use strict;
use warnings;
use 5.010_001;

use version; our $VERSION = 'v0.3.1';

1;
__END__

=encoding utf-8

=head1 NAME

App::Koyomi - A simple distributed job scheduler

=head1 DESCRIPTION

B<Koyomi> is a simple distributed job scheduler which achieves High Availability.

You can run I<koyomi worker> on several servers.
Then if one worker stops with any trouble, remaining workers will take after its jobs.

=head1 DOCUMENTATION

Full documentation is available on http://key-amb.github.io/App-Koyomi-Doc/ .

=head1 SEE ALSO

L<koyomi>

=head1 AUTHORS

YASUTAKE Kiyoshi E<lt>yasutake.kiyoshi@gmail.comE<gt>

=head1 LICENSE

Copyright (C) 2015 YASUTAKE Kiyoshi.

This library is free software; you can redistribute it and/or modify it under
the same terms as Perl itself.  That means either (a) the GNU General Public
License or (b) the Artistic License.

=cut

