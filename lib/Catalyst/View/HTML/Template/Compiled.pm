package Catalyst::View::HTML::Template::Compiled;

use strict;
use base 'Catalyst::Base';

use HTML::Template::Compiled;

our $VERSION = '0.02';

=head1 NAME

Catalyst::View::HTML::Template::Compiled - HTML::Template::Compiled View Class

=head1 SYNOPSIS

    # use the helper
    script/myapp_create.pl view HTML::Template::Compiled HTML::Template::Compiled
    
    # lib/MyApp/View/HTML/Template.pm
    package MyApp::View::HTML::Template::Compiled;

    use base 'Catalyst::View::HTML::Template::Compiled';

    __PACKAGE__->config(        
        # any HTML::Template::Compiled configurations items go here
        # see HTML::Template::Compiled documentation for more details
    );

    1;

    # Meanwhile, maybe in an 'end' action
    $c->forward('MyApp::View::HTML::Template::Compiled');

=head1 DESCRIPTION

This is the C<HTML::Template::Compiled> view class. Your subclass should inherit from this
class.

=head1 METHODS

=over 4

=item process

Renders the template specified in I< $c->stash->{template} >, I< $c->request->match >, 
I< $c->config->{template}->{filename} > or I< __PACKAGE__->config->{filename} >.
Template params are set up from the contents of I< $c->stash >,
augmented with C<base> set to I< $c->req->base > and I< name > to 
I< $c->config->{name} >.  Output is stored in I< $c->response->body >.

=cut

sub process {
    my ( $self, $c ) = @_;

    $c->config->{template} ||= {};

    my $filename = $c->stash->{template}
      || $c->req->match
      || $c->config->{template}->{filename}
      || $self->config->{filename};

    unless ($filename) {
        $c->log->debug('No template specified for rendering') if $c->debug;
        return 0;
    }

    my $path =
      $self->_merge_path( $c,
        [ $c->config->{root}, $c->config->{root} . '/base' ],
        $self->config );
    $path = $self->_merge_path( $c, $path, $c->config->{template} );

    my %options = (
        %{ $self->config },
        %{ $c->config->{template} },
        $filename => $filename,
        path      => $path,
    );

    $c->log->debug(qq/Rendering template "$filename"/) if $c->debug;

    my $htc = HTML::Template->new(%options);
    
    $htc->param(
        base => $c->req->base,
        name => $c->config->{name},
        %{ $c->stash }
    );
    
    my $body;

    eval { $body = $htc->output };

    if ( my $error = $@ ) {
        chomp $error;
        $error = qq/Couldn't render template "$filename". Error: "$error"/;
        $c->log->error($error);
        $c->error($error);
        return 0;
    }

    unless ( $c->response->headers->content_type ) {
        $c->res->headers->content_type('text/html; charset=utf-8');
    }

    $c->response->body($body);

    return 1;
}

sub _merge_path {
    my ( $self, $c, $paths, $cfg ) = @_;

    if ( exists $cfg->{path} ) {
        my $path = delete $cfg->{path};
        if ( ref($path) eq 'ARRAY' ) {
            unshift @{$paths}, @{$path};
        }
        else {
            unshift @{$paths}, $path;
        }
    }

    return $paths;
}

=item config

This allows your view subclass to pass additional settings to the
C<HTML::Template::Compiled> config hash.

=back

=head1 SEE ALSO

L<HTML::Template::Compiled>, L<Catalyst>, L<Catalyst::Base>.

=head1 AUTHOR

Sascha Kiefer, C<esskar@cpan.org>

=head1 COPYRIGHT

This program is free software, you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut

1;
