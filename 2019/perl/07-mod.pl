#!perl

use lib qw(.);

use Intcode;

my $debug = 0;

my $ic_data;

while( <> ) {
	chomp;

	$ic_data = $_;
}

#my $ictest = Intcode->new( $ic_data );

#$ictest->print_tape();

my @perms = &get_perms( "{0,1,2,3,4}" );
my $perm;
my $high_output = 0;

my $input = 0;

foreach $perm (@perms) {
	my @seq = split "", $perm;
	my $output = 0;
	my @input_stream, @output_stream;

	push @output_stream, 0;

	for( my $i = 0; $i < 5; $i++ ) {
		push @input_stream, shift @seq;
		push @input_stream, shift @output_stream;
		my $ic = Intcode->new( $ic_data );
		$ic->istream( \@input_stream );
		$ic->ostream( \@output_stream );
		$ic->run();
	}

	$output = shift @output_stream;

	if( $output > $high_output ) {
		print "perm: $perm output: $output\n";
		$high_output = $output;
	}
}

exit(0);

@perms = &get_perms( "{5,6,7,8,9}" );

foreach $perm ( @perms ) {
	my @phases = split "", $perm;
	my $output = 0;

	my $ica = Intcode->new( $ic_data );
	my $icb = Intcode->new( $ic_data );
	my $icc = Intcode->new( $ic_data );
	my $icd = Intcode->new( $ic_data );
	my $ice = Intcode->new( $ic_data );



	my $state = 0;

	my @tape_deck;
	my @pcs;

	# initialize this run
	my @tape0 = @master_tape;
	$tape_deck[0] = \@tape0;
	$pc[0] = 0;
	my @tape1 = @master_tape;
	$tape_deck[1] = \@tape1;
	$pc[1] = 0;
	my @tape2 = @master_tape;
	$tape_deck[2] = \@tape2;
	$pc[2] = 0;
	my @tape3 = @master_tape;
	$tape_deck[3] = \@tape3;
	$pc[3] = 0;
	my @tape4 = @master_tape;
	$tape_deck[4] = \@tape4;
	$pc[4] = 0;

	$input = 0;

	while( $state != 99 ) {
		($output, $state, $pc[$i], @{$tape_deck[$sym_ix]}) =
			&sym( $phases[$sym_ix], $input, $pc[$i], @{$tape_deck[$sym_ix]} );
		print "perm: $perm input: $input output: $output state: $state pc: $pc[$i]\n";
		$input = $output;
		$sym_ix = ($sym_ix + 1) % 5;
	}

	print "perm: $perm output: $output state: $state\n";
}

exit( 0 );

sub get_perms {
	my( $range )= @_;
	my @perms;

	my @uh = glob $range x 5;

	foreach( @uh ){
		my %h = map { $_ => 1} split "", $_;

		my @hk = keys %h;
		next if $#hk != 4;

		push @perms, $_;
	}

	return @perms;
}
