#!perl -w

my $count = 0;

my @cols;
my $message;

chomp( my @dat = <> );

foreach $line ( @dat ) {
	my @str = split( //, $line);
	my $pos = 0;

	foreach $c (@str) {
		$cols[$pos] .= $c;
		$pos++;
	}
}

foreach my $col (@cols) {
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

	foreach my $freq (sort keys %freqs) {
		$message .= $freqs{$freq};
		last;
	}

#	foreach my $uh (values %wut) {
#		print "$uh\n";
#	}
}

print "message: $message\n";

exit( 0 );
