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
