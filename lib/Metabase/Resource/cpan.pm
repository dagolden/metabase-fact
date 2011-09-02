use 5.006;
use strict;
use warnings;
package Metabase::Resource::cpan;
# VERSION

use Carp ();

use Metabase::Resource;
our @ISA = qw/Metabase::Resource/;

sub _init {
  my ($self) = @_;

  # determine type
  my ($type) = $self =~ m{\Acpan:///([^/]+)/};
  Carp::confess("could not determine Metabase::Resource type from '$self'\n")
    unless defined $type && length $type;

  # rebless into subclass and finish initialization
  my $subclass = __PACKAGE__ . "::$type";
  $self->_load($subclass);
  bless $self, $subclass;
  return $self->_init;
}

1;

# ABSTRACT: class for Metabase resources

__END__

=head1 SYNOPSIS

  my $resource = Metabase::Resource->new(
    'cpan:///distfile/RJBS/Metabase-Fact-0.001.tar.gz',
  );

  my $resource_meta = $resource->metadata;
  my $typemap       = $resource->metadata_types;

=head1 DESCRIPTION

Generates resource metadata for resources of the scheme 'cpan'.

The L<Metabase::Resource::cpan> class supports the followng sub-type(s).

=head2 distfile

  my $resource = Metabase::Resource->new(
    'cpan:///distfile/RJBS/URI-cpan-1.000.tar.gz',
  );

For the example above, the resource metadata structure would contain the
following elements:

  scheme       => cpan
  type         => distfile
  dist_file    => RJBS/URI-cpan-1.000.tar.gz
  cpan_id      => RJBS
  dist_name    => URI-cpan
  dist_version => 1.000

=head1 BUGS

Please report any bugs or feature using the CPAN Request Tracker.
Bugs can be submitted through the web interface at
L<http://rt.cpan.org/Dist/Display.html?Queue=Metabase-Fact>

When submitting a bug or request, please include a test-file or a patch to an
existing test-file that illustrates the bug or desired feature.

=cut

