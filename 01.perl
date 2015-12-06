#!/usr/bin/perl

my( $floor ) = 0;
my( $number ) = 1;


while( <> ) {
	chomp;
	if( $_ eq "(" ) {
		$floor++;
	}

	if( $_ eq ")" ) {
		$floor--;
	}

	print qq($number $floor\n);
	$number++;
}
