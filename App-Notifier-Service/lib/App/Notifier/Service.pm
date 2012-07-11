package App::Notifier::Service;
use Dancer ':syntax';

our $VERSION = '0.0100';

use File::Spec;
use YAML::XS qw( LoadFile );

my $config_fn = ($ENV{'NOTIFIER_CONFIG'}
    || File::Spec->catfile($ENV{HOME}, '.app_notifier.yml'));

my $config;

get '/notify' => sub {

    $config ||= LoadFile($config_fn);

    my $cmd_id = (params->{cmd_id} || 'default');
    my $cmd = $config->{commands}->{$cmd_id};

    if (defined($cmd))
    {
        my @cmd_line = ((ref($cmd) eq 'ARRAY') ? @$cmd : $cmd);
        system { $cmd_line[0] } @cmd_line;
        return "Success.";
    }
    else
    {
        debug "Unknown Command ID '$cmd_id'.";
        return "Unknown Command ID.";
    }
};

get '/' => sub {
    template 'index';
};

true;

__END__

=encoding utf-8

=head1 NAME

App::Notifier::Service - an HTTP service for the notifier application for
notifying that an event (such as the finish of a task) occured.

=head1 SYNOPSIS

    # Prepare a YAML file in ~/.app_notifier.yml with commands key that
    # has a default item with a command line command.

    ./bin/app.pl

=head1 AUTHOR

Shlomi Fish, L<http://www.shlomifish.org/> .

=head1 BUGS

Please report any bugs or feature requests to C<bug-app-notifier-service at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=App-Notifier-Service>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc App::Notifier::Service

You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=App-Notifier-Service>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/App-Notifier-Service>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/App-Notifier-Service>

=item * MetaCPAN

L<http://metacpan.org/release/App-Notifier-Service>

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
