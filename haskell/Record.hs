#!/usr/bin/env runhaskell


module Record
(
) where

data Person = Person { firstName   :: String
                     , lastName    :: String
                     , age         :: Int
                     , height      :: Float
                     , phoneNumber :: String
                     , flavour     :: String
                     } deriving (Eq, Show, Read)

data Car = Car { company :: String
               , model   :: String
               , year    :: Int
               } deriving (Eq, Show, Read)

tellCar :: Car -> String
tellCar (Car {company = c, model = m, year = y}) = "This " ++ c ++ " " ++ m ++ " was made in " ++ show y
