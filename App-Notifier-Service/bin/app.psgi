#!/usr/bin/env perl
use Plack::Builder;

use strict;
use warnings;
use FindBin;
use lib "$FindBin::Bin/../lib";

builder {
    # enable 'Deflater';
  # require './script/my_app';
require App::Notifier::Service;
};
