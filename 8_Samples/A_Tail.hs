--------------------------------------------------------------------------------
-- AUFGABE (a)
--------------------------------------------------------------------------------

fa :: Integer -> Integer
fa 0 = 1
fa n = 2 * fa (n-1) + 2

{- AUFGABE
    Implentieren Sie eine endrekursive Variante der Funktion 'fa' (ersetzen Sie
    'error "fixme' durch entsprechenden Code).
-}
faT :: Integer -> Integer
faT = faT_ 1
    where
        faT_ acc 0 = acc
        faT_ acc n = faT_ (2*acc+2) (n-1)

--------------------------------------------------------------------------------
-- AUFGABE (b)
--------------------------------------------------------------------------------

fb :: (Integer -> Integer -> Integer) -> Integer -> Integer
fb f n 
    | n <= 1 = 1
    | otherwise = f (fb f (n-1)) (fb f (n-2)) 

{- AUFGABE
    Implentieren Sie eine endrekursive Variante der Funktion 'fb'. (ersetzen Sie
    'error "fixme' durch entsprechenden Code).
-}
fbT :: (Integer -> Integer -> Integer) -> Integer -> Integer
fbT f = fbT_ 1 1
    where
        fbT_ a b n 
            | n <= 1 = a
            | otherwise = fbT_ (f a b) a (n-1)  

--------------------------------------------------------------------------------
-- AUFGABE (c)
--------------------------------------------------------------------------------

{- BEMERKUNG
    Folgend ist eine Implementierung der im Unterricht behandelten 
    Collatz Funktion.
-}

next :: Integer -> Integer
next n | n `mod` 2 == 0 = n `div` 2
       | otherwise = 3*n+1

colSeq :: Integer -> [Integer]
colSeq 1 = [1]
colSeq n = n:colSeq (next n)

{- AUFGABE
    Implentieren Sie eine endrekursive Variante der Funktion 'colSeq'. (ersetzen Sie
    'error "fixme' durch entsprechenden Code).
-}

colSeqT :: Integer -> [Integer]
colSeqT = colSeqT_ id
    where
        colSeqT_ f 1 = f [1]
        colSeqT_ f n = colSeqT_ (\x -> f (n:x)) (next n) 