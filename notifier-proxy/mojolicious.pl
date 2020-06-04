#! /usr/bin/env perl

# Automatically enables "strict", "warnings", "utf8" and Perl 5.16 features
use Mojolicious::Lite;
use Mojo::UserAgent ();

my $REMOTE_HOST = $ENV{"NOTIFIER_PROXY_HOST"} // "192.168.1.191";
my $REMOTE_PORT = $ENV{"NOTIFIER_PROXY_PORT"} // "6300";

# Route with placeholder
get '/notify' => sub {
    my $c    = shift;
    my $hash = $c->req->params->to_hash();
    my $ua   = Mojo::UserAgent->new;
    my $res  = $ua->get(
        "http://${REMOTE_HOST}:${REMOTE_PORT}/notify" => form => $hash );
    return $res;
};

# Start the Mojolicious command system
app->start;
