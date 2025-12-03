#!perl

use strict;
use warnings;

chomp( my @dat = <> );

my $result = 0;
my $evals = 0;
my $fold_evals = 0;
my $good_folds = 0;

foreach my $line ( @dat ) {
	my (@ranges) = split /,/, $line;

	foreach my $range (@ranges) {
		my( $start, $end ) = split /-/, $range;

		for( my $id = $start; $id <= $end; $id++ ) {
			$evals++;
#			next if( length( $id ) % 2 != 0 );
			if( &nfolds($id) ) {
#				print qq($id nfolds\n);
				$result += $id;
			}
		}
	}
}

print qq(evals: $evals\n);
print qq(fold_evals: $fold_evals\n);
print qq(good_folds: $good_folds\n);
print qq(result: $result\n);

exit( 0 );

sub bifolds() {
	my( $id ) = @_;
	my( $len ) = length( $id );
	if( substr($id, 0, $len / 2) eq substr($id, $len/2, $len) ) {
		return 1;
	} else {
		return 0;
	}
}

sub contains_singles {
	my( $id ) = @_;
	my @digs = split("", $id);
	my %dh;

	foreach my $dig (@digs) {
		$dh{$dig}++;
	}

	foreach my $dv (sort values %dh) {
		return 1 if $dv == 1;
	}

	return 0;
}

sub nfolds() {
	my( $id ) = @_;
	my( $len ) = length( $id );

	return 0 if( &contains_singles($id));

	for( my $nlen = int($len / 2); $nlen > 0; $nlen -- ) {
		if( $len % $nlen == 0 ) {
#			print "id: $id nlen: $nlen: ";
			my( @segments ) = ($id =~ /(\d{$nlen})/g);
#			print join(" ", @segments) . "\n";
			
			#			while( my $segment = $id =~ /\G(\w{$nlen})*?/g ) {
#				push @segments, $segment;
#				print qq(segment: $segment\n);

			$fold_evals ++;
			if( &multieq(@segments) ) {
				$good_folds++;
				return 1;
			}
		}
	}
	return 0;
}

sub multieq() {
	my( @list ) = @_;
	my $item = $list[0];
	my $is_eq = 1;
	
	for( my $i = 1; $i < scalar(@list); $i++ ) {
		$is_eq = 0 if $list[$i] ne $item;
	}

	return $is_eq;
}
