#!perl -w

# The idea with part b is to put a blockade into an existing path of
# the guard and to determine if it creates a loop or if there is an
# escape.  If there is a loop, then the block was successful.

use strict;
use feature 'say';

my @matrix;
my $width = 0;
my $height = 0;
my $count = 0;
my ( $guard_start_x, $guard_start_y );
my $direction = 'N'; # N, E, S, W

chomp( my @dat = <> );

$width = length( $dat[0] );

foreach my $line ( @dat ) {
	my @row = split(//, $line );
	my $loc;
#	say join('', @row);

	if( ($loc = index( $line, '^' ) ) != -1 ) {
		$guard_start_x = $loc;
		$guard_start_y = $height;
	}

	push( @matrix, [@row]);
	$height++;
}

#say "guard is at $x $y";
# ya, i am not sure about why i put this here.
#$matrix[$guard_start_y][$guard_start_x] = "X";

# this is the baseline
&plot_path( $guard_start_x, $guard_start_y );
#&print_map( @matrix );

# @matrix contains the complete path then.  So, for every identified
# location that is in the count, place a blocker and see what happens,
# right?

# how do I figure out if I am in a loop?  I guess directionality is
# the key.  Perhaps using -, |, and + would help here.

# any E or W direction would be a -
# any N or S direction would be a |
# any direction turn would be a +

# the obstruction will be an O.  If O is seen twice then we know we
# have a loop, right?  but only if the O gets hit from the same
# direction, ya?  hmm.

# also, need to figure out how to make a deep copy of a matrix.

# fricken multidimensional arrays are a pain in the butt.  maybe a
# hashtable would be better.

my @path = &get_path;

#print join("\n", @path) . "\n";

foreach my $step (@path) {
	my( $step_x, $step_y ) = split( " x ", $step );
	my $tmp;
#	say "resetting map";
	&reset_map;

#	say "placing O at $step_x x $step_y";
	$matrix[$step_y][$step_x] = "O";

#	&print_map( @matrix );
#	say "testing $step_x $step_y";
	$direction = "N";
	my $looper = &plot_path( $guard_start_x, $guard_start_y );

#	&print_map( @matrix );

	if( $looper ) {
#		say "looper: $step";
		$count++;
	}
}

print "count: $count\n";

exit( 0 );

sub print_map {
	my @map = @_;
	for ( my $i = 0; $i < $height; $i++ ) {
		for( my $j = 0; $j < $width; $j++ ) {
			print $map[$i][$j];
		}
		print "\n";
	}
}

sub plot_path {
	my( $origin_x, $origin_y ) = @_;
	my $x = $origin_x;
	my $y = $origin_y;

	my $escaped = 0;
	my $looped = 0;

	my %again;

	while( ! $escaped && ! $looped ) {
		my $place = "$direction $x $y";
		if( $again{$place} ) {
			# so fuck, is this where a loop is detected?
# 			say "loop detected $place";
			$looped = 1;
			last;
		} else {
			$again{$place} = 1;

			if( $direction eq "N" ) {
				if( ($y-1) < 0 ) {
					$escaped = 1;
				} else {
					if( $matrix[$y-1][$x] eq "#" || $matrix[$y-1][$x] eq "O" ) {
						$direction = "E";
						$matrix[$y][$x] = "+";
					} else {
						$y -= 1;
						if( $matrix[$y][$x] eq '-' ) {
							$matrix[$y][$x] = "+";
						} else {
							$matrix[$y][$x] = "|";
						}
					}
				}
			} elsif( $direction eq "E" ) {
				if( ($x+1) >= $width ) {
					$escaped = 1;
				} else {
					if( $matrix[$y][$x+1] eq "#" || $matrix[$y][$x+1] eq "O" ) {
						$direction = "S";
						$matrix[$y][$x] = "+";
					} else {
						$x += 1;
						if( $matrix[$y][$x] eq '|' ) {
							$matrix[$y][$x] = "+";
						} else {
							$matrix[$y][$x] = "-";
						}
					}
				}
			} elsif( $direction eq "S" ) {
				if( ($y+1) >= $height ) {
					$escaped = 1;
				} else {
					if( $matrix[$y+1][$x] eq "#" || $matrix[$y+1][$x] eq "O" ) {
						$direction = "W";
						$matrix[$y][$x] = "+";
					} else {
						$y += 1;
						if( $matrix[$y][$x] eq '-' ) {
							$matrix[$y][$x] = "+";
						} else {
							$matrix[$y][$x] = "|";
						}
					}
				}
			} elsif( $direction eq "W" ) {
				if( ($x-1) < 0 ) {
					$escaped = 1;
				} else {
					if( $matrix[$y][$x-1] eq "#" || $matrix[$y][$x-1] eq "O" ) {
						$direction = "N";
						$matrix[$y][$x] = "+";
					} else {
						$x -= 1;
						if( $matrix[$y][$x] eq '|' ) {
							$matrix[$y][$x] = "+";
						} else {
							$matrix[$y][$x] = "-";
						}
					}
				}
			}
		}
	}

	return $looped;
}

sub get_path {
	my @path;

	for ( my $i = 0; $i < $height; $i++ ) {
		for( my $j = 0; $j < $width; $j++ ) {
			push( @path, "$j x $i" ) if $matrix[$i][$j] eq "-";
			push( @path, "$j x $i" ) if $matrix[$i][$j] eq "+";
			push( @path, "$j x $i" ) if $matrix[$i][$j] eq "|";
			push( @path, "$j x $i" ) if $matrix[$i][$j] eq "^";
		}
	}
	return @path;
}

sub reset_map {
	for ( my $i = 0; $i < $height; $i++ ) {
		for( my $j = 0; $j < $width; $j++ ) {
			$matrix[$i][$j] = "." if( $matrix[$i][$j] eq "-" ||
									  $matrix[$i][$j] eq "|" ||
									  $matrix[$i][$j] eq "+" ||
									  $matrix[$i][$j] eq "O" );
		}
	}
}
