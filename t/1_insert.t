use Cache::Bounded;
use Test;
use strict;

BEGIN { plan tests => 2500 }; 

my $cache = new Cache::Bounded;

for ( 1 .. 2500 ) {
  ok($cache->set($_,$_));
}
