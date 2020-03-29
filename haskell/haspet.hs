#!/usr/bin/env runhaskell

main = do
  putStrLn "Welcome to HasPet!"
  
  let name = "Spike"
  let age = 5
  let weight = 9.5
  let hungry = True
  let photo = "(=^o.o^=)__"
  
  putStrLn ("Hello " ++ name)
  putStrLn photo
