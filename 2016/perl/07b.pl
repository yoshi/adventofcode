#!perl -w

my $count = 0;

chomp( my @dat = <> );

foreach $line ( @dat ) {
	if( &supports_ssl( $line ) ) {
#		print "$line supports ssl\n";
		$count++;
	} else {
#		print "$line does not support ssl\n";
	}
#	print "\n";
}

print "count: $count\n";

exit( 0 );

sub supports_ssl {
	my( $ip ) = @_;

#	print qq($ip\n);

	my @parts = split(/\[|\]/, $ip);
#	print join("\n", @parts) . qq(\n);

	my $aba_check = 0;
	my $bab_check = 0;

	my @aba_list;

	for(my $i = 0; $i <= $#parts; $i++) {
		if( $i % 2 == 0 ) {
			push( @aba_list, &collect_aba($parts[$i]));
			$aba_check = 1;
		}
	}
	if( $aba_check ) {
		for(my $i = 0; $i <= $#parts; $i++) {
			if( $i % 2 != 0 ) {
				foreach my $aba (@aba_list) {
					my @chars = split("", $aba);
					my $bab = $chars[1] . $chars[0] . $chars[1];
					if( $parts[$i] =~ /$bab/ ) {
#						print "\t" . $parts[$i] . "contains $bab from $aba\n";
						$bab_check = 1;
					}
				}
			}
		}
	}

	if( $bab_check ) {
		return 1;
	} else {
		return 0;
	}
}

sub collect_aba {
	my( $str ) = @_;
	my @abalist;

	for($i = 0; $i < (length($str) - 2); $i++) {
		my @aba = split(//, substr($str,$i,3));
		if( $aba[0] eq $aba[2] && $aba[1] ne $aba[0] ) {
#			print "\tfound aba: @aba\n";
			push( @abalist, join("", @aba));
		}
	}
	
	return @abalist;
}
