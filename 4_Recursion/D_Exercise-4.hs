------------------------------------------------------------
-- Aufgabe 1
------------------------------------------------------------

-- Zur Erinnerung, das Schema der primitiven Rekursion:
prim c g 0 x = c x
prim c g n x = g (f (n-1) x) (n-1) x
    where
        f = prim c g

{-
    Verwenden Sie das Schema der primitiven Rekursion
    zum Implementieren der folgenden Funktionen
    (Parameter, die nicht benötigt werden, sollen vom Typ () gewählt werden):
-}

-- a) m2(n) = 2n (m2 :: Integer -> () -> Integer)
m2 :: Integer -> () -> Integer
m2 = prim (const 0) (\r _ _ -> 2+r)

-- b) e2(n) = 2^n
e2 :: Integer -> () -> Integer
e2 = prim (const 1) (\r _ _ -> 2*r)

-- c) exp(x, n) = x^n
exp_ :: Integer -> Integer -> Integer
exp_ = prim (const 1) (\r _ x -> x*r)

-- d) fact(n) = n!
fact :: Integer -> () -> Integer
fact = prim (const 1) (\r n x -> (n+1) * r)

------------------------------------------------------------
-- Aufgabe 2
------------------------------------------------------------

-- Welche der folgenden Funktionen liegen in einer endrekursiven Form vor?

{-
fgx
    | x == 0 = g x
    | otherwise = g $ f g (x -1)
-}
-- Nein

{-
length xs = case xs of
    [] -> 0
    x : xs -> (+1) $ length xs
-}
-- Nein

{-
length' ls = aux
    $ map (const 1)
    $ ls
    where
        aux ys = case ys of
            [] -> 0
            [x] -> x
            x:xs -> aux $ map (\y -> (+1) x) xs
-}
-- Ja

------------------------------------------------------------
-- Aufgabe 3
------------------------------------------------------------

-- Gegeben ist die Funktion:
sieve :: (a -> a -> Bool) -> [a] -> [a]
sieve pred xs = case xs of
    [] -> []
    x : xs -> x:(sieve pred $ filter (pred x) xs)

-- a) Implementieren Sie die Funktion in einer endrekursiven Form,
-- einmal mithilfe eines Akkumulators und einmal mithilfe von Continuations.
sieveAcc :: (a -> a -> Bool) -> [a] -> [a]
sieveAcc pred = reverse . sieve_ []
    where
        sieve_ acc [] = acc
        sieve_ acc (x:xs) =
            sieve_ (x:acc) $ filter (pred x) xs

sieveCtn :: (a -> a -> Bool) -> [a] -> [a]
sieveCtn pred = sieve_ id
    where
        sieve_ ctn [] = ctn []
        sieve_ ctn (x:xs) =
            sieve_ (\c -> ctn (x:c)) $ filter (pred x) xs

-- b) Benutzen Sie die endrekursiven Funktionen um die Funktion zu realisieren,
-- die zu gegebenem Int n eine Liste mit allen Primzahlen bis (inklusive) n zurückgibt.
primes :: Integer -> [Integer]
primes n = sieveCtn pred [2..n]
    where
        pred x y = not $ y `mod` x == 0

------------------------------------------------------------
-- Aufgabe 4
------------------------------------------------------------

-- Gegeben sei:
data Tree a = Tree a [Tree a]

depth :: Tree a -> Integer
depth (Tree _ subtrees) =
    1 + (maximum $ 0:(map depth subtrees))

-- Implementieren Sie die Funktion depth in endrekursiver Form.
-- Hinweis: Verwenden Sie als Akkumulator eine Liste von Bäumen.

depthTR :: Tree a -> Integer
depthTR t = depth_ 0 [t]
    where
        cut :: Tree a -> [Tree a]
        cut (Tree _ []) = []
        cut (Tree _ ts) = ts

        depth_ n [] = n
        depth_ n ts = depth_ (n+1) $ concatMap cut ts

------------------------------------------------------------
-- Aufgabe 5
------------------------------------------------------------

{-
    Die Fibonacci Funktion ist definiert als die Summe der zwei vorherigen Glieder (und Anfangswerte).
    Die "Tribonacci"-Funktion ist als Summe der letzten drei Glieder definiert:
    trib(0) = 1
    trib(1) = 1
    trib(2) = 1
    trib(n) = trib(n − 3) + trib(n − 2) + trib(n − 1)

    Implementieren Sie die Tribonacci-Funktion endrekursiv.
-}

trib :: Integer -> Integer
trib n = trib_ 1 1 1 n
    where
        trib_ x y z 0 = x
        trib_ x y z n = trib_ y z (x+y+z) (n-1)