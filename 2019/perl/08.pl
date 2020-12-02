#!perl -w

while(<>) {
	chomp;
	@pixels = split( "", $_ );
}

my $cols = 25;
my $rows = 6;

my @layers;
my $layer_ix = 0;

my $min = 999;

for( my $i = 0; $i < 15000; $i += 150 ) {
	my %hist;
	map { $hist{ $_ } ++ } @pixels[$i..$i+149];

	if( $hist{"0"} <  $min ) {
		print qq($i $hist{ "0" } $hist{ "1"} $hist{"2"} ) . $hist{"1"} * $hist{"2"} . qq(\n);
		$min = $hist{"0"};
	}

	$layers[$layer_ix] = join( "", @pixels[$i..$i+149] );

#	print $layers[$layer_ix] . "\n";

	$layer_ix++;
}
print "layers: $layer_ix\n";

for( my $j = 0; $j < 150; $j++ ) {
	my $p;

	my $x;
	for( $l = $layer_ix - 1; $l >= 0; $l-- ) {
		$p = substr( $layers[$l], $j, 1 );
		if( $p == 1 ) {
			$x = 'x';
		} elsif( $p == 0 ) {
			$x = ' ';
		} elsif( $p != 2 ) {
			$x = $p;
		}
	}
	print "$x";
	print "\n" if ((($j+1) % $cols ) == 0);
}

exit( 0 );
