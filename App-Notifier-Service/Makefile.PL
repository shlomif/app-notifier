use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME                => 'App::Notifier::Service',
    AUTHOR              => q{Shlomi Fish <shlomif@cpan.org>},
    VERSION_FROM        => 'lib/App/Notifier/Service.pm',
    ABSTRACT            => 'HTTP service to notify that an event happened.',
    ($ExtUtils::MakeMaker::VERSION >= 6.3002
      ? ('LICENSE'=> 'perl')
      : ()),
    PL_FILES            => {},
    PREREQ_PM => {
        'Test::More' => 0,
        'YAML'       => 0,
        'Dancer'     => 1.3097,
    },
    dist                => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean               => { FILES => 'App-Notifier-Service-*' },
);
