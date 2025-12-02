#!perl

use strict;
use warnings;

chomp( my @dat = <> );

my $result = 0;

foreach my $line ( @dat ) {
	my (@ranges) = split /,/, $line;

	foreach my $range (@ranges) {
		my( $start, $end ) = split /-/, $range;

		for( my $id = $start; $id <= $end; $id++ ) {
			next if( length( $id ) % 2 != 0 );
			if( &folds($id) ) {
				$result += $id;
			}
		}
	}
}

print qq(result: $result\n);

exit( 0 );

sub folds() {
	my( $id ) = @_;
	my( $len ) = length( $id );
	if( substr($id, 0, $len / 2) eq substr($id, $len/2, $len) ) {
		return 1;
	} else {
		return 0;
	}
}
