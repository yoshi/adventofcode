#!perl

use strict;
use warnings;
use List::Util qw(sum);

package main;

my @containers;

my $goal_size = 150;

while( <> ) {
	chomp;
	push @containers, $_;
}

# find the min and max number of containers

my $min = 0;
my $max = 0;

while( sum((sort { $a <=> $b } @containers)[0..$max]) < $goal_size ) {
	$max += 1;
}

while( sum((sort { $b <=> $a } @containers)[0..$min]) < $goal_size ) {
	$min += 1;
}

#printf( "min: %d max: %d\n", $min, $max );

# for every combination of containers, find all that sum to 150.

# basically, count from 0 to 2^ scalar @containers

my $combination_count = 0;

my %histogram;

for( my $i = 0; $i < 2 ** scalar @containers; $i += 1) {
	my $bin = sprintf( "%b", $i);
	$bin = "0" x (scalar @containers - length( $bin ) ) . $bin;
	my @bina = split( //, $bin );
	my $container_count = grep( /1/, @bina );

	my $csum = 0;

	if( $container_count >= $min && $container_count <= $max ) {
		my $cstring = "";
		for( my $j = 0; $j < scalar @bina; $j += 1 ) {
			if( $bina[$j] == 1 ) {
				$csum += $containers[$j];

				$cstring .= " $containers[$j]"
			}
		}
		if( $csum == $goal_size ) {
			#printf( "%d %s %d %d %s\n", $i, $bin, $container_count, $csum, $cstring );
			$combination_count += 1;
			$histogram{ $container_count } += 1;
		}
	}
}

printf("There are %d combinations\n", $combination_count );

foreach my $k ( sort keys %histogram ) {
	printf( "There are %d combinations with %d containers\n", $histogram{ $k }, $k );
}

exit( 0 );
