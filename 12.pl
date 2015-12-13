#!perl -w

use Data::Dumper;
use JSON qw( from_json decode_json );
use Scalar::Util qw( looks_like_number );

my $input;

while( <> ) {
	chomp;
	$input .= $_;
}

print qq(cheaty_sum: ) . cheaty_sum( $input ) . qq(\n);
print qq(aw_sum: ) . aw_sum( $input ) . qq(\n);
print qq(red_sum: ) . red_sum( $input ) . qq(\n);

exit( 0 );

sub cheaty_sum {
	my( $json ) = @_;

	$json =~ s/[\[\]",:\}\{a-z]/ /g;
	$json =~ s/ +/ /g;

	return eval join( "+", split( / /, $json ));
}

# Ok, now do it the non-cheaty way...

sub aw_sum {
	my( $json ) = @_;
	my $sum = 0;
	my $data = from_json $json;

	Dumper( $data );

	return get_sum( $data );
}

sub red_sum {
	my( $json ) = @_;
	my $sum = 0;

	return $sum;
}

sub get_sum {
	my( $thing ) = @_;
	my( $sum ) = 0;

	if( ref($thing) eq "HASH" ) {
		print qq(this is a hash\n);
		foreach $key ( keys %{$thing} ) {
			print qq(following $key\n);
			$sum += get_sum( \%{$thing}{$key} );
		}
	}
	if( ref($thing) eq "ARRAY" ) {
		print qq(this is a array\n);
		foreach $item ( \@{$thing} ) {
			$sum += get_sum( $item );
		}
	}
	if( ( !ref( $thing ) || ref($thing) eq "SCALAR" ) && looks_like_number( $thing ) ) {
		print qq(this is a scalar\n);
		$sum = $thing;
	}

	print qq(gathered $sum\n);

	return $sum
}
