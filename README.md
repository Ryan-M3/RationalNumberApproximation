# Theory

The Farey  Sequence is an  enumeration of every  rational number.
The Farey Sequence of rank 1 includes all rational fractions with
a denominator  no larger than 1  (i.e. 0/1 and 1/1);  rank 2 adds
1/2, rank 3 adds fractions with denominators of 3, etc. Wikipedia
is very helpful for this sort of thing.

The Stern-Brocot  Tree is a  binary search tree  which enumerates
all the numbers (andso it's an infinite data structure). The root
of the  tree is  1/2. All the  nodes found at  a given  depth, N,
includes all fractions introduced by  the Farey Sequence of ranke
(N - 1). It's N-1 because we  start at 1/2 rather than what would
otherwise have to be both 0/1  and 1/1, which would make the tree
non-binary.

The  tree  does  not  include fractions  which  would  have  been
introduced by a smaller rank of the Farey Sequence. For instance,
2/4 is  already in the tree  by the time  we get to rank  4 Farey
numbers as the simplified fraction 1/2.

# Motivation

Originally I wanted to mess  about with the Euler Gradus function
(yes, invented  by that Euler)  which takes a music  interval and
tells you how dissonant it is. However, modern instruments are no
longer  tuned to  perfect ratios  so  the dissonance  of a  music
interval tends to get spread out equally across the keyboard. The
idea is that the human ear/brain approximates the music interval.
So  if I  wanted to  use the  Euler Gradus  function to  estimate
dissonance  and  consonance  in  some sort  of  crazy  microtonal
system, I'd need to approximate the frequency down to a precision
that the human  ear/brain can distinguish. You  can use continued
fractions for this sort of thing, but as a programmer I love me a
good binary search tree.

# Usage

Let's say  you would like to  approximate pi. You should  use the
function "approx"  which takes  two arguments:  the first  is the
number you would like to approximate  and the second is the depth
to  which you'd  like to  search the  tree. Smaller  numbers will
yield approximations that are simpler fractions overall, but will
be less accurate. The algorithm is  smart enough that if I ask it
to  approximate 0.25,  it's not  going  to keep  searching for  a
better approximation  than 1/4 because  every branch it  looks to
search down will result in a worse approximation than the current
one.

```
module Main where

import SternBrocotTree

main :: IO ()
main = print $ approx pi 4
```

If  you  run  and  compile  this program,  you  should  get  back
```(19, 6)``` which represents the  fraction 19/6 which is 3.1666
repeating. It is possible for  the algorithm to find an unusually
good approximation for a number which causes it to terminate even
though there is a slightly better approximation seeveral branches
down. This  is by design since  the purpose is to  find the best,
simplest rational  approximation for a  number. If you  really do
need pi to the most accuratee representation, then you should use
the double  pi. My  algorithm assumes that  there's some  sort of
underlying rational ratio  and we have a bit of  noise, so you're
neever going  to get  a more accurate  representation of  pi that
(22, 7), even if you set the depth to a hundred-thousand.
