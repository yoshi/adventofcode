#!perl -w

chomp( my @dat = <> );
my $inc = 0;
my $prev;

my %op;

$op{ 'A' } = "Rock";
$op{ 'B' } = "Paper";
$op{ 'C' } = "Scissors";

my %me;

$me{ 'X' } = "Rock";
$me{ 'Y' } = "Paper";
$me{ 'Z' } = "Scissors";

my $total_score = 0;

for( my $i = 0; $i < scalar( @dat ); $i++ ) {
	my( $op_play, $me_play ) = split( ' ', $dat[$i] );

	my $round_score = 0;

	if( $op{ $op_play } eq $me{ $me_play } ) {
		$round_score += 3;
	} elsif( ( $op{ $op_play } eq "Rock" && $me{ $me_play } eq "Paper" ) ||
			 ( $op{ $op_play } eq "Paper" && $me{ $me_play } eq "Scissors" ) ||
			 ( $op{ $op_play } eq "Scissors" && $me{ $me_play } eq "Rock" ) ) {
		$round_score += 6;
	}

	$round_score += 1 if( $me{ $me_play } eq "Rock" );
	$round_score += 2 if( $me{ $me_play } eq "Paper" );
	$round_score += 3 if( $me{ $me_play } eq "Scissors" );

	#print qq( $op_play $me_play $round_score\n);

	$total_score += $round_score;
}
print qq(total_score: $total_score\n);

#print qq(samwise elf: ) . $samwise . qq( ) . $elf_calories[$samwise] . qq(\n);
