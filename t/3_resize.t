use Cache::Sloppy;
use Test; 
use strict;

BEGIN { plan tests => 2 }; 

my $cache = new Cache::Sloppy ({ size => 25, interval => 25 });

for ( 1 .. 25 ) {
  $cache->set($_,$_);
}

ok(scalar(keys %{$cache->{cache}}) == 25);

$cache->set('foo','foo');
$cache->set('bar','bar');

ok(scalar(keys %{$cache->{cache}}) == 1);
