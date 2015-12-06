#!/usr/bin/perl -w

# You have a grid.  Each location on the grid has an address. That
# address is an index into a hash table and at the other end of that
# is an index for the number of times it's been visited.  Easy.

my $with_robo_santa = 1;

my $santa_x = 0;
my $santa_y = 0;
my $robo_santa_x = 0;
my $robo_santa_y = 0;

my %houses;

&visit( $santa_x, $santa_y );
&visit( $robo_santa_x, $robo_santa_y ) if( $with_robo_santa == 1 );

while( <> ) {
	chomp;

	my $robo_santa_turn = 0;

	foreach $dir ( split( '', $_) ) {
		if( $with_robo_santa == 0 ) {
			&move_santa( $dir );
			&visit( $santa_x, $santa_y );
		} else {
			if( $robo_santa_turn == 0 ) {
				&move_santa( $dir );
				&visit( $santa_x, $santa_y );
				$robo_santa_turn = 1;
			} else {
				&move_robo_santa( $dir );
				&visit( $robo_santa_x, $robo_santa_y );
				$robo_santa_turn = 0;
			}
		}
	}
}

$house_count = scalar keys %houses;

print $house_count . " had visits.\n";

exit( 0 );

sub move_santa {
	my( $dir ) = @_;
	my( $curx, $cury ) = ($santa_x, $santa_y);
	$curx += 1 if $dir eq ">";
	$cury -= 1 if $dir eq "v";
	$curx -= 1 if $dir eq "<";
	$cury += 1 if $dir eq "^";
	$santa_x = $curx;
	$santa_y = $cury;
}

sub move_robo_santa {
	my( $dir ) = @_;
	my( $curx, $cury ) = ($robo_santa_x, $robo_santa_y);
	$curx += 1 if $dir eq ">";
	$cury -= 1 if $dir eq "v";
	$curx -= 1 if $dir eq "<";
	$cury += 1 if $dir eq "^";
	$robo_santa_x = $curx;
	$robo_santa_y = $cury;
}

sub visit {
	my( $x, $y ) = @_;
	my( $pos ) = $x . "x" . $y;

	if( defined $houses{ $pos } ) {
		$houses{ $pos } ++;
	} else {
		$houses{ $pos } = 1;
	}
}
