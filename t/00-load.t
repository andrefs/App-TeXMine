#!perl -T

use Test::More tests => 1;

BEGIN {
    use_ok( 'App::texmine' ) || print "Bail out!\n";
}

diag( "Testing App::texmine $App::texmine::VERSION, Perl $], $^X" );
