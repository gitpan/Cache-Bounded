use Cache::Bounded;
use Test::Simple tests => 2;
use strict;


my $cache = new Cache::Bounded ({ size => 25, interval => 25 });

for ( 1 .. 25 ) {
  $cache->set($_,$_);
}

ok(scalar(keys %{$cache->{cache}}) == 25);

$cache->set('foo','foo');
$cache->set('bar','bar');

ok(scalar(keys %{$cache->{cache}}) == 1);
