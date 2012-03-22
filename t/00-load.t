#!perl -T

use Test::More tests => 1;

BEGIN {
    use_ok( 'App::TeXMine' ) || print "Bail out!\n";
}

diag( "Testing App::TeXMine $App::TeXMine::VERSION, Perl $], $^X" );
