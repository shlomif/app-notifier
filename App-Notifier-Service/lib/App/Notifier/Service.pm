package App::Notifier::Service;

use 5.014;

use strict;
use warnings;

use Mojolicious::Lite;
use Plack::Builder;

use File::Spec ();
use JSON::MaybeXS qw( decode_json );
use YAML::XS qw( LoadFile );
use List::MoreUtils qw();

use POSIX ":sys_wait_h";
use Errno;

sub _REAPER
{
    local $!;    # don't let waitpid() overwrite current error
    while ( ( my $pid = waitpid( -1, WNOHANG ) ) > 0 && WIFEXITED($?) )
    {
    }
    $SIG{CHLD} = \&_REAPER;    # loathe SysV
}

# $SIG{CHLD} = \&_REAPER;

my $config_fn = ( $ENV{'NOTIFIER_CONFIG'}
        || File::Spec->catfile( $ENV{HOME}, '.app_notifier.yml' ) );

my $config;

sub _process_cmd_line_arg
{
    my ( $arg, $text_params ) = @_;

    if ( ref($arg) eq '' )
    {
        return $arg;
    }
    elsif ( ref($arg) eq 'HASH' )
    {
        if ( $arg->{type} eq 'text_param' )
        {
            return ( $text_params->{ $arg->{param_name} } // '' );
        }
        else
        {
            die +{ msg => "Unknown special argument type $arg->{type}", };
        }
    }
    else
    {
        die +{ msg =>
"Unhandled perl type for argument in command line template (should be string or hash.",
        };
    }

    return;
}

get '/notify' => sub {
    my $c = shift;

    $config ||= LoadFile($config_fn);

    my $cmd_id      = ( $c->req->param('cmd_id') || 'default' );
    my $text_params = {};
    if ( defined( my $text_params_as_json = $c->req->param('text_params') ) )
    {
        $text_params = decode_json($text_params_as_json);
        if ( ref($text_params) ne 'HASH' )
        {
            return "Invalid text_params - should be a JSON hash.\n";
        }
        elsif ( List::MoreUtils::any { ref($_) ne '' } values(%$text_params) )
        {
            return "Invalid text_params - all values must be strings.\n";
        }
    }
    my $cmd = $config->{commands}->{$cmd_id};

    if ( defined($cmd) )
    {
        my @before_cmd_line = ( ( ref($cmd) eq 'ARRAY' ) ? @$cmd : $cmd );

        my @cmd_line = eval {
            map { _process_cmd_line_arg( $_, $text_params ); } @before_cmd_line;
        };

        if ( my $Err = $@ )
        {
            if ( ref($Err) eq 'HASH' and ( exists( $Err->{msg} ) ) )
            {
                return ( $Err->{msg} . "\n" );
            }
            else
            {
                die $Err;
            }
        }

        my $pid;
        if ( !defined( $pid = fork() ) )
        {
            die "Cannot fork: $!";
        }
        elsif ( !$pid )
        {
            # I'm the child.
            if ( fork() eq 0 )
            {
                # I'm the grandchild.
                system { $cmd_line[0] } @cmd_line;
            }
            POSIX::_exit(0);
        }
        else
        {
            waitpid( $pid, 0 );
        }
        $c->render( text => "Success.\n" );
    }
    else
    {
        $c->log("Unknown Command ID '$cmd_id'.");
        return "Unknown Command ID.\n";
    }
};

get '/' => sub {
    my $c = shift;
    $c->render( text => "OK\n" );
};

builder
{
    # enable 'Deflater';
    app->start;
};

# "true";

# start;

__END__

=encoding utf-8

=head1 NAME

App::Notifier::Service - an HTTP service for the notifier application for
notifying that an event (such as the finish of a task) occured.

=head1 SYNOPSIS

    # Prepare a YAML file in ~/.app_notifier.yml with content like this:

    $ cat <<EOF > ~/.app_notifier.yml
    commands:
        # These entries contain command lines that get invoked after the
        # notification is received. They can be either strings or arrays.
        default:
            - /home/shlomif/bin/desktop-finish-cue
        shine:
            - /home/shlomif/bin/desktop-finish-cue
            - "--song"
            - "/home/music/Music/dosd-mp3s/Carmen and Camille - Shine 4U"
            - "--message"
            - type: "text_param"
              param_name: "msg"
    EOF

    # Run the Mojo application from the distribution's root directory.
    plackup ./bin/app.psgi

    # Alternatively run the following Perl code:
    use App::Notifier::Service;
    start;

    # When you want to notify that an event occured:
    $ curl 'http://127.0.0.1:3000/notify'
    $ curl 'http://127.0.0.1:3000/notify?cmd_id=shine'


=head1 AUTHOR

Shlomi Fish, L<https://www.shlomifish.org/> .

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
