#!perl -w

my $count = 0;

chomp( my @dat = <> );

foreach $line ( @dat ) {
	my( @parts ) = split( "-", $line );
#	print $parts[$#parts] . qq(\n);

	my( $sector_id, $checksum ) = ($parts[$#parts] =~ /(\d+)\[([a-z]+)\]/);
#	print "sector_id: $sector_id checksum: $checksum\n";

	pop @parts; # strip the id and checksum
#	print join("", @parts) . qq(\n);

	# check for realness

	my $name = join( "", sort split( //, join("", @parts)));
	#print "name: $name checksum: $checksum\n";

	if( &is_real( $name, $checksum ) ) {
		$count += $sector_id
	}
}

print "count: $count\n";

exit( 0 );

sub is_real {
	my( $name, $checksum ) = @_;

	my %tokens;
	my %freqs;
	my $checksum_calc;

	foreach my $c (split(//, $name)) {
		$tokens{$c}++;
	}

	foreach my $token (sort keys %tokens) {
		#print "token: $token count: $tokens{$token}\n";
		$freqs{$tokens{$token}} .= $token;
	}

	foreach my $freq (sort {$b cmp $a} keys %freqs) {
		#print "freq: " . $freq . "toks: " . $freqs{$freq} . "\n";
		$checksum_calc .= $freqs{$freq};
	}
	$checksum_calc = substr($checksum_calc, 0, 5);
	#print "calc: " . $checksum_calc . "\n";

	if( $checksum_calc eq $checksum ) {
		return 1;
	} else {
		return 0;
	}
}
