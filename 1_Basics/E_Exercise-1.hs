------------------------------------------------------------
-- Aufgabe 1
------------------------------------------------------------

{-
Implementieren Sie eine Funktion
flatSort :: [[Integer]] -> [Integer]
mit folgenden Eigenschaften:
• flatSort xs enthält die gleichen Elemente wie concat xs.
• Die Elemente innerhalb eines Elementes vom Argument werden sortiert.
• Die Elemente von verschiedenen Elementen des Arguments werden nicht gemischt/sortiert.

Beispiele:
flatSort [[1,2,3],[1,3,2]] = [1,2,3,1,2,3]
flatSort [[1],[2]] = [1,2]
flatSort [[1],[1,2], [1,2,3]] = [1,1,2,1,2,3]

Verwenden Sie für diese Aufgabe die Zeile import Data.List (sort).
Verwenden Sie ausserdem die Funktionen map und concat.
-}
import Data.List (sort)
flatSort :: [[Integer]] -> [Integer]
flatSort xs = concat (map (\x -> sort x) xs) -- own solution
flatSort' xs = concat $ map sort xs -- sample solution
flatSort_ xs = concatMap sort -- ide suggestion solution

------------------------------------------------------------
-- Aufgabe 2
------------------------------------------------------------

-- Geben Sie eine Liste xs::[[Integer]] an,
-- so dass concat xs verschieden von flatSort xs ist.
xs :: [[Integer]]
xs = [[1,2,3],[1,3,2]] -- own example
xs' = [[2,1]] -- sample example

-- flatSort xs = [1,2,3,1,2,3]
-- concat xs = [1,2,3,1,3,2]

------------------------------------------------------------
-- Aufgabe 3
------------------------------------------------------------

-- Implementieren Sie die Funktion flatSort mit Rekursion und ++.
flatSortRec' :: [[Integer]] -> [Integer]
flatSortRec' xs = case xs of
    [] -> []
    x:xs -> sort x ++ flatSortRec' xs

------------------------------------------------------------
-- Aufgabe 4
------------------------------------------------------------

{-
Implementieren Sie rekursiv eine Funktion
initial :: String -> String -> Bool
die entscheidet ob das erste Agrument
ein Anfangssegment des zweiten Argumentes ist.
Beispiele:
initial "abc" "abcd" == True
initial "abc" "xabcd" == False
-}
initial :: String -> String -> Bool
initial [] _ = True
initial _ [] = False
initial (a:az) (b:bz) = a == b && initial az bz

------------------------------------------------------------
-- Aufgabe 5
------------------------------------------------------------

{-
Implementieren Sie mithilfe Ihrer Funktion initial
und der Funktion tail, eine Funktion
substring :: String -> String -> Bool
die entscheidet ob das erste Agrument ein Teilstring
des zweiten Argumentes ist.
Beispiele:
substring "abc" "xadbcd" == False
substring "abc" "xadbabccd" == True
-}
substring :: String -> String -> Bool
substring [] _ = True -- sample solution
substring _ [] = False
substring v w = initial v w || substring v (tail w)

substring' s [] = null s -- live code solution
substring' s (y:ys) = initial s (y:ys) || substring s ys

substring_ xs ys = case ys of -- live code solution 2
    [] -> null xs
    _ ->  initial xs ys || substring xs (tail ys)