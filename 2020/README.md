# Advent of Code Worklog 2020

## Progress
Here's my done-ness to date:

| Day | Part 1      | Part 2 |
|-----|-------------|--------|
| 01  | Done        | Done   |
| 02  | Done        | Done   |
| 03  | Done        | Done   |
| 04  | Done        | Done   |
| 05  | Done        | Done   |
| 06  | Done        | Done   |
| 07  | Done        | Done   |
| 08  | Done        | Done   |
| 09  | Done        | Done   |
| 10  | Done        | Done   |
| 11  | In Progress |        |
| 12  |             |        |
| 13  |             |        |
| 14  |             |        |
| 15  |             |        |
| 16  |             |        |
| 17  |             |        |
| 18  |             |        |
| 19  |             |        |
| 20  |             |        |
| 21  |             |        |
| 22  |             |        |
| 23  |             |        |
| 24  |             |        |
| 25  |             |        |

## Log
### Day 10 (https://adventofcode.com/2020/day/10) ###

I think this day's problem is deceptively simple.  I think I just need to sort the numbers, compute the offsets and then multiply the counts of those offsets to get a checksum.  Not sure what's supposed to be hard about this.

Well, ok, you have to be able to add elements to the beginning and end of an array.

Part two is funny because there seems to be multiple ways to skin the cat.  Which is a weird statement.  Basically, there are, for an input size of 97, 96192759682482119853328425949563698712343813919172976158104477319333745612481875498805879175589072651261284189679678167647067832320000000000000000000000 combinations (I think) of those numbers, but certainly a hell of a lot less combinations for valid configurations.  So, we're left with having to iterate on valid combinations.  But hold up, n! is used to generate the number of combinations with respect to ordering.  What we need is to determine all combinations of ordered digits that can be removed while adhering to the validity rule.  So a series of 97 bits would generate all possibilities, and would have 158456325028528675187087900671 + 1 combinations.  A 97 layer binary tree could house the possibilities, but still seems like a lot of work.

Perhaps a more iterative approach would be better.  Get all slots from i (being the current index) that have a difference of three or less.

Ok, it is dumb how long i'm spending on this.

Options:

Doing that many combinations and then figuring out what is valid isn't gonna work.  We need to create valid combinations on the go.

What about counting branches and joins?

Or... We need a cluster finder.

While a crazy amount of investigation ended up fruitless, all the logic came down to determining the cost of three subgraphs comprised of runs of 3, 4, and 5 numbers.  So the cost of a sequental run of 3 numbers is 2 (a,b,c and a,c are the variations), 4 numbers is 4 (a,b,c,d, a,b,d, a,c,d, a,d), and 5 numbers is 7 (a,b,c,d,e, a,c,d,e, a,b,d,e, a,b,e, a,b,c,e, a,c,e, a,d,e, a,e).  Take all of the sequential runs, cost them out and multiply the results and boom.  done.

The biggest cluee to the solution is the first part of the problem where we were asked to find all counts of offsets.  I'm an expert at making things complicated. :)

#### Julia ####

To add an element to the beginning of an array, use `pushfirst!()` and to add an element to the end, use `append!()`.

### Day 9 (https://adventofcode.com/2020/day/9) ###

Yow, this one was pretty simple.  Basically, take a giant list of numbers and verify that for a floating window of 25 numbers, ensure that the number that follows that window is the sum of two terms in that window.

Oh, read the fricken instructions and don't return the result of an incorrect computation.

#### Julia ####

The only julia specific things that I took advantage of was the string parsing function and fiddling with ranges.

On part two, I got a little more fancy and used `view` for creating a slice, `reduce` for applying a function across this slice and `sort` to sort the numbers in a list.

### Day 8 (https://adventofcode.com/2020/day/8) ###

Klytus I'm bored - what plaything can you offer me today?

I really do believe Max von Sydow is an amazing actor.  From Ming the Merciless to Pardot Kynes and all points in-between.

The eighth day!  Oh gods, it's another assembler problem.  But maybe perhaps it is not.  Looks like an accumilator (A) needs to be maintained and we may as well use a program counter (PC) as well.

#### Julia ####

Fancy or non-fancy, that is the question.  Lets go for non-fancy and see what emerges.

### Day 7 (https://adventofcode.com/2020/day/7) ###

Ok, day 7 is about more regex stuff in conjunction with graph construction and traversal.

While the first day is fairly straight foward if the noise is stripped away, I have the suspiciion that the noise will be necessary on part two of the problem and may be the beginning of some greater body of work in subsequent days.

So, we have rules, one per line.

A -> n * B, m * C, ...

They look like production rules, which is familiar from previous years.

For a given bag, shiny gold, how many uniquely colored bags contain it?  The answer is 4 from the sample rule set.

The second part of the problem is about measuring the number of bags stored by a particular bags.  Being lazy, and using meta programming for string alteration and evaluation seems to do the trick.

#### Julia ####

Further work on regexes and Meta.parse with a subsequent eval() worked well, but feels pretty darn brute force.  The answers were correct, but at what cost... AT WHAT COST??? :)

### Day 6 (https://adventofcode.com/2020/day/6) ###

Hmm I neglected to write notes for this day for some reason.  I'll come back and revisit.


### Day 5 (https://adventofcode.com/2020/day/5) ###

Yay, binary number parsing and manipulation.  I suppose we need to regex transform the string into two parts.  The first seven contain the row and the last 3 contain the column.

For reference, seat id = row * 8 + column.

#### Julia ####

So, lets get the regexes going.  I don't know if julia can do multiline regexes like in perl for readability.  That will be the first thing to investigate.  If not, then ah well, I will have to take more care in the construction of the regex.  Ah, cool, looks like it accepts the same options as perl regexes, so 'x' works.

For reference: https://docs.julialang.org/en/v1/manual/strings/#Regular-Expressions

Lets also get comfortable with using the 'nothing' keyword as a return value.

`occursin` tells you if the regex succeeds and returns a boolean value.

`match` tells you if the regex succeeds and returns how it succeeded.  If it is unsuccessful, then it returns ```nothing```.

Actually, it ends up that all that is needed is a regex to split out the top 7 bits and the lower 3 bits to get the data map.  After that, transforming the characters using `tr` would be appropriate in perl, but in julia, doing `replace` twice for each term worked out.  Then there's the computation of the seat number using arithmatic.

For the second part, maintaining a map of the seats allowed for straight forward identification of the missing seat, which is the answer.

### Day 4 (https://adventofcode.com/2020/day/4) ###

This problem is all about joining lines together to make records.  Part two may be about hashtables, but we will come to that.

Valid records are those that contain 8 entries or 7 entries without 'cid'

Part 2 requires semantic validation of the data associated with the data.

#### Julia ####

We need to iterate over the input to split records on blank lines and the end of the data file.  So, join all lines together that are within a record and create new records when appropriate.

One thing to check and to be ever vigilient about is to scrutinize boolean operators and conditions.  Another thing is to look at expected values from parses and independently validate the chain of data filtration/transformation in between phases.  All this because, I failed to both of those things when I first started the problem.  Heh.

For part 2, we will need to take the passport, consume into a hashtable and perform appropriate data validations.

### Day 3 (https://adventofcode.com/2020/day/3) ###

I think the main deal with this problem is just using mod to wrap across replicates of array indexes.  Seems straight forward enough.

For the first part of the problem, there was only one slope that needed to be considered, 3 right/1 down.

For the second part of the problem, there are multiple slopes that need to be evaluated at the same time.  An approach could be to structure some general purpose slope traversal kind of thing, but I think for this, I'll just keep it simple.  However, if in a future problem, there IS some need for a general purpose arbritary slope traversal kind of thing needed, then I'll re-write this solution as a test bed for inclusion into bigger problems.

#### Julia ####

`mod` is a common function in all programming languages.  In this case, we need to wrap the array index at the string length boundary.  The tricky bit with julia is that by default arrays start with 1, so we need to take that into account by using the `arr[begin]` syntax to ensure that for what ever index we start with, that we're working from the beginning.  There's a whole thing with ensuring that string operations work on non single byte characters, but I don't think it is worth worrying about for this problem.

For the second part, I will just compute the slopes in a hard coded way.  Ugh.

And as always, maintaining variables for similar conditions gets fiddly quick.  But at least things work.

### Day 2 (https://adventofcode.com/2020/day/2) ###

This problem boils down to extracting structured data from a file consisting of a range, a symbol, and a string to be evaluated for constraints.  This is a perfect opportunity to leverage the regex capabilities of the language being used.  An alternative would be to perform successive splits of the data on delimiter boundaries.  In C, this would leverage strchr to find the index of the delimiter and then strncpy calls using the indexes.

The structure of the data is `MIN_OCCURANCES-MAX_OCCURANCES CHARACTER: PASSWORD_STRING`.

The second part of the problem was to just do a subtle adjustment to the validity test that requires the use of an XOR.

#### Julia ####

In julia, the desire would be to use the handy dandy `match` function that takes a regex and attempts an extraction of data against the provided string resulting in an array of typed objects (well, this is what I hoped, but it turns out that you just get a bunch of strings.  /shrug).  Thankfully Julia uses perl compatible regular expressions (PCRE: http://www.pcre.org/current/doc/html/pcre2syntax.html), which are fairly straight forward.

The regular expression would thus be stated as follows (make sure that you review and re-review the delimiters in your regex /sadtrombone):

```
r"^(\d+)-(\d+) (\w): (\w+)$"
```


### Day 1 (https://adventofcode.com/2020/day/1) ###

The first part of today's problem is just about reading a bunch of integers and determining the product of two of them if the sum of them is 2020.  It is a fairly straight forward problem that provides the opportunity to write a program that reads from input data and to perform some operation on that body of data.

The second part of the problem is to choose three numbers and to perform the same operation.

#### Julia ####

An interesting aspect of the julia solution is that there is an opportunity to use a syntatically brief form of nested loops.  In most programming languages, the construct for this would be to do something along the lines of:

```
for( int i = 0; i < maxi; i++ ) {
	for( int j = 0; j < maxj; j++ ) {
		for( int k = 0; k < maxk; k++ ) {
			...
		}
	}
}
```

In julia, for loops look like this:

```
for i = mini:maxi
	...
end
```

and while these loops can be nested as above:

```
for i = mini:maxi
	for j = minj:maxj
		...
	end
end
```

this can be shortened by collapsing the nest:

```
for i = mini:maxi, j = minj:maxj
	...
end
```
