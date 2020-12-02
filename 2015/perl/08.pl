#!/usr/bin/perl -w

my( $code_lengths ) = 0;
my( $memory_lengths ) = 0;
my( $fattened_lengths ) = 0;

while(<>) {
	chomp;

	my( $code_str ) = $_;
	my( $memory_str );
	my( $fattened_str );
	my( $code_length );
	my( $memory_length );
	my( $fattened_length );

	$code_length = length( $code_str );

	$memory_str = $code_str;

	$memory_str =~ s/^"//g;
	$memory_str =~ s/"$//g;
	$memory_str =~ s/\\"/"/g;
	$memory_str =~ s/\\\\/\//g;
	$memory_str =~ s/\\x../X/g;

	$memory_length = length( $memory_str );

	$fattened_str = $code_str;

	$fattened_str =~ s/\\/\\\\/g; # escape backslashes
	$fattened_str =~ s/"/\\"/g; # escape quotes
	$fattened_str =~ s/^/"/g; # add beginning quote
	$fattened_str =~ s/$/"/g; # add ending quote

	$fattened_length = length( $fattened_str );

	$code_lengths += $code_length;
	$memory_lengths += $memory_length;
	$fattened_lengths += $fattened_length;

	print qq($code_str: $code_length\n);
	print qq($memory_str: $memory_length\n);
	print qq($fattened_str: $fattened_length\n);
}

print qq(code_lengths: $code_lengths\n);
print qq(memory_lengths: $memory_lengths\n);
print qq(fattened_lengths: $fattened_lengths\n);

print qq(memory_delta: ) . ($code_lengths - $memory_lengths ) . qq(\n);
print qq(fattened_delta: ) . ($fattened_lengths - $code_lengths ) . qq(\n);
