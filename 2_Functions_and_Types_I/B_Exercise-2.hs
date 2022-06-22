import Data.List (sort)
------------------------------------------------------------
-- Aufgabe 1
------------------------------------------------------------

-- Gegeben sei der folgende Datentyp:
data Car = Car
    { model :: Model
    , make :: Make
    , year :: Integer
    , color :: Color
    , power :: Horsepower
    } deriving (Show, Eq)

-- a) Deklarieren Sie geeignete Datentypen Model, Make,
-- Color, Horsepower.
data Model = Model
    { name :: String
    , generation :: Integer
    }
    deriving (Show, Eq, Ord)

newtype Make = Make String
    deriving (Show, Eq, Ord)

newtype Color = Color String
    deriving (Show, Eq, Ord)

newtype Horsepower = Horsepower Integer
    deriving (Show, Eq, Ord)

-- b) Erstellen Sie drei Autos:
-- `ford` Einen roten Ford Fiesta mit 70P S aus dem Jahr 2017.
-- `ferrari` Einen grünen Ferrari (andere Parameter frei).
-- `zoe` Einen weissen Renault Zoe (andere Parameter frei).
ford :: Car
ford = Car (Model "Fiesta" 2) (Make "Ford") 2017 (Color "Red") (Horsepower 70)

ferrari :: Car
ferrari = Car (Model "296 GTS" 1) (Make "Ferrari") 2018 (Color "Green") (Horsepower 400)

zoe :: Car
zoe = Car (Model "Zoe" 2) (Make "Renault") 2019 (Color "White") (Horsepower 150)

-- c) Implementieren Sie eine Ord Instanz für den Car Typ.
-- Beachten Sie die Regeln der Typklasse (http://hackage.haskell.org/package/base-4.12.0.0/docs/Data-Ord. html).
instance Ord Car where
    compare car1 car2 = compare
        (power car1, year car1, make car1, model car1, year car1)
        (power car2, year car2, make car2, model car2, year car2)

-- d) Importieren Sie Data.List und führen Sie die Funktion
-- sort [zoe, ferrari, ford]
-- aus.
unsortedCars :: [Car]
unsortedCars = [ford, ferrari, zoe]

sortedCars :: [Car]
sortedCars = sort [ford, ferrari, zoe]
-- Output: ford, zoe, ferrari

------------------------------------------------------------
-- Aufgabe 2
------------------------------------------------------------

-- Wir erinnern uns an die Implementierung von Binärbäumen aus der Vorlesung:
data Tree a
    = Node (Tree a) a (Tree a) 
    | Leaf a

-- a) Implementieren Sie eine Funktion
-- collect :: Tree a -> [a]
-- , die alle Elemente eines Binärbaumes
-- in einer Liste “aufsammelt”.
collect :: Tree a -> [a]
collect a = case a of
    Node l a r -> a : (collect l ++ collect r)
    Leaf a -> [a]

collect' t = case t of -- sample solution
    Leaf a -> [a]
    Node l a r -> a : concat [collect l, collect r]

-- b) Passen Sie den Datentyp aus der Vorlesung so an,
-- dass beliebig verzweigte Bäume modelliert werden können
-- (nicht nur Binärbäume).
data GeneralTree a 
    = GeneralTree a [GeneralTree a]

-- c) Erstellen Sie mit ihrem Datentyp den Baum:
-- 1 -> (2 -> (5 6 7) 3 -> 8)
exampleTree :: GeneralTree Integer
exampleTree = GeneralTree 1
    [ GeneralTree 2
        [ GeneralTree 5 []
        , GeneralTree 6 []
        , GeneralTree 7 []
        ]
    , GeneralTree 3
        [ GeneralTree 8 []
        ]
    ]

------------------------------------------------------------
-- Aufgabe 3
------------------------------------------------------------

-- a) Implementieren Sie einen Typ NatNumber entsprechend der Definition:
-- "Eine natürliche Zahl ist entweder Null oder Nachfolger einer natürlichen Zahl."
data NatNumber
    = Null | Successor NatNumber
    deriving Show

-- b) Implementieren Sie eine Funktion
-- eval: NatNumber -> Integer
-- , die natürliche Zahlen “auswertet” und eine Funktion uneval,
-- die sich zu eval “dual” verhält (also Integers in NatNumbers konvertiert).
eval :: NatNumber -> Integer
eval n = case n of
    Null -> 0
    Successor n -> eval n + 1

uneval :: Integer -> NatNumber
uneval n
    | n < 0 = error "negative values are invalid"
    | n == 0 = Null
    | otherwise = Successor $ uneval (n-1)

{-
c) Definieren Sie mit einem Pattern-Match eine Funktion fact:
NatNumber -> NatNumber
Halten Sie sich dabei möglichst exakt an die mathematische Definition:
fact(0) = 1
fact(n+1) = (n+1) * fact(n)
Hinweis: Sie müssen dazu die Grundoperationen der Addition
und Multiplikation “Bootsrappen”.
-}
add :: NatNumber -> NatNumber -> NatNumber
add Null s = s
add (Successor n) m = add n (Successor m)

mul :: NatNumber -> NatNumber -> NatNumber
mul Null n = Null
mul (Successor n) m = mul n m `add` m

fact :: NatNumber -> NatNumber
fact Null = Successor Null
fact (Successor n) = Successor n `mul` fact n

------------------------------------------------------------
-- Aufgabe 4
------------------------------------------------------------

{-
Lesen Sie diesen Eintrag über die “Programmiersprache” Fractran.
Implementieren Sie einen Fractran interpreter (beachten Sie dazu die Anmerkungen in der Vorlesung):
execute:  Program -> Input -> Output
Definieren Sie wo nötig selber geeignete Datentypen.
-}

-- Fraction = (numerator, denominator)
type Fraction = (Integer, Integer)

type Program = [Fraction]

type Input = Integer

type Output = [Integer]

execute :: Program -> Input -> Output
execute program input = reverse $ execute_ program input []
    where
        execute_ :: Program -> Input -> Output -> Output
        execute_ [] input output = input:output
        execute_ ((n,d):ps) input output
            | input*n `mod` d == 0 = execute_ program
                (input*n `div` d) (input:output)
            | otherwise = execute_ ps input output

fibProgram :: Program
fibProgram =
    [ (91,33)
    , (11,13)
    , (1,11)
    , (399,34)
    , (17,19)
    , (1,17)
    , (2,7)
    , (187,5)
    , (1,3)
    ]

-- Should evaluate to True
shouldBeTrue = sum (execute fibProgram 31250) == 26183978971946924