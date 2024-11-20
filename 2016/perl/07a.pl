#!perl -w

my $count = 0;

chomp( my @dat = <> );

foreach $line ( @dat ) {
	if( &supports_tls( $line ) ) {
#		print "$line supports tls\n";
		$count++;
	} else {
#		print "$line does not support tls\n";
	}
#	print "\n";
}

print "count: $count\n";

exit( 0 );

sub supports_tls {
	my ($ip) = @_;

#	print qq($ip\n);

	my @parts = split(/\[|\]/, $ip);

#	print join("\n", @parts) . qq(\n);

	my $hype_check = 0;
	my $norm_check = 0;

	for(my $i = 0; $i <= $#parts; $i++) {
		if( $i % 2 == 0 ) {
			if( &has_abba($parts[$i] ) ) {
				$norm_check |= 1;
#				print "$i abba: " . $parts[$i] . "\n";
			}
		} else {
			if( &has_abba($parts[$i] ) ) {
				$hype_check |= 1;
#				print "$i abba: " . $parts[$i] . "\n";
			}
		}
	}

	if( $norm_check && ! $hype_check ) {
		return 1;
	} else {
		return 0;
	}
}

sub has_abba {
	my( $str ) = @_;

	my $is_abba = 0;

	my $abba_str = "";

	for($i = 0; $i < (length($str) - 3); $i++) {
#		print "\t$str $i: " . substr($str,$i,4) . qq(\n);
		my @abba = split(//, substr($str,$i,4));
		if( $abba[0] eq $abba[3] && $abba[1] eq $abba[2] && $abba[0] ne $abba[1]) {
			$is_abba = 1;
			$abba_str = join("", @abba);
#			print "\t@abba is_abba\n";
		}
	}

	# if( $is_abba ) {
	# 	print "\t$str is abba via $abba_str\n";
	# } else {
	# 	print "\t$str is not abba\n";
	# }

	return $is_abba;
}
