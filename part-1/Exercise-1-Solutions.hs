------------------------------------------------------------
-- Aufgabe 1
------------------------------------------------------------

import Data.List (sort)

flatSort :: [[Integer]] -> [Integer]
flatSort xs = concat $ map sort xs

------------------------------------------------------------
-- Aufgabe 2
------------------------------------------------------------
example = [[2,1]]

------------------------------------------------------------
-- Aufgabe 3
------------------------------------------------------------
flatSort2 :: [[Integer]] -> [Integer]
flatSort2 xs = case xs of
    [] -> []
    x:xs -> sort x ++ flatSort2 xs


------------------------------------------------------------
-- Aufgabe 4
------------------------------------------------------------

initial :: String -> String -> Bool
initial [] _ = True
initial _ [] = False
initial (u:us) (w:ws) = u == w && initial us ws

------------------------------------------------------------
-- Aufgabe 5
------------------------------------------------------------

substring :: String -> String -> Bool
substring [] _ = True
substring _ [] = False
substring v w = initial v w || substring v (tail w)