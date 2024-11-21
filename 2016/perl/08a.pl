#!perl -w

my $count = 0;

my @screen;

my $screen_rows = 6;
my $screen_cols = 50;

for( my $i = 0; $i < $screen_rows; $i++ ) {
	push @screen, "." x $screen_cols;
}

#&print_screen;

chomp( my @dat = <> );

foreach $line ( @dat ) {
#	print $line . "\n";
	my @op = split( " ", $line );

	if( $op[0] eq "rect" ) {
		# this is a rect instruction
		my( $width, $height ) = split( "x", $op[1] );
#		print "this is a create rect instruction $width $height\n";
		for( my $i = 0; $i < $height; $i++ ) {
			substr( $screen[$i], 0, $width ) = "#" x $width;
		}
	} elsif( $op[0] eq "rotate" ) {
		if( $op[1] eq "row" ) {
			# this is a rotate row instruction
			my( $row, $steps ) = (join( " ", @op[2,3,4]) =~ /y=([0-9]+) by ([0-9]+)/);
#			print "row $row steps $steps\n";
			my @working_row = split( "", $screen[$row] );
			for( my $i = 0; $i < $steps; $i++ ){
				my $c = pop( @working_row );
				unshift( @working_row, $c );
			}
#			print "wr: " . join("", @working_row) . "\n";
			$screen[$row] = join("", @working_row);
		} else {
			# this is a rotate column instruction
			my( $col, $steps ) = (join( " ", @op[2,3,4]) =~ /x=([0-9]+) by ([0-9]+)/);
			my @working_col;

			for( my $i = 0; $i < $screen_rows; $i++ ) {
				push( @working_col, substr($screen[$i], $col, 1));
			}
#			print "before wc: " . join("", @working_col) . "\n";
			for( my $i = 0; $i < $steps; $i++ ) {
				my $c = pop( @working_col );
				unshift( @working_col, $c );
			}
#			print "after  wc: " . join("", @working_col) . "\n";
			for( my $i = 0; $i < $screen_rows; $i++ ) {
				substr($screen[$i], $col, 1) = $working_col[$i];
			}
		}
	}
}

$count = &lit_calc;

&print_screen;
print "count: $count\n";

exit( 0 );

sub print_screen {
	print join( "\n", @screen ) . "\n";
}

sub lit_calc {
	my $lit_count = 0;

	for( my $i = 0; $i < $screen_rows; $i++ ) {
		@pixels = split( "", $screen[$i]);

		foreach $pixel (@pixels) {
			$lit_count++ if( $pixel eq '#' );
		}
	}
	return $lit_count;
}
