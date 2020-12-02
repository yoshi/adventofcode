#!perl -w

use lib qw(.);

use Intcode;

while( <> ) {
	chomp;

	$ic_data = $_;
}

my $ic = Intcode->new( $ic_data );

if( $ic_data eq $ic->tapestr() ) {
	print qq(data is symetric\n);
}

$ic->poke( 1, 12 );
$ic->poke( 2, 2 );

$ic->run();

print $ic->peek( 0 );
