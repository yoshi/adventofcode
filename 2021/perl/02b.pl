#!perl

chomp( @dat = <> );
my $pos = 0, $depth = 0;
my $aim = 0;

for( $i = 0; $i < scalar(@dat); $i++ ) {
	my( $dir, $val ) = split( " ", $dat[$i] );

	if( $dir eq "forward" ) {
		$pos += $val;
		$depth += $aim * $val;
	}
	if( $dir eq "down" ) {
		$aim += $val;
	}
	if( $dir eq "up" ) {
		$aim -= $val;
	}
}

print $pos * $depth . "\n";
