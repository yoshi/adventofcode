#!perl

chomp( @dat = <> );
my $pos = 0, $depth = 0;

for( $i = 0; $i < scalar(@dat); $i++ ) {
	my( $dir, $val ) = split( " ", $dat[$i] );

	if( $dir eq "forward" ) {
		$pos += $val;
	}
	if( $dir eq "down" ) {
		$depth += $val;
	}
	if( $dir eq "up" ) {
		$depth -= $val;
	}
}

print $pos * $depth . "\n";
