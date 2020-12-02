package Intcode;

# need to implement wait for input mode for problem 7b.

sub new {
	my $class = shift;
	my( $data ) = @_;

	my @tape = split( ',', $data );

	my $self = bless {
		tape => \@tape,
		istream => undef,
		ostream => undef,
		ic => 0,
		rb => 0,
		iowait => 0,
		halted => 0,
	}, $class;

	return $self;
}

sub run ($) {
	my $self = shift;

	while( $self->{halted} != 1 ) {
		$self->tick();
	}
}

sub tick ($) {
	my $self = shift;

	my $ins = @{$self->{tape}}[$self->{ic}];

	my $modes;

	( $ins, $modes ) = &parse_ins( $ins );

	if( $self->{halted} == 1 ) {
		return 0;
	} elsif( $ins =~ /01$/ ) {
		$self->add( $modes );
	} elsif( $ins =~ /02$/ ) {
		$self->mul( $modes );
	} elsif( $ins =~ /03$/ ) {
		$self->imov( $modes );
	} elsif( $ins =~ /04$/ ) {
		$self->omov( $modes );
	} elsif( $ins =~ /05$/ ) {
		$self->jnz( $modes );
	} elsif( $ins =~ /06$/ ) {
		$self->jz( $modes );
	} elsif( $ins =~ /07$/ ) {
		$self->lt( $modes );
	} elsif( $ins =~ /08$/ ) {
		$self->eq( $modes );
	} elsif( $ins =~ /09$/ ) {
		$self->rb( $modes );
	} elsif( $ins =~ /99$/ ) {
		$self->hlt();
	}

	return 1;
}

sub is_halted ($) {
	my $self = shift;

	return $self->{halted};
}

sub is_iowait ($) {
	my $self = shift;

	return $self->{iowait};
}

sub poke ($$$) {
	my $self = shift;

	my( $pos, $val ) = @_;

	@{$self->{tape}}[$pos] = $val;
}

sub peek ($$) {
	my $self = shift;

	my( $pos ) = @_;

	return @{$self->{tape}}[$pos];
}

sub parse_ins {
	my( $ins ) = @_;

	my( $mode3, $mode2, $mode1, $o1, $o0 ) = split "", &normalize_ins( $ins );

	return( "$o1$o0", "$mode3$mode2$mode1" );
}

sub normalize_ins {
	my( $ins ) = @_;

	my $len = length( $ins );

	if( $len < 5 ) {
		$ins = "0" x (5 - $len ) . $ins;
	}

	return $ins;
}

sub get_val {
	my $self = shift;

	my( $op, $mode ) = @_;

	my $val;


	if( $mode == 1 ) {
		$val = $op;
	} elsif( $mode == 2 ) {
		$val = @{$self->{tape}}[ $self->{rb} + $op ];
	} else {
		$val = @{$self->{tape}}[ $op ];
	}

#print "get_val: $op $mode $val\n";

	return $val;
}

sub add {
	my $self = shift;

	my( $modes ) = @_;
	my( $mode3, $mode2, $mode1 ) = split "", $modes;

	my( $op1, $op2, $op3 ) = @{ $self->{tape} }[$self->{ic} + 1 .. $self->{ic} + 3];
	my( $val1, $val2 );

	$val1 = $self->get_val( $op1, $mode1 );
	$val2 = $self->get_val( $op2, $mode2 );

#	print $self->{ic} . " " . $modes . qq( 01 $op1 [$val1] $op2 [$val2] $op3 [$val3]\n);

	@{$self->{tape}}[$op3] = $val1 + $val2;

	$self->{ic} += 4;
}

sub mul {
	my $self = shift;

	my( $modes ) = @_;
	my( $mode3, $mode2, $mode1 ) = split "", $modes;

	my( $op1, $op2, $op3 ) = @{ $self->{tape} }[$self->{ic} + 1 .. $self->{ic} + 3];
	my( $val1, $val2 );

	$val1 = $self->get_val( $op1, $mode1 );
	$val2 = $self->get_val( $op2, $mode2 );

#	print $self->{ic} . " " . $modes . qq( 02 $op1 [$val1] $op2 [$val2] $op3 [$val3]\n);

	@{$self->{tape}}[$op3] = $val1 * $val2;

	$self->{ic} += 4;
}

sub imov {
	# move data from istream to tape
	my $self = shift;

	my( $modes ) = @_;
	my( $mode3, $mode2, $mode1 ) = split "", $modes;

	my( $op1 ) = @{$self->{tape}}[$self->{ic} + 1];
	my( $val1 );

	# hmm.  I think that input only uses parameter mode (mode 0)

#	$val1 = $self->get_val( $op1, $mode1 );
	$val1 = $op1;

#	print $self->{ic} . " " . $modes . qq( 03 $op1 [$val1]\n);

#	print "istream: " . join( ",", @{$self->{istream}} ) . "\n";

	if( scalar( @{$self->{istream}} ) > 0 ) {
		$self->{iowait} = 0;

		@{$self->{tape}}[$val1] = shift @{$self->{istream}};

#	print "verify: " . @{$self->{tape}}[$val1] . "\n";

		$self->{ic} += 2;
	} else {
		$self->{iowait} = 1;
	}
}

sub omov {
	# move data from tape to ostream
	my $self = shift;

	my( $modes ) = @_;
	my( $mode3, $mode2, $mode1 ) = split "", $modes;

	my( $op1 ) = @{$self->{tape}}[$self->{ic} + 1];
	my( $val1 );

	$val1 = $self->get_val( $op1, $mode1 );

#	print $self->{ic} . " " . $modes . qq( 04 $op1 [$val1]\n);

	push @{$self->{ostream}}, $val1;

	$self->{ic} += 2;
}

sub jnz {
	my $self = shift;

	my( $modes ) = @_;
	my( $mode3, $mode2, $mode1 ) = split "", $modes;

	my( $op1, $op2 ) = @{ $self->{tape} }[$self->{ic} + 1 .. $self->{ic} + 2];
	my( $val1, $val2 );

	$val1 = $self->get_val( $op1, $mode1 );
	$val2 = $self->get_val( $op2, $mode2 );

#	print $self->{ic} . " " . $modes . qq( 05 $op1 [$val1] $op2 [$val2]\n);

	if( $val1 != 0 ) {
		$self->{ic} = $val2;
	} else {
		$self->{ic} += 3;
	}
}

sub jz {
	my $self = shift;

	my( $modes ) = @_;
	my( $mode3, $mode2, $mode1 ) = split "", $modes;

	my( $op1, $op2 ) = @{ $self->{tape} }[$self->{ic} + 1 .. $self->{ic} + 2];
	my( $val1, $val2 );

	$val1 = $self->get_val( $op1, $mode1 );
	$val2 = $self->get_val( $op2, $mode2 );

#	print $self->{ic} . " " . $modes . qq( 06 $op1 [$val1] $op2 [$val2]\n);

	if( $val1 == 0 ) {
		$self->{ic} = $val2;
	} else {
		$self->{ic} += 3;
	}
}

sub lt {
	my $self = shift;

	my( $modes ) = @_;
	my( $mode3, $mode2, $mode1 ) = split "", $modes;

	my( $op1, $op2, $op3 ) = @{ $self->{tape} }[$self->{ic} + 1 .. $self->{ic} + 3];
	my( $val1, $val2 );

	$val1 = $self->get_val( $op1, $mode1 );
	$val2 = $self->get_val( $op2, $mode2 );

#	print $self->{ic} . " " . $modes . qq( 07 $op1 [$val1] $op2 [$val2] $op3 [$val3]\n);

	if( $val1 < $val2 ) {
		@{$self->{tape}}[$op3] = 1;
	} else {
		@{$self->{tape}}[$op3] = 0;
	}

	$self->{ic} += 4;
}

sub eq {
	my $self = shift;

	my( $modes ) = @_;
	my( $mode3, $mode2, $mode1 ) = split "", $modes;

	my( $op1, $op2, $op3 ) = @{ $self->{tape} }[$self->{ic} + 1 .. $self->{ic} + 3];
	my( $val1, $val2 );

	$val1 = $self->get_val( $op1, $mode1 );
	$val2 = $self->get_val( $op2, $mode2 );

#	print $self->{ic} . " " . $modes . qq( 08 $op1 [$val1] $op2 [$val2] $op3 [$val3]\n);

	if( $val1 == $val2 ) {
		@{$self->{tape}}[$op3] = 1;
	} else {
		@{$self->{tape}}[$op3] = 0;
	}

	$self->{ic} += 4;
}

sub set_rb {
	my $self = shift;

	my( $modes ) = @_;
	my( $mode3, $mode2, $mode1 ) = split "", $modes;

	my( $op1 ) = @{ $self->{tape} }[$self->{ic} + 1];
	my( $val1 );

	$val1 = $self->get_val( $op1, $mode1 );

#	print $self->{ic} . " " . $modes . qq( 09 $op1 [$val1]\n);

	$self->{rb} += $val1;

	$self->{ic} += 2;
}

sub hlt {
	my $self = shift;

	$self->{halted} = 1;
}

sub istream {
	my $self = shift;

	if( @_ ) {
		$self->{istream} = shift;
	}

#	print "istream: " . join( "", @{$self->{istream}} ) . "\n";

	return $self->{istream};
}

sub ostream {
	my $self = shift;

	if( @_ ) {
		$self->{ostream} = shift;
	}

	return $self->{ostream};
}

sub tape {
	my $self = shift;

	return $self->{tape};
}

sub tapestr {
	my $self = shift;

	return join( ",", @{ $self->{tape} } );
}

sub print_tape {
	my $self = shift;

	print "HALTED: " . $self->{halted} . "\n";
	print "IOWAIT: " . $self->{iowait} . "\n";
	print "IC: " . $self->{ic} . "\n";
	print "RB: " . $self->{rb} . "\n";
	print "ISTREAM: " . join( ",", @{$self->{istream}} ) . "\n" if defined $self->{istream};
	print "OSTREAM: " . join( ",", @{$self->{ostream}} ) . "\n" if defined $self->{ostream};

	for( my $i = 0; $i < scalar( @{$self->{tape}} ); ) {
		my $val = $self->peek( $i );

		print ">>>" if $i == $self->{ic};

		if( $val =~ /^99$/ ) {
			print "$i: HALT $val\n";
			$i++;
		} elsif( $val =~ /^1$/ || $val =~ /01$/ ) {
			print "$i: ADD $val " .
				$self->peek( $i+1 ) . " " .
				$self->peek( $i+2 ) . " " .
				$self->peek( $i+3 ) . " " .
				"\n";
			$i+=4;
		} elsif( $val =~ /^2$/ || $val =~ /02$/ ) {
			print "$i: MUL $val " .
				$self->peek( $i+1 ) . " " .
				$self->peek( $i+2 ) . " " .
				$self->peek( $i+3 ) . " " .
				"\n";
			$i+=4;
		} elsif( $val =~ /^3$/ || $val =~ /03$/ ) {
			print "$i: IMOV $val " .
				$self->peek( $i+1 ) . " " .
				"\n";
			$i+=2;
		} elsif( $val =~ /^4$/ || $val =~ /04$/ ) {
			print "$i: OMOV $val " .
				$self->peek( $i+1 ) . " " .
				"\n";
			$i+=2;
		} elsif( $val =~ /^5$/ || $val =~ /05$/ ) {
			print "$i: JNZ $val " .
				$self->peek( $i+1 ) . " " .
				$self->peek( $i+2 ) . " " .
				"\n";
			$i+=3;
		} elsif( $val =~ /^6$/ || $val =~ /06$/ ) {
			print "$i: JZ $val " .
				$self->peek( $i+1 ) . " " .
				$self->peek( $i+2 ) . " " .
				"\n";
			$i+=3;
		} elsif( $val =~ /^7$/ || $val =~ /07$/ ) {
			print "$i: LT $val " .
				$self->peek( $i+1 ) . " " .
				$self->peek( $i+2 ) . " " .
				$self->peek( $i+3 ) . " " .
				"\n";
			$i+=4;
		} elsif( $val =~ /^8$/ || $val =~ /08$/ ) {
			print "$i: EQ $val " .
				$self->peek( $i+1 ) . " " .
				$self->peek( $i+2 ) . " " .
				$self->peek( $i+3 ) . " " .
				"\n";
			$i+=4;
		} elsif( $val =~ /^9$/ || $val =~ /09$/ ) {
			print "$i: RB $val " .
				$self->peek( $i+1 ) . " " .
				"\n";
			$i+=2;
		} elsif( ! defined $val ) {
			print "$i: NULL\n";
			$i++;
		} else {
			print "$i: DATA $val \n";
			$i++;
		}
	}
	print "\n";
}

1;
