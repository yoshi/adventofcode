#!perl -w

my $debug = 1;

chomp( my @dat = <> );

my @seeds;
my @seed_map;
my @soil_map;
my @fertilizer_map;
my @water_map;
my @light_map;
my @temperature_map;
my @humidity_map;
my @location_map;

my $sum = 0;

# seeds line is the seed list "seeds: x y z"

# generally: destination_number source_number range

# seed_map section "seed-to-soil map:" soil_number seed_number range
# soil_map section "soil-to-fertilizer map:"
# fertilizer_map section "fertilizer-to-water map:"
# water_map section "water-to-light map:"
# light_map section "light-to-temperature map:"
# temperature_map section "temperature-to-humidity map:"
# humidity_map section "humidity-to-location map:"
# location_map is computed

# we have data that creates paths from a seed to a location.
# on every phase transition, step the seeds to the next position in the path.
# on the last phase, identify the lowest location

my $phase = 0;

my $src_map;
my $dst_map;

my $lowest_location = -1;

for( my $i = 0; $i < scalar( @dat ); $i++ ) {
	next if( $dat[$i] eq "" );

	if( $dat[$i] =~ /seeds:\s+([0-9 ]+)/ ) {
		print "phase 0\n" if $debug;
		@seeds = split( " ", $1 );
		next;
	}
	if( $dat[$i] eq "seed-to-soil map:" ) {
		print "phase 1\n" if $debug;
		$phase = 1;
		$src_map = \@seed_map;
		$dst_map = \@soil_map;
		next;
	}
	if( $dat[$i] eq "soil-to-fertilizer map:" ) {
		print "phase 2\n" if $debug;
		$phase = 2;
		$src_map = \@soil_map;
		$dst_map = \@fertilizer_map;
		next;
	}
	if( $dat[$i] eq "fertilizer-to-water map:" ) {
		print "phase 3\n" if $debug;
		$phase = 3;
		$src_map = \@fertilizer_map;
		$dst_map = \@water_map;
		next;
	}
	if( $dat[$i] eq "water-to-light map:" ) {
		print "phase 4\n" if $debug;
		$phase = 4;
		$src_map = \@water_map;
		$dst_map = \@light_map;
		next;
	}
	if( $dat[$i] eq "light-to-temperature map:" ) {
		print "phase 5\n" if $debug;
		$phase = 5;
		$src_map = \@light_map;
		$dst_map = \@temperature_map;
		next;
	}
	if( $dat[$i] eq "temperature-to-humidity map:" ) {
		print "phase 6\n" if $debug;
		$phase = 6;
		$src_map = \@temperature_map;
		$dst_map = \@humidity_map;
		next;
	}

	if( $dat[$i] eq "humidity-to-location map:" ) {
		print "phase 7\n" if $debug;
		$phase = 7;
		$src_map = \@humidity_map;
		$dst_map = \@location_map;
		next;
	}

	# ok, maps have been configured, now create the linkages
	my( $dst, $src, $rng ) = split( " ", $dat[$i] );
	for( my $j = 0; $j < $rng; $j++ ) {
		my $src_offset = $src + $j;
		my $dst_offset = $dst + $j;
		print "$src_offset => $dst_offset\n" if $debug;
		$src_map->[$src + $j] = $dst + $j;
	}
}

# lowest location resulting from mapping the original seeds.

print qq(location: $lowest_location\n);

exit(0);
