import Data.List (sort)
------------------------------------------------------------
-- Aufgabe 1
------------------------------------------------------------

-- a)
data Car = Car
    { model :: Model
    , make :: Make
    , year :: Integer
    , color :: Color
    , power :: Horsepower
    } deriving (Show, Eq)

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

-- b)
ford :: Car
ford = Car (Model "Fiesta" 2) (Make "Ford") 2017 (Color "Red") (Horsepower 70)

ferrari :: Car
ferrari = Car (Model "296 GTS" 1) (Make "Ferrari") 2018 (Color "Green") (Horsepower 400)

zoe :: Car
zoe = Car (Model "Zoe" 2) (Make "Renault") 2019 (Color "White") (Horsepower 150)

-- c)
instance Ord Car where
    compare car1 car2 = compare
        (power car1, year car1, make car1, model car1, year car1)
        (power car2, year car2, make car2, model car2, year car2)

-- d)
unsortedCars :: [Car]
unsortedCars = [ford, ferrari, zoe]

sortedCars :: [Car]
sortedCars = sort [ford, ferrari, zoe]

------------------------------------------------------------
-- Aufgabe 2
------------------------------------------------------------

data Tree a
    = Node (Tree a) a (Tree a) 
    | Leaf a

-- a)
collect :: Tree a -> [a]
collect a = case a of
    Node l a r -> a : (collect l ++ collect r)
    Leaf a -> [a]

collect' t = case t of -- sample solution
    Leaf a -> [a]
    Node l a r -> a : concat [collect l, collect r]

-- b)
data GeneralTree a 
    = GeneralTree a [GeneralTree a]

-- c)
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

-- a)
data NatNumber
    = Null | Successor NatNumber
    deriving Show

-- b)
eval :: NatNumber -> Integer
eval n = case n of
    Null -> 0
    Successor n -> eval n + 1

uneval :: Integer -> NatNumber
uneval n
    | n < 0 = error "negative values are invalid"
    | n == 0 = Null
    | otherwise = Successor $ uneval (n-1)

-- c)
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