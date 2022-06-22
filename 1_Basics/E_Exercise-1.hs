------------------------------------------------------------
-- Aufgabe 1
------------------------------------------------------------

import Data.List (sort)
flatSort :: [[Integer]] -> [Integer]
flatSort xs = concat (map (\x -> sort x) xs) -- own solution
flatSort' xs = concat $ map sort xs -- sample solution
flatSort_ xs = concatMap sort -- ide suggestion solution

------------------------------------------------------------
-- Aufgabe 2
------------------------------------------------------------

xs :: [[Integer]]
xs = [[1,2,3],[1,3,2]] -- own example
xs' = [[2,1]] -- sample example

-- flatSort xs = [1,2,3,1,2,3]
-- concat xs = [1,2,3,1,3,2]

------------------------------------------------------------
-- Aufgabe 3
------------------------------------------------------------

flatSortRec' :: [[Integer]] -> [Integer]
flatSortRec' xs = case xs of
    [] -> []
    x:xs -> sort x ++ flatSortRec' xs

------------------------------------------------------------
-- Aufgabe 4
------------------------------------------------------------

initial :: String -> String -> Bool
initial [] _ = True
initial _ [] = False
initial (a:az) (b:bz) = a == b && initial az bz

------------------------------------------------------------
-- Aufgabe 5
------------------------------------------------------------

substring :: String -> String -> Bool
substring [] _ = True -- sample solution
substring _ [] = False
substring v w = initial v w || substring v (tail w)

substring' s [] = null s -- live code solution
substring' s (y:ys) = initial s (y:ys) || substring s ys

substring_ xs ys = case ys of -- live code solution 2
    [] -> null xs
    _ ->  initial xs ys || substring xs (tail ys)