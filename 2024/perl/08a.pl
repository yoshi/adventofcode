#!perl -w

use strict;
use feature 'say';

my $height = 0;
my $width = 0;
my $count = 0;
my %ants;
my %antennas;

chomp( my @dat = <> );

$width = length( $dat[0] );

foreach my $line ( @dat ) {
	my @row = split(//, $line );

	for( my $i = 0; $i <= $#row; $i++ ) {
		if( $row[$i] ne  "." ) {
			my $ant = $i . "x" . $height;
			push( @{$antennas{$row[$i]}}, $ant);
			$ants{$ant} = 1;
		}
	}

#	push( @antennas, [@row]);
	$height++;
}

say "width: $width height: $height";

my @antinodes;

foreach my $k (sort keys %antennas) {
	my $ant_count = scalar( @{$antennas{$k}} );

	say "$k: " . join(",", @{$antennas{$k}});

	# actually, this is dumb.
	#$maxnodes += 2 * ($ant_count * ($ant_count - 1));

	# create nodes for every line segment.  but only count them if
	# they do not exist as an antenna or another node.  so just create
	# them, i suppose.

	# subtract the number of nodes that are out of bounds

	my @ant_locs = @{$antennas{$k}};
	if( scalar( @ant_locs ) == 2 ) {
		my ( $a, $b ) = @ant_locs;
		say( "a: $a b: $b" );

		push( @antinodes, &ant_nodes( $a, $b ) );
	} elsif( scalar( @ant_locs ) == 3 ) {
		my ( $a, $b, $c ) = @ant_locs;
		say( "a: $a b: $b c: $c" );

		push( @antinodes, &ant_nodes( $a, $b ) );
		push( @antinodes, &ant_nodes( $b, $c ) );
		push( @antinodes, &ant_nodes( $a, $c ) );
	} elsif( scalar( @ant_locs ) == 4 ) {
		# 4 = 12 (n = 3n) AB BC AC AD BD CD
		my ( $a, $b, $c, $d ) = @ant_locs;
		say( "a: $a b: $b c: $c d: $d" );

		push( @antinodes, &ant_nodes( $a, $b ) );
		push( @antinodes, &ant_nodes( $b, $c ) );
		push( @antinodes, &ant_nodes( $a, $c ) );
		push( @antinodes, &ant_nodes( $a, $d ) );
		push( @antinodes, &ant_nodes( $b, $d ) );
		push( @antinodes, &ant_nodes( $c, $d ) );
	}

}

my %node_uh;

foreach my $an (@antinodes) {
	$node_uh{$an} = 1 if( ! defined( $ants{$an} ) );
}

say "count: " . scalar( keys( %node_uh ) );

exit( 0 );

sub ant_nodes {
	my( $p1, $p2 ) = @_;
	my( $mx, $my ) = &slope( $p1, $p2 );
	my @nodes;

	my( $p1x, $p1y ) = split( "x", $p1 );
	my( $p2x, $p2y ) = split( "x", $p2 );

	$mx = $p1x - $p2x;
	$my = $p1y - $p2y;

	my( $n1x, $n1y, $n2x, $n2y, $n1, $n2 );
	$n1x = $p1x + $mx;
	$n1y = $p1y + $my;

	$n2x = $p2x - $mx;
	$n2y = $p2y - $my;

	if( $n1x >= 0 && $n1y >= 0 && $n1x < $width && $n1y < $height ) {
		push( @nodes, join( "x", $n1x, $n1y ) );
	}

	if( $n2x >= 0 && $n2y >= 0 && $n2x < $width && $n2y < $height ) {
		push( @nodes, join( "x", $n2x, $n2y ) );
	}

	say "p1: $p1 p2: $p2 nodes: " . join( " ", @nodes );

	return @nodes;

	# p1: 1x1 p2: 2x2
	# slope: -1 -1
	# n1 (p1+m): 0x0 (p2-m)n2: 3x3
}

sub is_in_box {
	my( $p, $mx, $my ) = @_;
	my( $px, $py ) = split( "x", $p );
	my $in_box = 0;

	my( $pre_x, $pre_y );
	my( $post_x, $post_y );

	$pre_x = $px - $mx;
	$pre_y = $py - $my;
	my $pre = $pre_x . "x" . $pre_y;
	$post_x = $px + $mx;
	$post_y = $py + $my;
	my $post = $post_x . "x" . $post_y;

	if( $post_x < $width && $pre_x >= 0 &&
		$post_y < $height && $pre_y >= 0 ) {
		$in_box = 1;
	}

	say "in_box: $px $py $mx $my $in_box";

	if( defined $ants{$pre} || defined $ants{$post} ) {
		say "$pre $post";
		say "removing because it is a dup loc";
		$in_box = 0;
	}
	return $in_box;
}

sub slope {
	my( $p1, $p2 ) = @_;
	my( $x, $y );

	my ($p1x, $p1y) = split("x", $p1);
	my ($p2x, $p2y) = split("x", $p2);

	$x = $p1x - $p2x;
	$y = $p1y - $p2y;

	return( $x, $y);
}
# ant: freq x y

# ............
# ........0...
# .....0......
# .......0....
# ....0.......
# ......A.....
# ............
# ............
# ........A...
# .........A..
# ............
# ............

# 2 = 2 (n = (n-1)n) AB
# 3 = 6 (n = (n-1)n) AB BC CA
# 4 = 12 (n = 3n) AB BC AC AD BD CD

# calculate slope.  create two nodes.
# slope is vertical, horizontal, positive, negative
