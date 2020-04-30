#!/usr/bin/runhaskell


digitize :: Integral a => a -> [a]
digitize 0 = []
digitize a = digitize (a `div` 10) ++ [a `mod` 10]

factor :: Int -> Int -> Bool
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
               else if factor 3 (foldr (+) 0 (digitize a)) 
                      then True 
                      else False
factor 4 a = if elem a [1..99]
               then if elem a [4,8..96]
                      then True
                      else False
               else if factor 4 ((last (init (digitize a))) * 10 + (last (digitize a)))
                      then True
                      else False
factor 5 a = if (last (digitize a)) == 0 || (last (digitize a)) == 5
               then True
               else False
factor 6 a = if (factor 2 a) && (factor 3 a)
               then True
               else False
factor 7 a = if elem a [9,8..(-9)]
               then if elem a [(-7),7]
                      then True
                      else False
               else if factor 7 ((foldl (\acc x -> (acc * 10) + x) 0 (init (digitize a))) - (last (digitize a)) * 2)
                      then True
                      else False
