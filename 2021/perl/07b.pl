#!perl -w

use strict;

chomp( my @dat = <> );

my @crabs = split( ",", $dat[0] );

my $min = 10000000;
my $max = 0;

foreach my $crab (@crabs){
	$min = $crab if $crab < $min;
	$max = $crab if $crab > $max;
}

my $min_fuel = 1000000000000000;

my %prev_fuel;

foreach my $pos ( $min .. $max ) {
	my $fuel = &calc_fuel($pos, \@crabs);
	if( $fuel< $min_fuel ) {
		$min_fuel = $fuel;
	}
}

print qq(least fuel: $min_fuel\n);


exit( 0 );

sub calc_fuel {
	my( $pos, $crabs ) = @_;

	my $fuel = 0;

	my %prev_fuel;

	foreach my $crab (@$crabs) {
		my $dis = abs($crab - $pos);
		my $sigma = 0;
		if( !defined $prev_fuel{$crab} ) {
			# well, I guess this is the formula for figuring out triangle nums
			$sigma = $dis * ($dis + 1 ) / 2;
			$prev_fuel{$crab} = $sigma;
		} else {
			$sigma = $prev_fuel{$crab};
		}
		$fuel += $sigma;
	}
	return $fuel;
}
