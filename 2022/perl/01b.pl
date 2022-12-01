#!perl -w

chomp( my @dat = <> );
my $inc = 0;
my $prev;

my @elf_calories;
my $elf = 0;

for( my $i = 0; $i < scalar( @dat ); $i++ ) {
	if( $dat[$i] eq "" ) {
		$elf++;
		next;
	}
	$elf_calories[$elf] += $dat[$i];
}

#print qq(elf_count: ) . scalar( @elf_calories ) . qq(\n);

my @top_calories = sort { $b <=> $a } @elf_calories;

# for( my $i = 0; $i < scalar( @top_calories ); $i++ ) {
# 	print qq(elf: ) . $i . qq( ) . $top_calories[$i] . qq(\n);
# }

print qq(cal count: ) . ($top_calories[0] + $top_calories[1] + $top_calories[2]) . qq(\n);
