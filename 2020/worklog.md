# Advent of Code Worklog 2020

## Day 4 (https://adventofcode.com/2020/day/4)

This problem is all about joining lines together to make records.  Part two may be about hashtables, but we will come to that.

Valid records are those that contain 8 entries or 7 entries without 'cid'

Part 2 requires semantic validation of the data associated with the data.

### Julia

We need to iterate over the input to split records on blank lines and the end of the data file.  So, join all lines together that are within a record and create new records when appropriate.

One thing to check and to be ever vigilient about is to scrutinize boolean operators and conditions.  Another thing is to look at expected values from parses and independently validate the chain of data filtration/transformation in between phases.  All this because, I failed to both of those things when I first started the problem.  Heh.

For part 2, we will need to take the passport, consume into a hashtable and perform appropriate data validations.

## Day 3 (https://adventofcode.com/2020/day/3)

I think the main deal with this problem is just using mod to wrap across replicates of array indexes.  Seems straight forward enough.

For the first part of the problem, there was only one slope that needed to be considered, 3 right/1 down.

For the second part of the problem, there are multiple slopes that need to be evaluated at the same time.  An approach could be to structure some general purpose slope traversal kind of thing, but I think for this, I'll just keep it simple.  However, if in a future problem, there IS some need for a general purpose arbritary slope traversal kind of thing needed, then I'll re-write this solution as a test bed for inclusion into bigger problems.

### Julia

`mod` is a common function in all programming languages.  In this case, we need to wrap the array index at the string length boundary.  The tricky bit with julia is that by default arrays start with 1, so we need to take that into account by using the `arr[begin]` syntax to ensure that for what ever index we start with, that we're working from the beginning.  There's a whole thing with ensuring that string operations work on non single byte characters, but I don't think it is worth worrying about for this problem.

For the second part, I will just compute the slopes in a hard coded way.  Ugh.

And as always, maintaining variables for similar conditions gets fiddly quick.  But at least things work.

## Day 2 (https://adventofcode.com/2020/day/2)

This problem boils down to extracting structured data from a file consisting of a range, a symbol, and a string to be evaluated for constraints.  This is a perfect opportunity to leverage the regex capabilities of the language being used.  An alternative would be to perform successive splits of the data on delimiter boundaries.  In C, this would leverage strchr to find the index of the delimiter and then strncpy calls using the indexes.

The structure of the data is `MIN_OCCURANCES-MAX_OCCURANCES CHARACTER: PASSWORD_STRING`.

The second part of the problem was to just do a subtle adjustment to the validity test that requires the use of an XOR.

### Julia

In julia, the desire would be to use the handy dandy `match` function that takes a regex and attempts an extraction of data against the provided string resulting in an array of typed objects (well, this is what I hoped, but it turns out that you just get a bunch of strings.  /shrug).  Thankfully Julia uses perl compatible regular expressions (PCRE: http://www.pcre.org/current/doc/html/pcre2syntax.html), which are fairly straight forward.

The regular expression would thus be stated as follows (make sure that you review and re-review the delimiters in your regex /sadtrombone):

```
r"^(\d+)-(\d+) (\w): (\w+)$"
```


## Day 1 (https://adventofcode.com/2020/day/1)

The first part of today's problem is just about reading a bunch of integers and determining the product of two of them if the sum of them is 2020.  It is a fairly straight forward problem that provides the opportunity to write a program that reads from input data and to perform some operation on that body of data.

The second part of the problem is to choose three numbers and to perform the same operation.

### Julia

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
