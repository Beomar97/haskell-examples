import Data.List (sort)

flatSort :: Ord a => [[a]] -> [a]
flatSort xss = concat $ map sort xss

flatSortR :: Ord a => [[a]] -> [a]
flatSortR [] = []
flatSortR (xs:xss) = (sort xs) ++ (flatSortR xss)

initial :: String -> String -> Bool
initial [] _ = True
initial _ [] = False
initial (c:cs) (d:ds) = c == d && initial cs ds

substring :: String -> String -> Bool
substring s (y:ys) = initial s (y:ys) || substring s ys
substring s [] = s == []