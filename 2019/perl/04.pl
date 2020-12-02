#!perl

$x = 145852;
$y = 616942;

for( my $j = $x; $j <= $y; $j++ ) {
	if( &pwtest( $j ) ) {
		print "uno $j\n";
		if( &pw2test( $j ) ) {
			print "dos $j\n";
		}
	}
}

exit( 0 );

sub pwtest {
	my( $pw ) = @_;
	my $repeat = 0; #assume no repeats
	my $nd = 1; #assume no descent

	my @tokens = split "", "$pw";

	for( my $i = 1; $i <= $#tokens; $i++ ) {
		if( $tokens[$i - 1] eq $tokens[$i] ) {
			$repeat = 1;
		}
		if( $tokens[$i - 1] > $tokens[$i] ) {
			$nd = 0;
		}
	}

	if( $repeat && $nd ) {
		return 1;
	} else {
		return 0;
	}
}

sub pw2test {
	my( $pw ) = @_;
	my $repeat = 0;
	my %rep;
	my @tokens = split "", "$pw";

	for( my $i = 0; $i <= $#tokens; $i++ ) {
		$rep{$tokens[$i]} ++;
	}

	foreach $v ( values %rep ) {
		$repeat = 1 if $v == 2;
	}

	if( $repeat ) {
		return 1;
	} else {
		return 0;
	}
}
