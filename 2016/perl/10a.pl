#!perl -w

use strict;

my $bot = 0;

my @bot_schematic;

my %bots;
my %outputs;
my @bot_ins;
my @bot_vals;
my @output_vals;

my @inits;

chomp( my @dat = <> );

# build the machine
foreach my $line ( @dat ) {
	print "$line\n";
	my @ins = split( " ", $line );
	if( $ins[0] eq "bot" ) {
		my( $bot, $low_kind, $low, $high_kind, $high ) =
			@ins[1,5,6,10,11];

#		print "bot $bot gives low to $low_kind $low and high to $high_kind $high\n";

		my $low_dest;
		my $high_dest;

		$bots{$bot} = 1;
		$bot_vals[$bot*2] = '-';
		$bot_vals[$bot*2+1] = '-';

		if( $low_kind eq "bot" ) {
			$low_dest = "b-" . $low;
			$bots{$low} = 1;
			$bot_vals[$low*2] = '-';
			$bot_vals[$low*2+1] = '-';
		} else {
			$low_dest = "o-" . $low;
			$outputs{$low} = 1;
		}

		if( $high_kind eq "bot" ) {
			$high_dest = "b-" . $high;
			$bots{$high} = 1;
			$bot_vals[$high*2] = '-';
			$bot_vals[$high*2+1] = '-';
		} else {
			$high_dest = "o-" . $high;
			$outputs{$high} = 1;
		}

		my $bot_index = 2 * $bot;

		$bot_ins[$bot_index] = $low_dest;
		$bot_ins[$bot_index+1] = $high_dest;

		print "bot $bot gives low to " . $bot_ins[$bot_index] . " and high to " . $bot_ins[$bot_index+1] . "\n";

	} else {
		my( $value, $bot ) = @ins[1,5]; 
		push @inits, $line;
#		print "value $value goes to bot $bot\n";
	}
}

foreach my $init (@inits) {
	my( $value, $bot ) = (split(" ", $init))[1,5]; 
	print "value $value goes to bot $bot\n";
	# well, I can use an array of arrays or a simpler array.
#	push @{$bot_vals[$bot]}, $value;
#	print "bot $bot has " . join( ",", @{$bot_vals[$bot]}) . "\n";
	
	my $bot_index = 2 * $bot;

	if( $bot_vals[$bot_index] eq "-" ){
		$bot_vals[$bot_index] = $value;
	} else {
		if( $bot_vals[$bot_index] < $value ) {
			$bot_vals[$bot_index+1] = $value;
		} elsif( $bot_vals[$bot_index] > $value ) {
			$bot_vals[$bot_index+1] = $bot_vals[$bot_index];
			$bot_vals[$bot_index] = $value;
		}
	}

	print "bot $bot" . " low " . $bot_vals[$bot_index] . " high " . $bot_vals[$bot_index+1] . "\n";
}

print "the machine\n";

foreach $bot (sort keys %bots) {
	my $bot_index = $bot * 2;

	print "bot $bot (" . $bot_ins[$bot_index] . " "
		. $bot_ins[$bot_index+1] . ")\n";
}

print "running\n";

for( my $i = 0; $i < 100; $i++ ) {
	print "phase " . $i . "\n";
	foreach my $bot (sort keys %bots) {
		my $bot_index = $bot * 2;
		my $low = $bot_vals[$bot_index];
		$low = "" if( ! defined( $low ) );
		my $high = $bot_vals[$bot_index+1];
		$high = "" if( !defined( $high ));
		
		print "bot $bot: ($low,$high)\n";
	}

	foreach my $output (sort keys %outputs) {
		if( defined( $output_vals[$output] ) ) {
			print "output $output: " . join( " ", @{$output_vals[$output]}). "\n";
		}
	}

	my @tmp_bot_vals = @bot_vals;

	foreach my $bot (sort keys %bots) {
		my $src_bot_index = $bot * 2;
		my $low_dest = $bot_ins[$src_bot_index];
		my $high_dest = $bot_ins[$src_bot_index+1];

		my( $low_type, $low ) = split( '-', $low_dest );
		my $low_bot_index = $low * 2;
		my( $high_type, $high ) = split( '-', $high_dest );
		my $high_bot_index = $high * 2;

		if( $bot_vals[$src_bot_index] eq "-" || $bot_vals[$src_bot_index+1] eq "-" ) {
			# bot is not ready so take no action.
			next;
		} else {
			# add val to low side
			if( $low_type eq "b" ) {
				print "moving low val " . $bot_vals[$src_bot_index] . " to bot $low_dest\n";
				if( $tmp_bot_vals[$low_bot_index] eq "-" ) {
					$tmp_bot_vals[$low_bot_index] = $bot_vals[$src_bot_index];
				} else {
					if( $tmp_bot_vals[$low_bot_index] < $bot_vals[$src_bot_index] ) {
						$tmp_bot_vals[$low_bot_index+1] = $bot_vals[$src_bot_index];
					} else {
						$tmp_bot_vals[$low_bot_index+1] = $tmp_bot_vals[$low_bot_index];
						$tmp_bot_vals[$low_bot_index] = $bot_vals[$src_bot_index];
					}
				}
			} else {
				print "moving low val " . $bot_vals[$src_bot_index] . " to output $low_dest $low\n";
				push( @{$output_vals[$low]}, $bot_vals[$src_bot_index] );
			}

			# add val to high side
			if( $high_type eq "b" ) {
				print "moving high val " . $bot_vals[$src_bot_index+1] . " to bot $high_dest\n";
				if( $tmp_bot_vals[$high_bot_index] eq "-" ) {
					$tmp_bot_vals[$high_bot_index] = $bot_vals[$src_bot_index+1];
				} else {
					if( $tmp_bot_vals[$high_bot_index] < $bot_vals[$src_bot_index+1] ) {
						$tmp_bot_vals[$high_bot_index+1] = $bot_vals[$src_bot_index+1];
					} else {
						$tmp_bot_vals[$high_bot_index+1] = $tmp_bot_vals[$high_bot_index];
						$tmp_bot_vals[$high_bot_index] = $bot_vals[$src_bot_index+1];
					}
				}
			} else {
				print "moving high val " . $bot_vals[$src_bot_index+1] . " to output $high_dest\n";
				push( @{$output_vals[$high]}, $bot_vals[$src_bot_index+1] );
			}
			$tmp_bot_vals[$src_bot_index] = "-";
			$tmp_bot_vals[$src_bot_index+1] = "-";
		}
		@bot_vals = @tmp_bot_vals;
	}
}

print "bot: $bot\n";

exit( 0 );

# deal with output values
# determine termination condition (all bot_vals are "-")
