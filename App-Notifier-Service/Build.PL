use strict;
use warnings;

use lib "./inc";

use Test::Run::Builder;

my $builder = Test::Run::Builder->new(
    module_name                => 'App::Notifier::Service',
    license => 'mit',
    dist_author => q{Shlomi Fish <shlomif@cpan.org>},
    dist_version_from => 'lib/App/Notifier/Service.pm',
    dist_abstract => 'HTTP service to notify that an event happened.',
    configure_requires => {
        'Module::Build' => '0.39',
    },
    requires => {
        'YAML'       => 0,
        'Dancer'     => '1.3097',
    },
    build_requires => {
        'Test::More' => 0,
    },
    meta_merge =>
    {
        resources =>
        {
            repository => "http://bitbucket.org/shlomif/perl-app-notifier",
            homepage => "http://www.shlomifish.org/open-source/projects/Notifier/",
        },
        keywords =>
        [
            'notify',
            'notifier',
            'alert',
            'finish',
            'cue',
        ],
    },
);

$builder->create_build_script;
