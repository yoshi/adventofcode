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
#	say "ops: " . $ops . " iterations: " . 2 ** $ops;

	for( my $i = 0; $i < 2 ** $ops; $i++ ) {
		my $equation = sprintf "op field: %.16b - ", $i;
		# we have our operator configuration, now we apply the ops to get a sample value.

		my $tmp_val = $terms[0];
		$equation .= "$tmp_val";
		for( my $j = 1; $j <= $ops; $j++) {
			if( ($i & (1 << $j - 1) ) == 0 ) {
				$equation .= " + $terms[$j]";
				$tmp_val += $terms[$j];
			} else {
				$equation .= " * $terms[$j]";
				$tmp_val *= $terms[$j];
			}
		}
		$equation .= " = $tmp_val (expected $val)\n";
		if( $tmp_val == $val ) {
			$truthy = 1;
#			print $equation;
		}
		last if $truthy;
	}

	#	print "\n";
	return $truthy;
}

