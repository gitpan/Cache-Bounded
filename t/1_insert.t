use Cache::Sloppy; 
use Test; 
use strict;

BEGIN { plan tests => 2500 }; 

my $cache = new Cache::Sloppy;

for ( 1 .. 2500 ) {
  ok($cache->set($_,$_));
}
