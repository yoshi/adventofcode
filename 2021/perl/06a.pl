#!perl -w

use strict;

chomp( my @dat = <> );

my @fishies = split( ",", $dat[0] );

for( my $i = 1; $i <= 80; $i++ ) {
	my @generation = @fishies;

	for( my $j = 0; $j < scalar @fishies; $j++ ) {
		if( $generation[$j] == 0 ) {
			push @generation, 8;
			$generation[$j] = 6;
		} else {
			$generation[$j]--;
		}
	}

	@fishies = @generation;
}
print qq(fishies: ) . scalar(@fishies) . qq(\n);
