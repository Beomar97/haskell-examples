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

data Tree a
    = Leaf a
    | Node a (Tree a) (Tree a)
    deriving (Show, Eq)

tree :: (a -> b) -> (a -> b -> b -> b) -> Tree a -> b
tree leaf node t = case t of
    Leaf a -> leaf a
    Node a l r -> node a (recurse l) (recurse r)
        where
            recurse = tree leaf node

{-
     1
    / \
   21 3
-}
exampleTree :: Tree Integer
exampleTree = Node 1 (Leaf 21) (Leaf 3)

sumTree :: Tree Integer -> Integer
sumTree = tree id (\x y z -> x + y + z)

sumTree' t = case t of
    Leaf x -> x
    Node x l r -> x + (sumTree l) + (sumTree r)

maxTree :: Tree Integer -> Integer
maxTree = tree id node
    where
        node x y z = max x (max y z)

maxTree' t = case t of
    Leaf x -> x
    Node x l r -> max x (max (maxTree l) (maxTree r))

depth :: Tree a -> Integer
depth = tree leaf node
    where
        leaf _ = 1
        node _ y z = 1 + max y z

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
