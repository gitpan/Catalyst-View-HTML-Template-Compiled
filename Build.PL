use strict;
use Module::Build;

my $build = Module::Build->new(
    license            => 'perl',
    module_name        => 'Catalyst::View::HTML::Template::Compiled',
    requires           => { 'Catalyst' => 5, 'HTML::Template::Compiled' => 0 },
    create_makefile_pl => 'passthrough',
    test_files         => [ glob('t/*.t') ]
);
$build->create_build_script;
