#!/usr/bin/perl -w

my( $sfowp ) = 0;
my( $ribbon ) = 0;

while( <> ) {
	chomp;

	# parse box
	($l, $w, $h) = split( "x" );

	print qq($l $w $h\n);

	my( $smallest_side ) = findmin( $l*$w, $w*$h, $h*$l );

	my( $surface ) = 2 * $l * $w + 2 * $w * $h + 2 * $h * $l;

	my( $total ) = $smallest_side + $surface;

	my( $minp ) = findminp( $l, $w, $h );

	my( $volume ) = $l * $w * $h;

	print qq($l $w $h : $smallest_side + $surface = $total : $minp $volume\n);

	$sfowp += $smallest_side + $surface;

	$ribbon += $minp + $volume;
}

print qq(The elves need $sfowp square feet of wrapping paper and $ribbon feet of ribbon.\n);

exit(0);

sub findmin {
	my( @list ) = @_;

	my( $min ) = 1000;

	$min = $list[0];
	foreach $i (@list) {
		$min = $i if $i < $min;
	}
	return $min;
}

sub findminp {
	my( @list ) = @_;

	# find the two smallest numbers;
	@list = sort {$a <=> $b} @list;

	return 2 * $list[0] + 2 * $list[1];

}
