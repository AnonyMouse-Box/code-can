#!/usr/bin/env runhaskell

main = do
  putStrLn "Welcome to HasPet!"
  
  name = "Spike"
  age = 5
  weight = 9.5
  hungry = True
  photo = "(=^o.o^=)__"
  
  putStrLn ("Hello " ++ name)
  putStrLn photo
