package App::Notifier::Service;

use 5.014;

use Dancer ':syntax';

our $VERSION = '0.0400';

use List::MoreUtils qw();

use POSIX ":sys_wait_h";
use Errno;

sub _REAPER {
   local $!;   # don't let waitpid() overwrite current error
   while ((my $pid = waitpid(-1, WNOHANG)) > 0 && WIFEXITED($?)) {
   }
   $SIG{CHLD} = \&_REAPER;  # loathe SysV
}

# $SIG{CHLD} = \&_REAPER;

get '/notify' => sub {

    my @cmd_line = ('mpv', '/path/to/non-exist.webm');
    my $pid;
    if (!defined($pid = fork()))
    {
        die "Cannot fork: $!";
    }
    elsif (!$pid)
    {
        if (fork() eq 0)
        {
            # I'm the child.
            system { $cmd_line[0] } @cmd_line;
        }
        POSIX::_exit(0);
    }
    else
    {
        waitpid($pid, 0);
    }
    return "Success.\n";
};

true;

