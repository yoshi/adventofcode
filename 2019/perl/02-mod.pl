#!perl

use lib qw(.);

use Intcode;

my $ic_data;

while( <> ) {
	chomp;

	$ic_data = $_;
}

my $ic1 = Intcode->new( $ic_data );

$ic1->print_tape();

$ic1->poke( 1, 12 );
$ic1->poke( 2, 2 );

$ic1->run();

my $ans1 = $ic1->peek( 0 );

print "sample run: $ans1\n";

for( $i = 0; $i < 100; $i++ ) {
	for( $j = 0; $j < 100; $j++ ) {
		my $ic = Intcode->new( $ic_data );
		$ic->poke( 1, $i );
		$ic->poke( 2, $j );

		$ic->run();

		my $ans = $ic->peek( 0 );
		print " $i $j : $ans\n";
	}
}

exit( 0 );
