#!perl -w

my $count = 0;

my ($c0, $c1, $c2, $c3, $c4, $c5);
my $message;

chomp( my @dat = <> );


foreach $line ( @dat ) {
	my @str = split( //, $line);
	
	$c0 .= $str[0];
	$c1 .= $str[1];
	$c2 .= $str[2];
	$c3 .= $str[3];
	$c4 .= $str[4];
	$c5 .= $str[5];
}

foreach my $col ($c0, $c1, $c2, $c3, $c4, $c5 ) {
#	print join("", sort split("", $col)) . "\n";
	my %tokens;
	my %freqs;
	my %wut;

#	print qq($col\n);
#	print qq(sorted: ) . join("", sort split("", $col)) . qq(\n);

	foreach my $token (sort split("", $col)) {
		$tokens{$token}++;
		$wut{$token} .= $token;
	}

	foreach my $token (sort keys %tokens) {
#		print "token: $token count: $tokens{$token}\n";
		$freqs{$tokens{$token}} .= $token;
	}

	foreach my $freq (sort {$b cmp $a} keys %freqs) {
		$message .= $freqs{$freq};
		last;
	}

	foreach my $uh (values %wut) {
		print "$uh\n";
	}
}

print "message: $message\n";

exit( 0 );
