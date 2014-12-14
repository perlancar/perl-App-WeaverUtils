package App::WeaverUtils;

# DATE
# VERSION

use 5.010001;
use strict;
use warnings;

our $_complete_stuff = sub {
    require Complete::Module;
    my $which = shift;
    my %args = @_;

    my $word = $args{word} // '';

    # convenience: allow Foo/Bar.{pm,pod,pmc}
    $word =~ s/\.(pm|pmc|pod)\z//;

    # compromise, if word doesn't contain :: we use the safer separator /, but
    # if already contains '::' we use '::' (but this means in bash user needs to
    # use quote (' or ") to make completion behave as expected since : is a word
    # break character in bash/readline.
    my $sep = $word =~ /::/ ? '::' : '/';
    $word =~ s/\W+/::/g;
    my $ns_prefix    = 'Pod::Weaver::'.
        ($which eq 'bundle' ? 'PluginBundle' :
             $which eq 'plugin' ? 'Plugin' :
                 $which eq 'role' ? 'Role' :
                     $which eq 'section' ? 'Section' : ''
                 ).'::';

    {
        words => Complete::Module::complete_module(
            word      => $word,
            ns_prefix => $ns_prefix,
            find_pmc  => 0,
            find_pod  => 0,
            separator => $sep,
            ci        => 1, # convenience
        ),
        path_sep => $sep,
    };
};

our $_complete_bundle = sub {
    $_complete_stuff->('bundle', @_);
};

our $_complete_plugin = sub {
    $_complete_stuff->('plugin', @_);
};

our $_complete_role = sub {
    $_complete_stuff->('role', @_);
};

our $_complete_section = sub {
    $_complete_stuff->('section', @_);
};

1;
# ABSTRACT: Collection of CLI utilities for Pod::Weaver

=head1 DESCRIPTION

This distribution provides several command-line utilities related to
L<Pod::Weaver>.

=cut
