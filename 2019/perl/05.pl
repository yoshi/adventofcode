#!perl

my @master_tape;

my $input = 5;

my $debug = 1;

while( <> ) {
	chomp;

	@master_tape = split( /,/ );
}

print "execution with $input: " . &sym( $input ) . "\n";

exit( 0 );

sub sym {
	my( $input ) = @_;
	my( $output ) = 0;
	my @tape = @master_tape;

	my $terminate = 0;
	my $pc = 0;


	while( ! $terminate ) {
		my( $instruction ) = $tape[$pc];

		my( $mode3, $mode2, $mode1, $opcode ) = &parse_instruction( $instruction );

		print "$pc: " . join( " ", @tape ) . "\n" if $debug;

		if( $opcode == "01" ) {
			my( $op1, $op2, $op3 ) = @tape[$pc+1..$pc+3];
			print "$mode3 $mode2 $mode1 $opcode $op1 $op2 $op3\n" if $debug;

			my( $val1, $val2 );
			if( $mode1 == 1 ) {
				$val1 = $op1;
			} else {
				$val1 = $tape[$op1];
			}
			if( $mode2 == 1 ) {
				$val2 = $op2;
			} else {
				$val2 = $tape[$op2];
			}

			$tape[$op3] = $val1 + $val2;
			$pc += 4;
		} elsif( $opcode == "02" ) {
			my( $op1, $op2, $op3 ) = @tape[$pc+1..$pc+3];
			print "$mode3 $mode2 $mode1 $opcode $op1 $op2 $op3\n" if $debug;

			my( $val1, $val2 );
			if( $mode1 == 1 ) {
				$val1 = $op1;
			} else {
				$val1 = $tape[$op1];
			}
			if( $mode2 == 1 ) {
				$val2 = $op2;
			} else {
				$val2 = $tape[$op2];
			}
			$tape[$op3] = $val1 * $val2;
			$pc += 4;
		} elsif( $opcode == "03" ) {
			my( $op1 ) = $tape[$pc+1];
			print "$mode3 $mode2 $mode1 $opcode $op1\n" if $debug;

			$tape[$op1] = $input;
			$pc += 2;
		} elsif( $opcode == "04" ) {
			my( $op1 ) = $tape[$pc+1];
			print "$mode3 $mode2 $mode1 $opcode $op1\n" if $debug;

			my( $val1 );
			if( $mode1 == 1 ) {
				$val1 = $op1;
			} else {
				$val1 = $tape[$op1];
			}

			$output = $val1;
			$pc += 2;
		} elsif( $opcode == "05" ) {
			my( $op1, $op2 ) = @tape[$pc+1..$pc+2];
			print "$mode3 $mode2 $mode1 $opcode $op1 $op2\n" if $debug;

			my( $val1, $val2 );
			if( $mode1 == 1 ) {
				$val1 = $op1;
			} else {
				$val1 = $tape[$op1];
			}
			if( $mode2 == 1 ) {
				$val2 = $op2;
			} else {
				$val2 = $tape[$op2];
			}

			if( $val1 != 0 ) {
				$pc = $val2
			} else {
				$pc += 3;
			}
		} elsif( $opcode == "06" ) {
			my( $op1,$op2 ) = @tape[$pc+1..$pc+2];
			print "$mode3 $mode2 $mode1 $opcode $op1 $op2\n" if $debug;

			my( $val1, $val2 );
			if( $mode1 == 1 ) {
				$val1 = $op1;
			} else {
				$val1 = $tape[$op1];
			}
			if( $mode2 == 1 ) {
				$val2 = $op2;
			} else {
				$val2 = $tape[$op2];
			}
			if( $val1 == 0 ) {
				$pc = $val2
			} else {
				$pc += 3;
			}
		} elsif( $opcode == "07" ) {
			my( $op1, $op2, $op3 ) = @tape[$pc+1..$pc+3];
			print "$mode3 $mode2 $mode1 $opcode $op1 $op2 $op3\n" if $debug;

			my( $val1, $val2 );
			if( $mode1 == 1 ) {
				$val1 = $op1;
			} else {
				$val1 = $tape[$op1];
			}
			if( $mode2 == 1 ) {
				$val2 = $op2;
			} else {
				$val2 = $tape[$op2];
			}

			if( $val1 < $val2 ) {
				$tape[$op3] = 1;
			} else {
				$tape[$op3] = 0;
			}
			$pc += 4;
		} elsif( $opcode == "08" ) {
			my( $op1, $op2, $op3 ) = @tape[$pc+1..$pc+3];
			print "$mode3 $mode2 $mode1 $opcode $op1 $op2 $op3\n" if $debug;

			my( $val1, $val2 );
			if( $mode1 == 1 ) {
				$val1 = $op1;
			} else {
				$val1 = $tape[$op1];
			}
			if( $mode2 == 1 ) {
				$val2 = $op2;
			} else {
				$val2 = $tape[$op2];
			}

			if( $val1 == $val2 ) {
				$tape[$op3] = 1;
			} else {
				$tape[$op3] = 0;
			}
			$pc += 4;
		} elsif( $opcode == "99" ) {
			print "$mode3 $mode2 $mode1 $opcode\n" if $debug;
			$terminate = 1;
		} else {
			print qq(SYSTEM ERROR: opcode=$opcode pc=$pc\n);
			$terminate = 1;
		}
	}

	return $output;
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
