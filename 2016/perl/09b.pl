#!perl -w

chomp( my @dat = <> );

foreach my $str (@dat) {
	my $len = 0;

	$len = &analysis( $str );

	print "len: $len str: " . substr($str, 0, 50) . "\n\n";
}

exit( 0 );

sub analysis {
	my( $str ) = @_;
#	print "analysis: $str\n";

	my $len = 0;

	my $marker_loc = index( $str, "(" );

	if( $marker_loc == -1 ) {
		# there is no marker, so just return the length.
		$len = length( $str );
	} elsif( $marker_loc != 0 ) {
		# there is a marker so do something different.
		$len = length( substr( $str, 0, $marker_loc ) )
			+ &analysis( substr( $str, $marker_loc ) );
	} else {
		# we're just dealing with the marker and what comes after.
		my( $marker ) = $str =~ /^(\(\d+x\d+\))/;
		my $marker_len = length( $marker );
		my( $scope, $mult ) = $marker =~ /(\d+)x(\d+)/;

		$len = $mult * &analysis( substr( $str, $marker_len, $scope ) );
		$len += &analysis( substr( $str, $marker_len + $scope ) )
			if(length(substr( $str, $marker_len + $scope )));
	}
#	print "post analysis: $str $len\n";
	return $len;
}
