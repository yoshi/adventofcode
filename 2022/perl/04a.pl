#!perl -w

chomp( my @dat = <> );
my $inc = 0;
my $prev;

my $container_count = 0;

for( my $i = 0; $i < scalar( @dat ); $i++ ) {
	# split string down the middle
	#print $dat[$i] . qq(\n);

	my ( $one_range, $two_range ) = split( ',', $dat[$i] );
	my ( $one, $two );

	$one = &elehash( $one_range );
	$two = &elehash( $two_range );

	my %u;

	foreach my $k ( keys %{$one} ) {
		$u{ $k } = 1;
		#print qq(1 adding $k\n);
	}

	foreach my $k ( keys %{$two} ) {
		$u{ $k } = 1;
		#print qq(2 adding $k\n);
	}

	#print qq( $one_range $two_range \n);
	my( $u_len ) = scalar( keys %u );
	my( $one_len ) = scalar( keys %{ $one } );
	my( $two_len ) = scalar( keys %{ $two } );

	#print qq( $u_len $one_len $two_len \n);

	if( $u_len == $one_len || $u_len == $two_len ) {
		#print qq(contains\n);
		$container_count++;
	}
}

print qq(container_count: $container_count\n);

exit( 0 );

sub elehash {
	my ( $range )= @_;
	my %eh;

	my( $start, $end ) = split( "-", $range );

	foreach my $k ( $start..$end ) {
		$eh{$k} = 1;
	}

	return \%eh;
}
