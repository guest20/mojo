use Mojo::Base -strict;

# Farnsworth: Those ruffians smoked one of your cigars.
# Hermes: That's not a cigar... and it's not mine.
use Test::More;

use FindBin;
use lib "$FindBin::Bin/lib";

use Mojo::Asset::File;
use Mojo::Date;
use Mojo::File 'path';
use Mojo::IOLoop;
use Mojolicious::Controller;
use Mojolicious;
use Test::Mojo;

# mojolicious.org references many of the things in Mojolicious/resources
# so let's just make serving them a switch that defaults to "on".

my @bundled_things = qw[
    /favicon.ico
    /mojo/jquery/jquery.js
    /mojo/notfound.png
    /mojo/prettify/run_prettify.js
];

{
  my $t= Test::Mojo->new('MojoliciousTest');
  $t->app->static->serve_bundled(1);
  $t->get_ok( $_ )->status_isnt(404) for @bundled_things;
  $t->get_ok( '/just/some/template' )->status_is(200);
}

{
  my $t= Test::Mojo->new('MojoliciousTest');
  $t->app->static->serve_bundled(0);
  $t->get_ok( $_ )->status_is(404) for @bundled_things;
  $t->get_ok( '/just/some/template' )->status_is(200);
}

done_testing
