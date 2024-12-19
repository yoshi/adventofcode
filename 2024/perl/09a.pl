#!perl -w

use strict;
use feature 'say';

my $blocks;
my $checksum = 0;

chomp( my @dat = <> );

$blocks = &decode( $dat[0] );

say &defrag( $blocks );

&calc_checksum;

say "$checksum";

exit( 0 );

sub decode {
	my( $map ) = @_; 
	my( $blocks );
	my( $pos ) = 0;
	my( $writing ) = 1;

	foreach my $f (split( //, $map) ) {
		if( $writing ) {
			# writing blocks
			$blocks .= "*" x $f;
			$writing = 0;
		} else {
			# skipping blocks
			$blocks .= "." x $f;
			$writing = 1;
		}
		
	}

	return $blocks;
}

sub defrag {
	my( $blocks ) = @_;

	return $blocks;
}

sub calc_checksum {
	return 0;
}
