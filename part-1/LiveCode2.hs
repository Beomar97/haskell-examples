
------------------------------------
-- Exercises
------------------------------------

import Data.List (sort)

flatSort :: [[Integer]] -> [Integer]
-- flatSort xs = concat $ map sort xs
flatSort = concat . (map sort)
-- flatSort = concatMap sort

flatSortR :: [[Integer]] -> [Integer]
flatSortR [] = []
flatSortR (xs:xss) = sort xs ++ flatSortR xss

initial :: String -> String -> Bool
initial (x:xs) (y:ys) = x == y && initial xs ys
initial [] _ = True
initial _ [] = False

--substring :: String -> String -> Bool
--substring xs [] = xs == []
--substring xs ys = initial xs ys || substring xs (tail ys)
--

substring xs ys = case ys of
    [] -> xs == []
    _ ->  initial xs ys || substring xs (tail ys)