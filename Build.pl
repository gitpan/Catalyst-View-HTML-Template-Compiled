use strict;
use Module::Build;

my $build = Module::Build->new(
    create_makefile_pl => 'traditional',
    license            => 'perl',
    module_name        => 'Catalyst::View::HTML::Template::Compiled',
    requires           => {
        'HTML::Template::Compiled' => '0.53',
        'Catalyst'                 => '5',
        'Path::Class'              => '0.10'
    },
    reccomends    => {},
    create_readme => 1,
    sign          => 0,
);
$build->create_build_script;
