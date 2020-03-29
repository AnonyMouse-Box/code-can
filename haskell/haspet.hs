#!/usr/bin/env runhaskell

main = do
  putStrLn "Welcome to HasPet!"
  
  putStr "Enter name: "
  name <- getLine -- String
  putStr "Enter age: "
  age <- getLine -- Int
  putStr "Enter weight: "
  weight <- getLine -- Float
  putStr "Is your pet hungry? "
  hungry <- getLine -- Bool
  let photo = "(=^o.o^=)__" -- Selection
  
  putStrLn $ "Hello " ++ name
  putStrLn photo
