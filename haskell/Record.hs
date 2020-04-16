#!/usr/bin/env runhaskell


module Record
(
) where

import qualified Data.Map (Map, lookup, fromList)

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

data Day = Monday | Tuesday | Wednesday | Thursday | Friday | Saturday | Sunday
           deriving (Eq, Ord, Show, Read, Bounded, Enum)

type PhoneNumber = String
type Name = String
type PhoneBook = [(Name,PhoneNumber)]

phoneBook :: PhoneBook
phoneBook = [("betty","555-2938")
            ,("bonnie", "452-2928")
            ,("patsy","493-2928")
            ,("lucille","205-2928")
            ,("wendy","939-8282")
            ,("penny","853-2492")
            ]

inPhoneBook :: Name -> PhoneNumber -> PhoneBook -> Bool
inPhoneBook name pnumber pbook = (name,pnumber) `elem` pbook

type AssocList k v = [(k,v)]
type IntMap = Data.Map.Map Int


data LockerState = Taken | Free deriving (Show, Eq)

type Code = String

type LockerMap = Data.Map.Map Int (LockerState, Code)

lockerLookup :: Int -> LockerMap -> Either String Code
lockerLookup lockerNumber map = case Data.Map.lookup lockerNumber map of
                                  Nothing -> Left $ "Locker number " ++ show lockerNumber ++ " doesn't exist!"
                                  Just (state, code) -> if state /= Taken
                                                          then Right code
                                                          else Left $ "Locker number " ++ show lockerNumber ++ " is already taken!"

lockers :: LockerMap
lockers = Data.Map.fromList [(100,(Taken,"ZD39I"))
                            ,(101,(Free,"JAH3I"))
                            ,(103,(Free,"IQSA9"))
                            ,(105,(Free,"QOTSA"))
                            ,(109,(Taken,"893JJ"))
                            ,(110,(Taken,"99292"))
                            ]
