# Advent of Code Worklog 2020

## Day 2 (https://adventofcode.com/2020/day/2)

This problem boils down to extracting structured data from a file consisting of a range, a symbol, and a string to be evaluated for constraints.  This is a perfect opportunity to leverage the regex capabilities of the language being used.  An alternative would be to perform successive splits of the data on delimiter boundaries.  In C, this would leverage strchr to find the index of the delimiter and then strncpy calls using the indexes.

The structure of the data is `MIN_OCCURANCES-MAX_OCCURANCES CHARACTER: PASSWORD_STRING`.

The second part of the problem was to just do a subtle adjustment to the validity test that requires the use of an XOR.

### Julia

In julia, the desire would be to use the handy dandy `match` function that takes a regex and attempts an extraction of data against the provided string resulting in an array of typed objects (well, this is what I hoped, but it turns out that you just get a bunch of strings.  /shrug).  Thankfully Julia uses perl compatible regular expressions (PCRE: http://www.pcre.org/current/doc/html/pcre2syntax.html), which are fairly straight forward.

The regular expression would thus be stated as follows (make sure that you review and re-review the delimiters in your regex /sadtrombone):

```r"^(\d+)-(\d+) (\w): (\w+)$"```


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
