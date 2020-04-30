#!/usr/bin/runhaskell


digitize :: Integral a => a -> [a]
digitize 0 = []
digitize a = digitize (a `div` 10) ++ [a `mod` 10]

condense :: (Foldable t, Num a) => t a -> a
condense a = foldl (+) 0 (a)

lastDigit :: Integral a => a -> a
lastDigit a = last (digitize a) 

integerize :: (Foldable t, Num a) => t a -> a
integerize a = foldl (\acc b -> (acc * 10) + b) 0 a

theRest :: Integral a => a -> a
theRest a = integerize (init (digitize a))

lastDigits :: Integral a => Int -> a -> a
lastDigits a b = integerize (drop ((length (digitize b)) - a) (digitize b))

factor :: (Eq a, Num a, Integral b) => a -> b -> Bool
factor _ 0 = True
factor 0 _ = False
factor 1 _ = True
factor 2 a = if even a
               then True 
               else False
factor 3 a = if elem a [1..9] 
               then if elem a [3,6,9]
                      then True
                      else False
               else if factor 3 (condense (digitize a)) 
                      then True 
                      else False
factor 4 a = if elem a [1..99]
               then if elem a [4,8..96]
                      then True
                      else False
               else if factor 4 (lastDigits 2 a)
                      then True
                      else False
factor 5 a = if (lastDigit a) == 0 || (lastDigit a) == 5
               then True
               else False
factor 6 a = if (factor 2 a) && (factor 3 a)
               then True
               else False
factor 7 a = if elem a [9,8..(-9)]
               then if elem a [(-7),7]
                      then True
                      else False
               else if factor 7 ((theRest a) - (lastDigit a) * 2)
                      then True
                      else False
factor 8 a = if elem a [1,2..999]
               then if elem a [8,16..992]
                      then True
                      else False
               else if factor 8 (lastDigits 3 a) 
                      then True
                      else False
factor 9 a = if elem a [1..9]
               then if elem a [9]
                      then True
                      else False
               else if factor 9 (condense (digitize a))
                      then True
                      else False
factor 10 a = if (lastDigit a) == 0
                then True
                else False
factor 11 a = if (condense (zipWith (*) (cycle [1,(-1)]) (digitize a))) == 0
                then True
                else False
factor 12 a = if (factor 3 a) && (factor 4 a)
                then True
                else False
