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

my $samwise = -1;
my $max_cal = 0;

for( my $i = 0; $i < scalar( @elf_calories ); $i++ ) {
	# print qq(elf: ) . $i . qq( ) . $elf_calories[$i] . qq(\n);
	if( $max_cal < $elf_calories[$i] ){
		$max_cal = $elf_calories[$i];
		$samwise = $i;
	}
}

print qq(samwise elf: ) . $samwise . qq( ) . $elf_calories[$samwise] . qq(\n);
