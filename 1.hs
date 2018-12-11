module Advent where

data Sign = Positive | Negative

toSign '+' = Positive
toSign '-' = Negative

-- apply sign value =

main = do
  readLines
