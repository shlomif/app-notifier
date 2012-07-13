package App::Notifier::Client;

use strict;
use warnings;

use LWP::UserAgent;
use URI;

sub notify
{
    my $class = shift;

    my ($args) = @_;

    my $base_url = $args->{base_url};
    my $cmd_id = $args->{cmd_id};

    my $ua = LWP::UserAgent->new;
    my $url = URI->new($base_url);

    if (defined($cmd_id))
    {
        $url->query_form('cmd_id' => $cmd_id);
    }

    my $response = $ua->get($url);

    if (! $response->is_success())
    {
        die "Error " . $response->status_line();
    }

    return $response->content();
}

1;

__END__

=encoding utf-8

=head1 NAME

App::Notifier::Client - a client library for App::Notifier::Service

=head1 SYNOPSIS

    use App::Notifier::Client;

    App::Notifier::Client->notify(
        {
            base_url => 'http://localhost:6300/',
            cmd_id => 'shine',
        }
    );

    # Without cmd_id.
    App::Notifier::Client->notify(
        {
            base_url => 'http://localhost:6300/',
        }
    );
    1;

=head1 AUTHOR

Shlomi Fish, L<http://www.shlomifish.org/> .

=head1 BUGS

Please report any bugs or feature requests to C<bug-app-notifier-client at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=App-Notifier-Client>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc App::Notifier::Client

You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=App-Notifier-Client>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/App-Notifier-Client>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/App-Notifier-Client>

=item * MetaCPAN

L<http://metacpan.org/release/App-Notifier-Client>

=back


=head1 ACKNOWLEDGEMENTS


=head1 COPYRIGHT & LICENSE

Copyright 2012 Shlomi Fish.

This program is distributed under the MIT (X11) License:
L<http://www.opensource.org/licenses/mit-license.php>

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.

=cut
