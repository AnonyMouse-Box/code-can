#!/usr/bin/env runhaskell

main = do
  putStrLn "Welcome to HasPet!"
  
  name <- getLine -- String
  age <- getLine -- Int
  weight <- getLine -- Float
  hungry <- getLine -- Bool
  let photo = "(=^o.o^=)__" -- Selection
  
  putStrLn ("Hello " ++ name)
  putStrLn photo
