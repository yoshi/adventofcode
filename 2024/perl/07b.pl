#!perl -w

use strict;
use feature 'say';

my $val_sum = 0;

chomp( my @dat = <> );

foreach my $line ( @dat ) {
	my ($val, @terms) = split( " ", $line );

	$val =~ s/://;

	if( &is_truthy( $val, @terms ) ) {
#		say "adding $val";
		$val_sum += $val;
	}
}

say "val_sum: $val_sum";

exit( 0 );

sub is_truthy {
	my( $val, @terms ) = @_;
	my $ops = $#terms;
	my $truthy = 0;

#	say "$val: " . join( " ", @terms );
#	say "ops: " . $ops . " iterations: " . 2 ** ($ops+1);

	for( my $i = 0; $i < 2 ** ($ops*2); $i++ ) {
		my $equation = sprintf "op field: %.16b - ", $i;
		my $tmp_val = $terms[0];
		my $is_nop = 0;
		$equation .= "$tmp_val";
		for( my $j = 1; $j <= $ops; $j++) {
			my $opcode = ($i & (0b11 << (($j - 1) * 2)) ) >> (($j - 1) * 2);
			#say "opcode: $opcode";
			if( $opcode == 0 ) {
				$equation .= " + $terms[$j]";
				$tmp_val += $terms[$j];
			} elsif( $opcode == 1 ) {
				$equation .= " * $terms[$j]";
				$tmp_val *= $terms[$j];
			} elsif( $opcode == 2 ) {
				$equation .= " || $terms[$j]";
				$tmp_val = "$tmp_val" . $terms[$j];
			} else {
				$equation .= " nop $terms[$j]";
				$is_nop = 1;
			}
		}
		if( ! $is_nop ) {
			$equation .= " = $tmp_val (expected $val)\n";
#			print $equation;
			if( $tmp_val == $val ) {
#				say "truthy found on iteration $i";
				$truthy = 1;
			}
		}
		last if $truthy;
	}

	#	print "\n";
	return $truthy;
}
