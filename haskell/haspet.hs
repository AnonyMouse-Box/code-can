#!/usr/bin/env runhaskell

main = do
  putStrLn "Welcome to HasPet!"
  
  name <- getLine
  age <- getLine
  weight <- getLine
  hungry <- getLine
  let photo = "(=^o.o^=)__"
  
  putStrLn ("Hello " ++ name)
  putStrLn photo
