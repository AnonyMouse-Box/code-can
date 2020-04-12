#!/usr/bin/runhaskell

doubleMe x = x + x

doubleUs x y = 2*x + 2*y

doubleUs' x y = doubleMe x + doubleMe y

doubleSmallNumber x = if x > 100
                        then x
                        else 2*x

conanO'Brien = "It's a-me, Conan O'Brien!"

boomBangs xs = [ if x < 10 then "BOOM!" else "BANG!" | x <- xs, odd x]

length' xs = sum [1 | _ <- xs]

length'' :: (Num b) => [a] -> b
length'' [] = 0
length'' (_:xs) = 1 + length'' xs

removeNonUppercase :: [Char] -> [Char]
removeNonUppercase st = [c | c <- st, c `elem` ['A'..'Z']]

triangles = [(a,b,c) | c <- [1..10], b <- [1..10], a <- [1..10]]

rightTriangles = [(a,b,c) | c <- [1..10], b <- [1..c], a <- [1..b], a^2 + b^2 == c^2]

rightTriangles' = [(a,b,c) | c <- [1..10], b <- [1..c], a <- [1..b], a^2 + b^2 == c^2, a+b+c == 24]

pythagoreanTriplesUpTo d = [(a,b,c) | c <- [1..d], b <- [1..c], a <- [1..b], a^2 + b^2 == c^2]

addThree :: Int -> Int -> Int -> Int
addThree x y z = x + y + z

factorial :: Integer -> Integer
factorial n = product [1..n]

factorial' :: (Integral a) => a -> a
factorial' 0 = 1
factorial' n = n * factorial (n - 1)

circumference :: Float -> Float
circumference r = 2 * pi * r

circumference' :: Double -> Double
circumference' r = 2 * pi * r

lucky :: (Integral a) => a -> String
lucky 7 = "LUCKY NUMBER 7!"
lucky _ = "Sorry, you're out of luck, pal!"

sayMe :: (Integral a => a -> String
sayMe 1 = "One!"
sayMe 2 = "Two!"
sayMe 3 = "Three!"
sayMe 4 = "Four!"
sayMe 5 = "Five!"
sayMe _ = "Not between 1 and 5"

charName :: Char -> String
charName 'a' = "Albert"
charName 'b' = "Broseph"
charName 'c' = "Cecil"

addVectors :: (Num a) => (a, a) -> (a, a) -> (a, a)
addVectors a b = (fst a + fst b, snd a + snd b)

addVectors' :: (Num a => (a, a) -> (a, a) -> (a, a)
addVectors' (x1, y1) (x2, y2) = (x1 + x2, y1 + y2)

first :: (a, b, c) -> a
first (x, _, _) = x

second :: (a, b, c) -> b
second (_, y, _) = y

third :: (a, b, c) -> c
third (_, _, z) = z

head' :: [a] -> a
head' [] = error "Can't call head on an empty list, dummy!"
head' (x:_) = x

head'' :: [a] -> a
head'' xs = case xs of [] -> error "No head for empty lists!"
                       (x:_) -> x

tell :: (Show a) => [a] -> String
tell [] = "The list is empty"
tell (x:[]) = "The list has one element: " ++ show x
tell (x:y:[]) = "The list has two elements: " ++ show x ++ " and " ++ show y
tell (x:y:_) = "This list is long. The first two elements are: " ++ show x ++ " and " ++ show y

sum' :: (Num a) => [a] -> a
sum' [] = 0
sum' (x:xs) = x + sum' xs

capital :: String -> String
capital "" = "Empty string, whoops!"
capital all@(x:xs) = "The first letter of " ++ all ++ " is " ++ [x]

bmiTell :: (RealFloat a) => a -> String
bmiTell bmi
  | bmi <= 18.5 = "You're underweight, you emo, you!"
  | bmi <= 25.0 = "You're supposedly normal. Pffft, I bet you're ugly!"
  | bmi <= 30.0 = "You're fat! Lose some weight, fatty!"
  | otherwise   = "You're a whale, congratulations!"

bmiTell' :: (RealFloat a) => a -> a -> String
bmiTell' weight height
  | weight / height ^ 2 <= 18.5 = "You're underweight, you emo, you!"
  | weight / height ^ 2 <= 25.0 = "You're supposedly normal. Pffft, I bet you're ugly!"
  | weight / height ^ 2 <= 30.0 = "You're fat! Lose some weight, fatty!"
  | otherwise                   = "You're a whale, congratulations!"

bmiTell'' :: (RealFloat a) => a -> a -> String
bmiTell'' weight height
  | bmi <= 18.5 = "You're underweight, you emo, you!"
  | bmi <= 25.0 = "You're supposedly normal. Pffft, I bet you're ugly!"
  | bmi <= 30.0 = "You're fat! Lose some weight, fatty!"
  | otherwise   = "You're a whale, congratulations!"
  where bmi = weight / height ^ 2

bmiTell''' :: (RealFloat a) => a -> a -> String
bmiTell''' weight height
  | bmi <= skinny = "You're underweight, you emo, you!"
  | bmi <= normal = "You're supposedly normal. Pffft, I bet you're ugly!"
  | bmi <= fat    = "You're fat! Lose some weight, fatty!"
  | otherwise     = "You're a whale, congratulations!"
  where bmi = weight / height ^ 2
    skinny = 18.5
    normal = 25.0
    fat    = 30.0

bmiTell'''' :: (RealFloat a) => a -> a -> String
bmiTell'''' weight height
  | bmi <= skinny = "You're underweight, you emo, you!"
  | bmi <= normal = "You're supposedly normal. Pffft, I bet you're ugly!"
  | bmi <= fat    = "You're fat! Lose some weight, fatty!"
  | otherwise     = "You're a whale, congratulations!"
  where bmi = weight / height ^ 2
    (skinny, normal, fat) = (18.5, 25.0, 30.0)

max' :: (Ord a) => a -> a -> a
max' a b
  | a > b     = a
  | otherwise = b

myCompare :: (Ord a) => a -> a -> Ordering
a `myCompare` b
  | a > b     = GT
  | a == b    = EQ
  | otherwise = LT

initials :: String -> String -> String
initials firstname lastname = [f] ++ ". " ++ [l] ++ "."
  where (f,_) = firstname
        (l,_) = lastname

calcBmis :: (RealFloat a) => [(a, a)] -> [a]
calcBmis xs = [bmi w h | (w, h) <- xs]
  where bmi weight height = weight / height ^ 2

calcBmis' :: (RealFloat a) => [(a, a)] -> [a]
calcBmis' xs = [bmi | (w, h) <- xs, let bmi = w / h ^ 2]

calcBmis'' :: (RealFloat a) => [(a, a)] -> [a]
calcBmis'' xs = [bmi | (w, h) <- xs, let bmi = w / h ^ 2, bmi >= 25.0]

cylinder :: (RealFloat a) => a -> a -> a
cylinder r h =
  let sideArea = 2 * pi * r * h
      topArea = pi * r ^2
  in sideArea + 2 * topArea

describeList :: [a] -> String
describeList xs = "The list is " ++ case xs of [] -> "empty."
                                               [x] -> "a singleton list."
                                               xs -> "a longer list."

describeList :: [a] -> String
describeList xs = "The list is " ++ what xs
  where what [] = "empty."
        what [x] = "a singleton list."
        what xs = "a longer list."
