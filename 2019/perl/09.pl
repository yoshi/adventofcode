#!perl

my @master_tape;

while( <> ) {
	chomp;
	print qq($_\n);
	@master_tape = split( ",", $_ );
}

my $debug = 1;
my @input;
my @output;

my $pc = 0;
my @discard_tape;
my $state;

my ($out, $tape);

#init

push @input, 1;

( $out, $state, $pc, $tape ) = &ic( \@input, $pc, \@master_tape );

@output = @{ $out };

print "input: " . join( ",", @input ) . "\n";
print "output: " . join( ",", @output ) . "\n";

exit( 0 );

# intcode takes the following input:
# @input : an array of input variables
# $pc : the program counter
# @tape : the program image

# outputs
# @output : an array of output variables
# $pc : the program counter
# @tape : the program image
# $state : the state of the program

sub ic {
	my( $in, $pc, $t ) = @_;
	my( @input ) = @{ $in };
	my( @tape ) = @{ $t };
	my( @output );

	my $rb = 0;
	my $state = 0;

	my $terminate = 0;
	my $sleep = 0;

	print "input: " . join(",",@input) . "\n";

	while( ! $terminate || ! $sleep ) {
		my( $instruction ) = $tape[$pc];

		my( $mode3, $mode2, $mode1, $opcode ) = &parse_instruction( $instruction );

		print "mem: ";

		for( my $w = 0; $w <= $#tape; $w++ ) {
		 	if( defined $tape[$w] ) {
#		 		print "$w: [$tape[$w]] ";
		 		print "$tape[$w],";
		 	}
		}

		print "\n";

#		print "$pc: " . join( " ", @tape ) . "\n" if $debug;

		if( $opcode eq "01" ) {
			# add
			my( $op1, $op2, $op3 ) = @tape[$pc+1..$pc+3];

			my( $val1, $val2 );
			if( $mode1 == 1 ) {
				$val1 = $op1;
			} elsif( $mode1 == 2 ) {
				$val1 = $tape[$rb + $op1]
			}else {
				$val1 = $tape[$op1];
			}
			if( $mode2 == 1 ) {
				$val2 = $op2;
			} elsif( $mode2 == 2 ) {
				$val2 = $tape[$rb + $op2]
			} else {
				$val2 = $tape[$op2];
			}

			print "$pc $rb add $mode3 $mode2 $mode1 $opcode $op1 $op2 $op3 ($val1 $val2)\n" if $debug;
			$tape[$op3] = $val1 + $val2;
			$pc += 4;
		} elsif( $opcode eq "02" ) {
			# multiply
			my( $op1, $op2, $op3 ) = @tape[$pc+1..$pc+3];

			my( $val1, $val2 );
			if( $mode1 == 1 ) {
				$val1 = $op1;
			} elsif( $mode1 == 2 ) {
				$val1 = $tape[$rb + $op1];
			} else {
				$val1 = $tape[$op1];
			}
			if( $mode2 == 1 ) {
				$val2 = $op2;
			} elsif( $mode2 == 2 ) {
				$val2 = $tape[$rb + $op2];
			} else {
				$val2 = $tape[$op2];
			}
			print "$pc $rb mult $mode3 $mode2 $mode1 $opcode $op1 $op2 $op3 ($val1 $val2)\n" if $debug;
			$tape[$op3] = $val1 * $val2;
			$pc += 4;
		} elsif( $opcode eq "03" ) {
			# input
			my( $op1 ) = $tape[$pc+1];

			my( $val1 );
			if( $mode1 == 1 ) {
				$val1 = $op1;
			} elsif( $mode1 == 2 ) {
				$val1 = $tape[$rb + $op1];
			} else {
				$val1 = $tape[$op1];
			}
			print "$pc $rb inp $mode3 $mode2 $mode1 $opcode $op1 ($val1)\n" if $debug;

			$tape[$val1] = pop @input;
			$pc += 2;
		} elsif( $opcode eq "04" ) {
			# output
			my( $op1 ) = $tape[$pc+1];

			my( $val1 );
			if( $mode1 == 1 ) {
				$val1 = $op1;
			} elsif( $mode1 == 2 ) {
				$val1 = $tape[$rb+$op1];
			} else {
				$val1 = $tape[$op1];
			}

			print "$pc $rb out $mode3 $mode2 $mode1 $opcode $op1 ($val1)\n" if $debug;

			push @output, $val1;
			$sleep = 1;
			$state = $opcode;
			$pc += 2;
		} elsif( $opcode eq "05" ) {
			# jump-if-true
			my( $op1, $op2 ) = @tape[$pc+1..$pc+2];

			my( $val1, $val2 );
			if( $mode1 == 1 ) {
				$val1 = $op1;
			} elsif( $mode1 == 2 ) {
				$val1 = $tape[$rb+$op1];
			} else {
				$val1 = $tape[$op1];
			}
			if( $mode2 == 1 ) {
				$val2 = $op2;
			} elsif( $mode2 == 2 ) {
				$val2 = $tape[$rb+$op2];
			} else {
				$val2 = $tape[$op2];
			}

			print "$pc $rb jmp-t $mode3 $mode2 $mode1 $opcode $op1 $op2 ($val1 $val2)\n" if $debug;

			if( $val1 != 0 ) {
				$pc = $val2
			} else {
				$pc += 3;
			}
		} elsif( $opcode eq "06" ) {
			# jump-if-false
			my( $op1,$op2 ) = @tape[$pc+1..$pc+2];

			my( $val1, $val2 );
			if( $mode1 == 1 ) {
				$val1 = $op1;
			} elsif( $mode1 == 2 ) {
				$val1 = $tape[$rb+$op1];
			} else {
				$val1 = $tape[$op1];
			}
			if( $mode2 == 1 ) {
				$val2 = $op2;
			} elsif( $mode2 == 2 ) {
				$val2 = $tape[$rb+$op2];
			} else {
				$val2 = $tape[$op2];
			}

			print "$pc $rb jmp-f $mode3 $mode2 $mode1 $opcode $op1 $op2 ($val1 $val2)\n" if $debug;

			if( $val1 == 0 ) {
				$pc = $val2
			} else {
				$pc += 3;
			}
		} elsif( $opcode eq "07" ) {
			# less than
			my( $op1, $op2, $op3 ) = @tape[$pc+1..$pc+3];

			my( $val1, $val2 );
			if( $mode1 == 1 ) {
				$val1 = $op1;
			} elsif( $mode1 == 2 ) {
				$val1 = $tape[$rb+$op1];
			} else {
				$val1 = $tape[$op1];
			}
			if( $mode2 == 1 ) {
				$val2 = $op2;
			} elsif( $mode2 == 2 ) {
				$val2 = $tape[$rb];
			} else {
				$val2 = $tape[$op2+$op2];
			}

			print "$pc $rb lt $mode3 $mode2 $mode1 $opcode $op1 $op2 $op3 ($val1 $val2)\n" if $debug;

			if( $val1 < $val2 ) {
				$tape[$op3] = 1;
			} else {
				$tape[$op3] = 0;
			}
			$pc += 4;
		} elsif( $opcode eq "08" ) {
			# equals
			my( $op1, $op2, $op3 ) = @tape[$pc+1..$pc+3];

			my( $val1, $val2 );
			if( $mode1 == 1 ) {
				$val1 = $op1;
			} elsif( $mode1 == 2 ) {
				$val1 = $tape[$rb+$op1];
			} else {
				$val1 = $tape[$op1];
			}
			if( $mode2 == 1 ) {
				$val2 = $op2;
			} elsif( $mode2 == 2 ) {
				$val2 = $tape[$rb+$op2];
			} else {
				$val2 = $tape[$op2];
			}

			print "$pc $rb eq $mode3 $mode2 $mode1 $opcode $op1 $op2 $op3 ($val1 $val2)\n" if $debug;

			if( $val1 == $val2 ) {
				$tape[$op3] = 1;
			} else {
				$tape[$op3] = 0;
			}
			$pc += 4;
		} elsif( $opcode eq "09" ) {
			# adjust relative base
			my( $op1 ) = $tape[$pc+1];

			my( $val1 );
			if( $mode1 == 1 ) {
				$val1 = $op1;
			} elsif( $mode1 == 2 ) {
				$val1 = $tape[$rb+$op1];
			} else {
				$val1 = $tape[$op1];
			}
			print "$pc $rb rbadj $mode3 $mode2 $mode1 $opcode $op1 ($val1)\n" if $debug;
			$rb += $val1;
			$pc += 2;
		} elsif( $opcode eq "99" ) {
			print "$pc $rb $mode3 $mode2 $mode1 $opcode\n" if $debug;
			$state = $opcode;
			$terminate = 1;
		} else {
			print qq(SYSTEM ERROR: opcode=$opcode pc=$pc rb=$rb\n);
			$terminate = 1;
		}
	}

	return( \@output, $state, $pc, \@tape );
}

sub parse_instruction {
	my( $instruction ) = @_;

	my $len = length( $instruction );

	if( $len < 5 ){
		$instruction = "0" x (5 - $len) . $instruction;
	}

	my( $mode3, $mode2, $mode1, $o1, $o0 ) = split "", $instruction;

	return( $mode3, $mode2, $mode1, "$o1$o0" );
}
