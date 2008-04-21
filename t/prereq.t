use strict;
use warnings;

use Test::More;
use Test::Exception;
use Storable qw/thaw/;

plan tests => 10; 

my $PA = 'CPAN::Metabase::Fact::PrereqAnalysis';

require_ok $PA;

my $sample_content = {
  'Meta::Meta'    => '0.001',
  'Mecha::Meta'   => '1.234',
  'Physics::Meta' => '9.1.12',
  'Physics::Pata' => '0.1_02',
};

sub new_pa {
  my ($content) = @_;

  return $PA->new({
    id   => 'OPRIME/Test-Meta-1.00.tar.gz',
    content     => $content,
  });
}

{
  throws_ok { new_pa([]) } qr/invalid/, "can't make prereq fact from arrayref";
}

{
  my $fact = new_pa($sample_content);

  # Some sanity checking.
  isa_ok($fact, $PA, 'constructed fact');
  is_deeply($fact->content, $sample_content, "content matches");
  is($fact->id, 'OPRIME/Test-Meta-1.00.tar.gz', "dist id matches");

  my $string = $fact->content_as_string;

  is_deeply(
    thaw($string),
    $sample_content,
    "stringified version reconstitutes to original structure",
  );

  my $clone = CPAN::Metabase::Fact->thaw( $fact->freeze );
  ok( $clone, "freeze -> thaw" );
  isa_ok( $clone, $PA );
  is_deeply( $clone, $fact, "thawed clone matches original" );

  my $content_meta = {
    requires => [ keys %$sample_content ],
  };

  is_deeply( $fact->content_meta, $content_meta, "content_meta correct" );

}
