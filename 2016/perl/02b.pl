#!perl -w

my @point = (0,2);

my @keypad =
	( ['x', 'x', 5, 'x', 'x'],
	  ['x',  2 , 6, 'A', 'x'],
	  [ 1 ,  3 , 7, 'B', 'D'],
	  ['x',  4 , 8, 'C', 'x'],
	  ['x', 'x', 9, 'x', 'x'] );

my @code;

chomp( my @dat = <> );

foreach $insline ( @dat ) {
	my @ins = split(//, $insline);

	foreach my $dir (@ins) {
		if( $dir eq "U" ) {
			if( $point[1] != 0 &&
				$keypad[$point[0]][$point[1] - 1] ne 'x' ) {
				$point[1]--;
			}
		} elsif( $dir eq "D" ) {
			if( $point[1] != 4 &&
				$keypad[$point[0]][$point[1] + 1] ne 'x' ) {
				$point[1]++;
			}
		} elsif( $dir eq "L" ) {
			if( $point[0] != 0 &&
				$keypad[$point[0] - 1] [$point[1]] ne 'x' ) {
				$point[0]--;
			}
		} elsif( $dir eq "R" ) {
			if( $point[0] != 4 &&
				$keypad[$point[0] + 1] [$point[1]] ne 'x' ) {
				$point[0]++;
			}
		}
	}

	push @code, $keypad[$point[0]] [$point[1]];
}

print "code: " . join("", @code) . "\n";

exit( 0 );
