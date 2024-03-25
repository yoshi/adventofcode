#!perl -w

use strict;
use utf8;

chomp( my @dat = <> );

# this is a stream look ahead problem.
# instruction set branch optimization? time will tell.

my $stx;
for( my $i = 0; $i < scalar( @dat ); $i++ ) {
	#print qq(operating on $dat[$i]\n);
	my @stream = split( //, $dat[$i] );

	my $marker_found = 0;
	for( my $j = 13; $j < scalar( @stream ) && $marker_found == 0 ; $j++ ) {
		#print qq(investigating at $j\n);
		my %dups;
		for( my $k = $j - 13; $k <= $j; $k++ ) {
			if( !defined $dups{$stream[$k]} ) {
				#print qq(looking at $stream[$k]\n);
				$dups{$stream[$k]} = 1;
			} else {
				#print qq(looking at $stream[$k] dup\n);
				$dups{$stream[$k]}++;
			}
		}
		my @dups = sort {$b cmp $a} values %dups;
		if( $dups[0] >= 2 ) {
			#print qq(we have dups.\n);
		} else {
			$stx = $j + 1;
			$marker_found = 1;
		}
	}
}

print qq(first marker at $stx\n);

exit(0);
