#!perl

my $naive_fuel = 0;
my $total_fuel = 0;

while( <> ) {
	chomp;

	my $fuel = int( $_ / 3 ) - 2;
	$naive_fuel += $fuel;
	$total_fuel += $fuel + &rfuel( $fuel );
}

print qq(naive fuel: $naive_fuel\n);
print qq(total fuel: $total_fuel\n);

exit( 0 );

sub rfuel {
	my ($f) = @_;

	my $fuel = int( $f / 3 ) - 2;

	if( $fuel <= 0 ) {
		return 0;
	} else {
		return $fuel + &rfuel( $fuel );
	}
}
