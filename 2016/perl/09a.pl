#!perl -w

chomp( my @dat = <> );

my $compressed_str = $dat[0];
my $decompressed_str = "";

#print $compressed_str . "\n";
#print substr( $compressed_str, 0, 100) . "<--\n";

for( my $i = 0; $i < length($compressed_str); $i++) {
	if( substr( $compressed_str, $i, 1) =~ /[A-Z]/ ) {
		$decompressed_str .= substr( $compressed_str, $i, 1);
#		print "progress: $decompressed_str\n";
	} else {
		my( $marker ) = substr( $compressed_str, $i) =~ /(\(\d+x\d+\))/;
		my $marker_len = length($marker);
		my( $rep_len, $rep_count ) = $marker =~ /(\d+)x(\d+)/;
		my $rep = substr( $compressed_str, $i + $marker_len, $rep_len);

#		print "index: $i marker: $marker length: " . length($marker) . "\n";
#		print "$rep_len x $rep_count: $rep\n";

		$decompressed_str .= $rep x $rep_count;
		$i += $marker_len - 1 + $rep_len;
	}
}

print "comp   len: " . length($compressed_str) . "\n";
print "decomp len: " . length($decompressed_str) . "\n";

exit( 0 );
