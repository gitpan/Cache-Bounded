use Cache::Sloppy; 
use Test; 
use strict;

BEGIN { plan tests => 2500 }; 

my $cache = new Cache::Sloppy;

$cache->set('foo','foo');

for ( 1 .. 2500 ) {
  ok($cache->get('foo') eq 'foo');
}
