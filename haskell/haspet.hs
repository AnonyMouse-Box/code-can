#!/usr/bin/env runhaskell

main = do
  putStrLn "Welcome to HasPet!"
  
  putStr "Enter name: "
  name <- getLine
  putStr "Enter age: "
  ageStr <- getLine
  let age = read ageStr :: Int
  putStr "Enter weight: "
  weightStr <- getLine
  let weight = read weightStr :: Double
  putStr "Is your pet hungry? "
  hungryStr <- getLine
  let hungry = read hungryStr :: Bool
  let photo = "(=^o.o^=)__" -- Selection
  
  putStrLn $ "Hello " ++ name
  putStrLn $ show age
  putStrLn $ show weight
  putStrLn $ show hungry
  putStrLn photo
