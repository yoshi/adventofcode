#!perl -w

my @point = (1,1);

my @keypad =
	( [1, 4, 7],
	  [2, 5, 8],
	  [3, 6, 9], );

my @code;

chomp( my @dat = <> );

foreach $insline ( @dat ) {
	my @ins = split(//, $insline);

	foreach my $dir (@ins) {
		if( $dir eq "U" ) {
			if( $point[1] != 0 ) {
				$point[1]--;
			}
		} elsif( $dir eq "D" ) {
			if( $point[1] != 2 ) {
				$point[1]++;
			}
		} elsif( $dir eq "L" ) {
			if( $point[0] != 0 ) {
				$point[0]--;
			}
		} elsif( $dir eq "R" ) {
			if( $point[0] != 2 ) {
				$point[0]++;
			}
		}
	}

	push @code, $keypad[$point[0]] [$point[1]];
}

print "code: " . join("", @code) . "\n";

exit( 0 );
