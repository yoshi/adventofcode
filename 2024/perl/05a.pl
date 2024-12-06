#!perl -w

use strict;
use feature 'say';

my $section = 0;
my %rules;

my $middles = 0;

chomp( my @data = <> );

foreach my $line ( @data ) {
	if( $line eq "" ) {
		$section = 1;
		next;
	}
	if( $section == 0 ) {
		$rules{$line} = 1;
	} else {
		my @pages = split( ",", $line );
		if( &orderly( @pages ) ) {
			my $mid_index = $#pages / 2;
			$middles += $pages[$mid_index];
		}
	}
}

say "sum of middles: " . $middles;

exit( 0 );

sub orderly {
	my @pages = @_;
	my $is_orderly = 1;

	for( my $i = 1; $i <= $#pages; $i++ ) {
		if( ! defined $rules{$pages[$i-1] . "|" . $pages[$i]} ) {
			$is_orderly = 0;
		}
	}

	return $is_orderly;
}
