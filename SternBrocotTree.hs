{- |
Module      : SternBrocotTree
Description : Binary Search Tree of the Farey Sequence
License     : MIT
Maintainer  : Ryan McNamara <gn341ram@gmail.com>
Portability : Tested on Linux

The Farey  Sequence is an  enumeration of every  rational number.
The Farey Sequence of rank 1 includes all rational fractions with
a denominator  no larger than 1  (i.e. 0/1 and 1/1);  rank 2 adds
1/2, rank 3 adds fractions with denominators of 3, etc.

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
-}

module SternBrocotTree where

data Tree = Empty
          | Node { numer   :: Int
                 , denom   :: Int
                 , branchL :: Tree
                 , branchR :: Tree
                 , parentL :: Tree
                 , parentR :: Tree
                 } deriving (Eq)

instance Show Tree where
    show Empty = "Empty"
    show node = show (numer node) ++ "/" ++ show (denom node)

-- Zero and One are kind of special cases.
zero :: Tree
zero = Node 0 1 Empty root Empty Empty

one :: Tree
one  = Node 1 1 root Empty Empty Empty

root :: Tree
root = Node 1 2 kidL kidR zero one 
    where kidL = mkNode zero root
          kidR = mkNode root one

mkNode :: Tree -> Tree -> Tree
mkNode leftParent rightParent =
    let kidL  = mkNode leftParent self
        kidR  = mkNode self rightParent
        n     = numer leftParent + numer rightParent
        d     = denom leftParent + denom rightParent
        self  = Node n d kidL kidR leftParent rightParent
     in self

toDbl :: Tree -> Double
toDbl Empty = undefined
toDbl node  = fromIntegral (numer node) / fromIntegral (denom node)

approx :: Double -> Int -> (Int, Int)
approx f depth = (numer node, denom node)
    where node = approx' root root f depth

-- TODO: make more pretty.
-- UPDATE: made  prettier, but then  I added more  special cases.
-- Now it's uglier than ever.
approx' :: Tree -> Tree -> Double -> Int -> Tree
approx' parent Empty f depth = undefined
approx' parent node  f    0  = node
approx' parent node  0.0  _  = zero
approx' parent node  1.0  _  = one
approx' parent node  f depth
  | toDbl node == f = node
  | diffSelf < diffLower && diffSelf < diffUpper = parent
  | diffLower < diffUpper = approx' node (branchL node) f (depth - 1)
  | otherwise             = approx' node (branchR node) f (depth - 1)
  where diffLower = abs $ f - toDbl (branchL node)
        diffUpper = abs $ f - toDbl (branchR node)
        diffSelf  = abs $ f - toDbl parent
