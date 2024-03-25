#!perl -w

# I guess we can look at this as a search from the beginning and for terms.
# So, the term in the closest position to the left is the first term and the last for the right.

chomp( my @dat = <> );

my %terms = (
    "one" => 1,
    "two" => 2,
    "three" => 3,
    "four" => 4,
    "five" => 5,
    "six" => 6,
    "seven" => 7,
    "eight" => 8,
    "nine" => 9,
);

my $cv_sum = 0;
for( my $i = 0; $i < scalar( @dat ); $i++ ) {
    my @toks = $dat[$i] =~ /(\d|one|two|three|four|five|six|seven|eight|nine)/g;
    my @rtoks = (reverse $dat[$i]) =~ /(\d|enin|thgie|neves|xis|evif|ruof|eerht|owt|eno)/g;

    $toks[0] = $terms{$toks[0]} if( $terms{$toks[0]} );
    $rtoks[0] = $terms{reverse $rtoks[0]} if( $terms{reverse $rtoks[0]} );

    my $cv = $toks[0] * 10 + $rtoks[0];
    print qq($dat[$i] : $toks[0] $rtoks[0] $cv\n);
    $cv_sum += $cv;
}

print qq(out: $cv_sum\n);