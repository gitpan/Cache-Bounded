=head1 NAME:

Cache::Bounded - A size-aware in-memory cache optimized for speed.

=head1 SYNOPSIS:

Cache::Bounded is designed for caching items into memory in a very fast
but rudimentarily size-aware fashion.

=head1 DESCRIPTION:

Most intelligent caches take either a size-aware or use-aware approach.  
They do so by either anlysing the size of all the elements in the cache or
their frequency of usage before determining which elements to drop from
the cache.  Unfortunately, the processing overhead for this logic (usually
applied on insert) will often slow these caches singnificantly when
frequent insertions are needed.

This module was designed address when this speed-penalty becomes a
problem. Specifically, it is a rudimentarily size-aware cache that is
optimized to be very fast.

For its size analysis, this module merely checks the number of elements in
the cache against a raw size limit. (The default limit is 500,000)  
Additionally, to aid speed, the "size" check doesn't occur on every
insertion. Only after a count of a certain number of insertions (default
1,000) is the size check performed. If the size limit has been exceeded,
the entire cache is purged. (Since there is no usage analysis, there is no
other logical depreciation that can be applied)

This produces a very fast in-memory cache that you can tune to approximate
size based upon your data elements.

=head1 USAGE:

  my $cache = new Cache::Bounded;

  $cache->set($key,$value);
  my $value = $cache->get($key);

=head2 Methods

=head3 new($ref) 

  my $cache = new Cache::Bounded ({ interval=>1000 size=>500000 });

Instances the object as is typical with an OO module. You may also pass a 
hashref with configurations to tune the cache.

Configurable values are:

=over

=item interval

The number of inserts before the size of the cache is checked. Setting 
this to a lower number reduces the "sloppiness" of the size limit. 
However, it also slows cache inserts.

The default of this value is 1,000.

=item size

The number of entries allowed in the cache. Once this is exceeded the 
cache will be purged at the next size check.

The default of this value is 500,000.

=back

=head3 get($key)

Returns the cached value associated with the given key. If no value has 
been cached foe that key, the retruned value is undefined.

=head3 set($key,$value)

Caches the given value for the given key. The cache size is checked during 
the set method. If a purge occurs, the value is cached post-purge.

=head1 KNOWN ISSUES:

=head3 Memory Allocation

Due to perl's methodology of allocating memory, you will not see memory 
freed back to general usage until perl exits after instancing this module. 
On each purge of the internal cache, the memory is retained by perl and 
reallocated internally as the cache grows again.

Consequently after the initial population and purge of the cache, the 
memory allocated should be of a relatively constant size.

=head3 Scalar Values

In the name of speed, there is no checking to see if the data being stored 
is complex or not. Technically you should be able to store complex memory 
structures, though this module is not designed for it and the ability is 
not guarenteed.

Use scalar data.

=head1 AUTHORISHIP:

    Cache::Bounded v1.01 2004/04/02

    (c) 2004, Phillip Pollard <bennie@cpan.org>
    Released under the Perl Artistic License

    Derived from Cache::Sloppy v1.3 2004/03/02
    With permission granted from Health Market Science, Inc.

=cut

package Cache::Bounded;
$Cache::Bounded::VERSION='1.01';

use strict;

sub new {
  my $class = shift @_;
  my $self = {};
  bless($self,$class);

  $self->{cache}    = {};
  $self->{count}    = 0;
  $self->{interval} = 1000;
  $self->{size}     = 500000;

  if ( UNIVERSAL::isa($_[1],'HASH') ) {
    $self->{interval} = $_[1]->{interval} if $_[1]->{interval} > 1;
    $self->{size}     = $_[1]->{size}     if $_[1]->{size}     > 1;
  }

  return $self;
}

sub get {
  my $self = shift @_;
  my $key  = shift @_;
  return $self->{cache}->{$key};
}

sub set {
  my $self = shift @_;
  my $key  = shift @_;
  my $data = shift @_;
  $self->{count}++;

  if ( $self->{count} > $self->{interval} && scalar(keys %{$self->{cache}}) > $self->{size}) {
    $self->{count} = 0;
    $self->{cache} = {};
  }

  $self->{cache}->{$key} = $data;
  return 1;
}

1;
