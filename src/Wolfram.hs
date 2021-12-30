module Wolfram (fromBinary, toBinary, next, toString, toPattern) where

import Data.Foldable (Foldable (fold), toList)

toBinary :: Int -> [Bool]
toBinary 0 = []
toBinary x = toBinary q <> [toBool r]
  where
    (q, r) = quotRem x 2
    toBool 0 = False
    toBool _ = True

fromBinary :: [Bool] -> Int
fromBinary l = sum $ f <$> zip (reverse l) [0 :: Int ..]
  where
    f (x, p) = toInt x * 2 ^ p
    toInt True = 1
    toInt False = 0

toPattern :: Int -> [Bool]
toPattern = take 8 . appendFalses . toBinary
  where
    appendFalses x = replicate (8 - length x) False <> x

next :: [Bool] -> [Bool] -> [Bool]
next pattern current = go $ [False, False] <> current <> [False, False]
  where
    go (x1 : x2 : x3 : xs) = new <> go (x2 : x3 : xs)
      where
        index = fromBinary [x1, x2, x3]
        new = toList $ safeIndex index (reverse pattern)
        safeIndex i l
            | i < length l = Just $ l !! i
            | otherwise = Nothing
    go _ = []

toString :: [Bool] -> String
toString l = fold (toChar <$> l)
  where
    toChar True = "*"
    toChar False = " "
