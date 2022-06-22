import Text.Read

----------------------------------------------------------
-- Veschiedene Sichtweisen auf mehrstellige Funktionen
----------------------------------------------------------

max1 :: (Int, Int) -> Int
max1 (x, y) = if x > y then x else y

max2 ::Int->Int->Int
max2 x y = if x > y then x else y


{--
Das Uebersetzen zwischen den Sichtweisen
versteht man als "Currying" und "Uncurrying".
curry f a1 .. an = f (a1 ,..,an)
uncurry f (a1 ,.., an) = f a1 .. an
 --}

{--
Exercise: Implementieren Sie `curry` und `uncurry`
curry :: ((a,b) -> c) -> a -> b -> c
uncurry :: (a -> b -> c) -> (a,b) -> c
 --}

curry :: ((a,b) -> c) -> (a -> (b -> c))
curry funktion arg1 arg2 = funktion (arg1, arg2)

uncurry :: (a -> (b -> c)) -> (a,b) -> c
uncurry p (x, y) = p x y

-----------------------------------------------------------
-- Hoehere Funktionen
-----------------------------------------------------------

-- Zweimaliges Anwenden einer Funktion
twice :: (a -> a) -> a -> a
twice f = f . f

-- n-maliges Anwenden einer Funktion
-- many ::Int-> (a -> a) -> a -> a
many 0 f = id
many n f = f . many (n-1) f

-- foldl vs foldr
listL :: [Integer] -> [Integer]
listL = foldl (flip (:)) []

listR :: [Integer] -> [Integer]
listR = foldr (:) []

{--
Implementieren Sie eine Funktion zum
Berechnen der Tiefe eines Baumes:
--}

data BTree a
    = Node a (BTree a) (BTree a)
    | Empty deriving Show

bTree
    :: (a -> b -> b -> b)
    -> b
    -> BTree a
    -> b
bTree _ empty Empty = empty
bTree node empty (Node a t1 t2) = node a (recurse t1) (recurse t2)
    where
        recurse = bTree node empty


btDepth :: BTree a -> Integer
btDepth = bTree (\x y z -> 1 + max y z) 0

btTex :: Show a => BTree a -> String
btTex = bTree (\a b c -> "["++ (show a) ++ b ++ c ++ "]") ""

-----------------------------------------------------------
-- Partielle Funktionen
-----------------------------------------------------------

-- safe
sDiv :: Integer -> Integer -> Maybe Integer
sDiv x y =
    case y of
        0 -> Nothing
        n -> Just $ x `div` y

-- unsafe
dProcessing :: Integer -> Integer -> Integer
dProcessing x y = (\a -> 2 * a + 3) $ div (x + y) x

-- now is safe
sProcessing :: Integer -> Integer -> Maybe Integer
sProcessing x y = (\a -> 2 * a + 3) <$> sDiv (x + y) x

-- n ary
readInt :: String -> Maybe Integer
readInt = readMaybe

add x y = (+) <$> ix <*> iy
    where
        ix = readInt x
        iy = readInt y
