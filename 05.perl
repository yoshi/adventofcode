#!/usr/bin/perl -w

my $nice_count = 0;
my $naughty_count = 0;

my $better_nice_count = 0;
my $better_naughty_count = 0;

while( <> ) {
	chomp;

	$string = $_;

	if(	&nice_vowel( $string )
		&& &nice_double( $string )
		&& ! &naughty_pattern( $string )
		) {
		$nice_count += 1;
	} else {
		$naughty_count += 1;
	}

	if( &nice_pairs( $string ) && &nice_sandwich( $string ) ) {
		$better_nice_count += 1;
	} else {
		$better_naughty_count += 1;
	}
}

print qq(nice: $nice_count\n);
print qq(naughty: $naughty_count\n);
print qq(better nice: $better_nice_count\n);
print qq(better naughty: $better_naughty_count\n);

exit( 0 );

sub nice_pairs {
	my @chars = split( // );
	my $has_pairs = 0;

	my $len = scalar( @chars );

	for( my $i = 0; $i < scalar( @chars ) - 3; $i += 1) {
		my $couple = join( '', @chars[$i..$i+1]);
		my $rest = join( '', @chars[$i+2..$len-1]);

		if( index( $rest, $couple ) != -1 ) {
			$has_pairs = 1;
		}
	}

	return $has_pairs;
}

sub nice_sandwich {
	my @chars = split( // );
	my $has_sandwich = 0;
	my $sandwich_count = 0;

	for( $i = 0; $i < scalar( @chars ) - 2; $i += 1) {
		if( $chars[$i] eq $chars[$i + 2] ) {
			$has_sandwich = 1;
			$sandwich_count += 1;
		}
	}

	return $has_sandwich;
}

sub nice_vowel{
	# if the string contains three vowels, then it's nice
	my @chars = split( // );
	my $vowel_count = 0;
	my $has_three_vowels = 0;

	foreach $char (@chars ) {
		if( $char =~ /[aeiou]/ ) {
			$vowel_count += 1;
		}
	}

	if( $vowel_count >= 3 ) {
		$has_three_vowels = 1;
	}

	return $has_three_vowels;
}

sub nice_double {
	# if the string contains any double characters, then it's nice
	my @chars = split( // );
	my $prev_char = '';
	my $has_double = 0;

	foreach $char ( @chars ) {
		if ($char eq $prev_char ){
			$has_double = 1;
		}
		$prev_char = $char;
	}
	return $has_double;
}

sub naughty_pattern {
	#if the string contains ab, cd, pq, or xy it's naughty
	my $has_bad_pairs = 0;

	if( $_ =~ /ab/ || $_ =~ /cd/ || $_ =~ /pq/ || $_ =~ /xy/ ) {
		$has_bad_pairs = 1;
	}

	return $has_bad_pairs;
}
