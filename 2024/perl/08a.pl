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

my $maxnodes = 0;

foreach my $k (sort keys %antennas) {
	my $ant_count = scalar( @{$antennas{$k}} );
	say "$k: $ant_count";
	$maxnodes += 2 * ($ant_count * ($ant_count - 1));

	# subtract the number of nodes that are out of bounds
	my @ant_locs = @{$antennas{$k}};

	if( scalar( @ant_locs ) == 2 ) {
		my ( $a, $b ) = @ant_locs;
		say( "a: $a b: $b" );

		my ($ab_mx, $ab_my) = &slope( $a, $b );
		say( "ab_mx: $ab_mx ab_my: $ab_my" );

		$maxnodes-- if( ! &is_in_box( $a, $ab_mx, $ab_my));
		$maxnodes-- if( ! &is_in_box( $b, $ab_mx, $ab_my));
	} elsif( scalar( @ant_locs ) == 3 ) {
		my ( $a, $b, $c ) = @ant_locs;
		say( "a: $a b: $b c: $c" );

		my( $ab_mx, $ab_my ) = &slope($a, $b);
		my( $bc_mx, $bc_my ) = &slope($b, $c);
		my( $ca_mx, $ca_my ) = &slope($c, $a);

		say( "ab_mx: $ab_mx ab_my: $ab_my" );
		$maxnodes-- if( ! &is_in_box( $a, $ab_mx, $ab_my));
		$maxnodes-- if( ! &is_in_box( $b, $ab_mx, $ab_my));

		say( "bc_mx: $bc_mx bc_my: $bc_my" );
		$maxnodes-- if( ! &is_in_box( $b, $bc_mx, $bc_my));
		$maxnodes-- if( ! &is_in_box( $c, $bc_mx, $bc_my));

		say( "ca_mx: $ca_mx ca_my: $ca_my" );
		$maxnodes-- if( ! &is_in_box( $c, $ca_mx, $ca_my));
		$maxnodes-- if( ! &is_in_box( $a, $ca_mx, $ca_my));
	} elsif( scalar( @ant_locs ) == 4 ) {
		# 4 = 12 (n = 3n) AB BC AC AD BD CD
		
		my ( $a, $b, $c, $d ) = @ant_locs;
		say( "a: $a b: $b c: $c d: $d" );

		my( $ab_mx, $ab_my ) = &slope($a, $b);
		my( $bc_mx, $bc_my ) = &slope($b, $c);
		my( $ca_mx, $ca_my ) = &slope($c, $a);
		my( $ad_mx, $ad_my ) = &slope($a, $d);
		my( $bd_mx, $bd_my ) = &slope($b, $d);
		my( $cd_mx, $cd_my ) = &slope($c, $d);

		say( "ab_mx: $ab_mx ab_my: $ab_my" );
		$maxnodes-- if( ! &is_in_box( $a, $ab_mx, $ab_my));
		$maxnodes-- if( ! &is_in_box( $b, $ab_mx, $ab_my));

		say( "bc_mx: $bc_mx bc_my: $bc_my" );
		$maxnodes-- if( ! &is_in_box( $b, $bc_mx, $bc_my));
		$maxnodes-- if( ! &is_in_box( $c, $bc_mx, $bc_my));

		say( "ca_mx: $ca_mx ca_my: $ca_my" );
		$maxnodes-- if( ! &is_in_box( $c, $ca_mx, $ca_my));
		$maxnodes-- if( ! &is_in_box( $a, $ca_mx, $ca_my));

		say( "ad_mx: $ad_mx ad_my: $ad_my" );
		$maxnodes-- if( ! &is_in_box( $a, $ad_mx, $ad_my));
		$maxnodes-- if( ! &is_in_box( $d, $ad_mx, $ad_my));

		say( "bd_mx: $bd_mx bd_my: $bd_my" );
		$maxnodes-- if( ! &is_in_box( $b, $bd_mx, $bd_my));
		$maxnodes-- if( ! &is_in_box( $d, $bd_mx, $bd_my));

		say( "cd_mx: $cd_mx cd_my: $cd_my" );
		$maxnodes-- if( ! &is_in_box( $c, $cd_mx, $cd_my));
		$maxnodes-- if( ! &is_in_box( $d, $cd_mx, $cd_my));
	}

}

say "maxnodes: $maxnodes";

say "box - width: $width height: $height";

say "count: $count";

foreach my $a (sort keys %antennas) {
	say "$a " . join(",", @{$antennas{$a}});
}

exit( 0 );

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
