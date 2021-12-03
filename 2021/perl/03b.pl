#!perl -w

chomp( @dat = <> );
my( @oxbits, @cobits );
my( $bitlen ) = length($dat[0]);

@oxbits = @dat;

for( $i = 0; $i < $bitlen; $i++ ) {
	my @bits = @oxbits;
	last if scalar @bits == 1;
	my @newbits;
	my $dom;
	my $ones = 0;
	my $zeroes = 0;
	foreach $b ( @bits ) {
		if( substr( $b, $i, 1 ) eq "1" ) {
			$ones++;
		} else {
			$zeroes++;
		}
	}
	if( $ones >= $zeroes ) {
		$dom = "1";
	} else {
		$dom = "0";
	}
	foreach $b ( @bits ) {
		if( substr( $b, $i, 1 ) eq $dom ) {
			push @newbits, $b;
		}
	}
	@oxbits = @newbits;
}

@cobits = @dat;

for( $i = 0; $i < $bitlen; $i++ ) {
	my @bits = @cobits;
	last if scalar @bits == 1;
	my @newbits;
	my $dom;
	my $ones = 0;
	my $zeroes = 0;
	foreach $b ( @bits ) {
		if( substr( $b, $i, 1 ) eq "1" ) {
			$ones++;
		} else {
			$zeroes++;
		}
	}
	if( $zeroes <= $ones ) {
		$dom = "0";
	} else {
		$dom = "1";
	}
	foreach $b ( @bits ) {
		if( substr( $b, $i, 1 ) eq $dom ) {
			push @newbits, $b;
		}
	}
	@cobits = @newbits;
}

$oxygen = oct("0b" . $oxbits[0]);
$co2 = oct("0b" . $cobits[0]);

print $oxygen * $co2 . "\n";

exit( 0 );
