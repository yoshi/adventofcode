#!perl -w

my $count = 0;

chomp( my @dat = <> );

foreach $line ( @dat ) {
	my( @parts ) = split( "-", $line );

	print $parts[$#parts] . qq(\n);
}

print "count: $count\n";

exit( 0 );
