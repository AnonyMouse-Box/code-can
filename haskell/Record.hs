#!/usr/bin/env runhaskell


module Record
(
) where

data Person = Person { firstName   :: String
                     , lastname    :: String
                     , age         :: Int
                     , height      :: Float
                     , phoneNumber :: String
                     , flavour     :: String
                     } deriving (Show)

data Car = Car { company :: String
               , model   :: String
               , year    :: Int
               } deriving (Show)
