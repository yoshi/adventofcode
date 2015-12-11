#!/usr/bin/perl -w

use Scalar::Util qw(looks_like_number);

my %wires;
my %resolved;

while( <> ) {
	chomp;

	@tokens = split( / / );

	if( scalar @tokens == 5 ) {
		# this is an infix thing
		my( $val1, $op, $val2, $yield, $rhs ) = @tokens;
		$wires{ $rhs } = [$op, $val1, $val2 ];
	}

	if( scalar @tokens == 4 ) {
		# this is an prefix thing
		my( $op, $val1, $yield, $rhs ) = @tokens;
		$wires{ $rhs } = [$op, $val1 ];
	}

	if( scalar @tokens == 3 ) {
		# this is pure assignment
		my( $val1, $yield, $rhs ) = @tokens;
		$wires{ $rhs } = [ $val1 ];

		# but it's only resolved if the value is a number.

		if( looks_like_number( $val ) ) {
			$resolved{ $rhs } = $val1;
		}
	}
}

#print qq(OUTPUT-->\n);
#&output;

print "wire count: " . scalar( keys( %wires ) ) . "\n";

while( scalar( keys( %resolved ) ) != scalar( keys( %wires ) ) ) {
	print "resolved so far: " . scalar( keys( %resolved ) ) . "\n";
	&propagate;
}

print qq(PART 1 OUTPUT-->\n);
&output_resolved;

# Now hack the junk by replacing the value of b and re-run the propagation.
$wires{ "b" } = [ $resolved{ "a" } ];
undef %resolved;

#print qq(OUTPUT GAH-->\n);
#&output;

while( scalar( keys( %resolved ) ) != scalar( keys( %wires ) ) ) {
	print "resolved so far: " . scalar( keys( %resolved ) ) . "\n";
	&propagate;
}

print qq(PART 2 OUTPUT-->\n);
&output_resolved;


# Hmm.   How about we propagate constants where we see them first.

# We can evaluate any functino that has resolved references.  There is
# a question about where to start the pulling of string.  That's
# Above, I suppose. (the three token rule).

# Now, we have three functions that we can do.  These are:

# LSHIFT, RSHIFT, AND, OR, NOT.  Each takes a series of integers to be able to fire.

exit( 0 );

sub propagate {
	foreach $k ( sort keys %wires ) {
		#print qq(measuring $k\n);
		if( ! defined $resolved{ $k } ) {
			my @tokens = @{$wires{$k}};

			my $wire_is_ready = 1;
			for( $i = 0; $i < scalar @tokens; $i += 1 ) {
				# this is the case where you have an assignment to a variable
				next if ($i == 0 && scalar @tokens != 1 );
				if( defined( $resolved{ $tokens[ $i ] } ) ) {
					#print $tokens[ $i ] . " is resolved\n";
					$tokens[ $i ] = $resolved{ $tokens[ $i ] };
				} elsif( ! looks_like_number( $tokens[ $i ] ) ) {
					$wire_is_ready = 0;
				}
			}
			if( $wire_is_ready ) {
				#print qq(wire is ready for evaluation\n);
				my $wire_value = &eval_wire( @tokens );
				$resolved{ $k } = $wire_value;
				#$wires{$k} = [$wire_value];
			} else {
				#print qq(I believe all tokens are not resolved\n);
				#$wires{$k} = \@tokens;
			}
		}
	}
}

sub output {
	foreach $k ( sort keys %wires ) {
		print "$k : ";
		foreach $v ( @{$wires{$k}}) {
			print $v . " ";
		}
		print "\n";
	}
}

sub output_resolved {
	foreach $k ( sort keys %resolved ) {
		print "$k : " . $resolved{$k} . "\n";
	}
}

sub eval_wire {
	my( $op, $val1, $val2 ) = @_;

	my( $wire_val );

	if( defined( $val1 ) ) {
		$val1 = int( $val1 );
	}

	if( defined( $val2 ) ) {
		$val2 = int( $val2 );
	}

	if( $op eq "NOT" ) {
		my @bits = split( //, unpack( "b16", pack( "n", $val1 )));
		for($i = 0; $i < scalar( @bits ); $i += 1) {
			if( $bits[$i] eq "1" ) {
				$bits[$i] = "0";
			} else {
				$bits[$i] = "1";
			}
		}
		$wire_val = unpack( 'n', pack( "b16", join( '', @bits ) ) );
	} elsif( $op eq "AND" ) {
		$wire_val = $val1 & $val2;
	} elsif( $op eq "OR" ) {
		$wire_val = $val1 | $val2;
	} elsif( $op eq "LSHIFT" ) {
		$wire_val = $val1 << $val2;
	} elsif( $op eq "RSHIFT" ) {
		$wire_val = $val1 >> $val2;
	} else {
		# this is the assignment case.
		$wire_val = $op;
	}

	return $wire_val;
}
