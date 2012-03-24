use 5.006;
use strict;
use warnings;
use Module::Build;

my $builder = Module::Build->new(
    module_name         => 'App::TeXMine',
    license             => 'perl',
    dist_author         => q{Andre Santos <andrefs@cpan.org>},
    dist_version_from   => 'lib/App/TeXMine.pm',
    build_requires => {
        'Test::More' => 0,
		'App::Rad' => 0,
    },
    requires => {
        'perl' => 5.014,
    },
	meta_merge => {
		resources => {
			repository => 'http://github.com/andrefs/app-texmine',
			bugtracker => 'http://github.com/andrefs/app-texmine/issues',
		},
	},
    add_to_cleanup      => [ 'App-TeXMine-*' ],
    create_makefile_pl => 'traditional',
);

$builder->create_build_script();
