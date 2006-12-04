#!/usr/bin/perl

use strict;
use warnings;
use Module::Build;

my $build = Module::Build->new(
    create_makefile_pl => 'traditional',
    dist_version       => 0.13,
    license            => 'perl',
    module_name        => "Catalyst::View::HTML::Template::Compiled",
    requires           => {
        'HTML::Template::Compiled' => 0.80,
        'Catalyst'                 => 5,
        'Path::Class'              => 0.10,
    },
    create_readme => 1,
    sign          => 0,
);
$build->create_build_script;
