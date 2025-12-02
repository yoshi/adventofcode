#!perl

use strict;
use warnings;

chomp( my @dat = <> );

my $result = 0;

foreach my $line ( @dat ) {
	my (@ranges) = split /,/, $line;

	foreach my $range (@ranges) {
		my( $start, $end ) = split /-/, $range;

		for( my $id = $start; $id <= $end; $id++ ) {
#			next if( length( $id ) % 2 != 0 );
			if( &nfolds($id) ) {
#				print qq($id nfolds\n);
				$result += $id;
			}
		}
	}
}

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

sub nfolds() {
	my( $id ) = @_;
	my( $len ) = length( $id );

	for( my $nlen = 1; $nlen <= $len / 2; $nlen ++ ) {
		if( $len % $nlen == 0 ) {
#			print "id: $id nlen: $nlen: ";
			my( @segments ) = ($id =~ /(\d{$nlen})/g);
#			print join(" ", @segments) . "\n";
			
			#			while( my $segment = $id =~ /\G(\w{$nlen})*?/g ) {
#				push @segments, $segment;
#				print qq(segment: $segment\n);

			if( &multieq(@segments) ) {
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
