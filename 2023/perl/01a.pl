#!perl -w

chomp( my @dat = <> );

my $cv_sum = 0;
for( my $i = 0; $i < scalar( @dat ); $i++ ) {
    # get the first digit and the last digit of the string
    my $first = $1 if $dat[$i] =~ /^[a-z]*(\d)/;
    my $last = $1 if $dat[$i] =~ /(\d)[a-z]*$/;
    my $cv = $first * 10 + $last;
    $cv_sum += $cv;
}

print qq(out: $cv_sum\n);