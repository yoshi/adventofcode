#!perl -w

chomp( @dat = <> );
my( $gambits, $epsbits );
my( $gamma, $epsilon );

my @ones;

print qq(len: ) . length($dat[0]) . qq(\n);

for( $i = 0; $i < length($dat[0]); $i++ ) {
	for( $j = 0; $j < scalar(@dat); $j++ ) {
		if( substr( $dat[$j], $i, 1 ) eq "1" ) {
			$ones[$i]++;
		}
	}

	if( $ones[$i] > scalar(@dat) / 2 ) {
		$gambits .= "1";
		$epsbits .= "0";
	} else {
		$gambits .= "0";
		$epsbits .= "1";
	}
}

$gamma = oct("0b" . $gambits);
$epsilon = oct("0b" . $epsbits);


print $gamma * $epsilon . "\n";
