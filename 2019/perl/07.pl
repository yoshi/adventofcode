#!perl

my $debug = 0;
my @master_tape;

while( <> ) {
	chomp;

	@master_tape = split( /,/ );
}

my @perms = &get_perms( "{0,1,2,3,4}" );
my $perm;
my $high_output = 0;

my $input = 0;

foreach $perm (@perms) {
	my @phases = split "", $perm;
	$input = 0;
	my $output = 0;
	my $discarded_pc;


	for( my $i = 0; $i <= 4; $i++ ) {
		($output, $state, $discarded_pc, @discarded_tape ) = &sym( $phases[$i], $input, 0, @master_tape );
		$input = $output;
	}

	if( $output > $high_output ) {
		print "perm: $perm output: $output state: $state pc: $discarded_pc\n";
		$high_output = $output;
	}
}

@perms = &get_perms( "{5,6,7,8,9}" );

foreach $perm ( @perms ) {
	my @phases = split "", $perm;
	my $output = 0;
	my $sym_ix = 0;
	my $state = 0;

	my @tape_deck;
	my @pcs;

	# initialize this run
	my @tape0 = @master_tape;
	$tape_deck[0] = \@tape0;
	$pc[0] = 0;
	my @tape1 = @master_tape;
	$tape_deck[1] = \@tape1;
	$pc[1] = 0;
	my @tape2 = @master_tape;
	$tape_deck[2] = \@tape2;
	$pc[2] = 0;
	my @tape3 = @master_tape;
	$tape_deck[3] = \@tape3;
	$pc[3] = 0;
	my @tape4 = @master_tape;
	$tape_deck[4] = \@tape4;
	$pc[4] = 0;

	$input = 0;

	while( $state != 99 ) {
		($output, $state, $pc[$i], @{$tape_deck[$sym_ix]}) =
			&sym( $phases[$sym_ix], $input, $pc[$i], @{$tape_deck[$sym_ix]} );
		print "perm: $perm input: $input output: $output state: $state pc: $pc[$i]\n";
		$input = $output;
		$sym_ix = ($sym_ix + 1) % 5;
	}

	print "perm: $perm output: $output state: $state\n";
}

exit( 0 );

sub get_perms {
	my( $range )= @_;
	my @perms;

	my @uh = glob $range x 5;

	foreach( @uh ){
		my %h = map { $_ => 1} split "", $_;

		my @hk = keys %h;
		next if $#hk != 4;

		push @perms, $_;
	}

	return @perms;
}

sub sym {
	my( $input, $input2, $pc, @tape ) = @_;
	my( $output ) = 0;

	my $state = 0;
#	my @tape = @master_tape;

	my $terminate = 0;
	my $sleep = 0;

	my $first_input = 1;

#	print "in: $input in2: $input2\n";

	while( ! $terminate || ! $sleep ) {
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

			if( $first_input ) {
				$tape[$op1] = $input;
				$first_input = 0;
			} else {
				$tape[$op1] = $input2;
			}
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
			$sleep = 1;
			$state = $opcode;
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
			$state = $opcode;
			$terminate = 1;
		} else {
			print qq(SYSTEM ERROR: opcode=$opcode pc=$pc\n);
			$terminate = 1;
		}
	}

	return( $output, $state, $pc, @tape );
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
