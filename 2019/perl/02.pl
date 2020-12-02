#!perl

my @master_tape;

while( <> ) {
	chomp;

	@master_tape = split( /,/ );
}

print "sample run: " . &sym( 12, 2 ) . "\n";

for( $i = 0; $i < 100; $i++ ) {
	for( $j = 0; $j < 100; $j++ ) {
		print " $i $j : " . &sym( $i, $j ) . "\n";
	}
}

exit( 0 );

sub sym {
	my( $noun, $verb ) = @_;

	my @tape = @master_tape;

	my $terminate = 0;
	my $pc = 0;
	my $inc = 4;

	$tape[1] = $noun;
	$tape[2] = $verb;

#	print "pre: " . join( ",", @tape ) . "\n";

	while( ! $terminate ) {
		my( $opcode, $op1, $op2, $op3, @rest ) = @tape[$pc..$pc+3];

		if( $opcode == 1 ) {
			$tape[$op3] = $tape[$op1] + $tape[$op2];
		} elsif( $opcode == 2 ) {
			$tape[$op3] = $tape[$op1] * $tape[$op2];
		} elsif( $opcode == 99 ) {
			$terminate = 1;
		} else {
			print qq(SYSTEM ERROR: opcode=$opcode pc=$pc\n);
			$terminate = 1;
		}

		$pc += 4;
	}

#	print "post: " . join( ",", @tape ) . "\n";

	return $tape[0];
}
