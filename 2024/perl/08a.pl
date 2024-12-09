#!perl -w

use strict;
use feature 'say';

my @antennas;
my $height = 0;
my $width = 0;
my $count = 0;
my %freaks;
my %ants;

chomp( my @dat = <> );

$width = length( $dat[0] );

foreach my $line ( @dat ) {
	my @row = split(//, $line );

	for( my $i = 0; $i <= $#row; $i++ ) {
		if( $row[$i] ne  "." ) {
			$ants{ $row[$i] . " $i $height" } = 1;
			$freaks{$row[$i]}++;
		}
	}

	push( @antennas, [@row]);
	$height++;
}

foreach my $k (sort keys %freaks) {
	say "$k: $freaks{$k}"
}

foreach my $m (sort keys %ants ) {
	say "$m";
}

say "width: $width height: $height";

say "count: $count";

exit( 0 );

# ant: freq x y
