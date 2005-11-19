use ExtUtils::MakeMaker;

WriteMakefile(
    NAME         => 'Catalyst::View::HTML::Template::Compiled',
    VERSION_FROM => 'lib/Catalyst/View/HTML/Template/Compiled.pm',    # finds $VERSION
    PREREQ_PM => { 'HTML::Template::Compiled' => '0.53', 'Catalyst' => '5' },
    (
        $] >= 5.005
        ?    ## Add these new keywords supported since 5.005
          (
            ABSTRACT_FROM =>
              'lib/Catalyst/View/HTML/Template/Compiled.pm',    # retrieve abstract from module
            AUTHOR => 'Sascha Kiefer <esskar@cpan.org>'
          )
        : ()
    ),
);
