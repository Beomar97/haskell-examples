-----------------------------------------------------------
-- Referential transparency
-----------------------------------------------------------

{- Referential Transparency
    It is always possible to exchange an expression with
    its definition.
-}
myThree :: Integer
myThree = if True then 3 else 4

myNumber :: Integer
myNumber = myThree + 7

anotherWayToPutIt =
    (if True then 3 else 4) + 7
--  ^--this is 'myThree'--^

{- Imperative Code
    Imperative Code is not usually referrentially
    transparent.

    x = 3;
    x = x + 1;
    print x + 4

    vs

    x = 3;
    x = x + 1;
    print 3 + 4

-}

-----------------------------------------------------------
-- Sum Types
-----------------------------------------------------------

-- Playing Cards

-- King, Queen, etc.
data Face
    = Ace
    | King
    | Queen
    | Jack
    | Number Int
    deriving Show

-- Heart, Spade, etc.
data Suit
    = Heart
    | Spade
    | Club
    | Diamond
    deriving Show

-- A card consists of a face and a suit
data Card = Card
    {   face :: Face
    ,   suit :: Suit
    }
    deriving Show

-- A hand holds multiple cards
type Hand = [Card]


{- Exercise
    Write a function 'evalCard' that returns all possible
    values of a single card as follows:
    * A card with a number has the value of the number
    * An Ace has two possible values: 1 and 11
    * All other cards are valued 10.
-}
evalCard :: Card -> [Int]
evalCard c = case face c of
    Number x -> [x]
    Ace -> [1, 11]
    _ -> [10]


{- Exercise
    Write a function 'evalHand' that returns all possible
    values of a hand (use foldl). Dublicates are OK.
-}
evalHand :: Hand -> [Int]
evalHand = foldl f [0]
    where
        f vals c = [ x+y | x <- vals, y <- evalCard c ]


{- Exercise
    Specify two hands:
    hand1 = 🂡,🂥,🃓,🃞
    hand2 = 🃍,🃁,🂡,🂪,🂧
-}

hand1 :: Hand
hand1 =
    [ Card Ace Spade
    , Card (Number 5) Spade
    , Card (Number 3) Club
    , Card King Club
    ]

hand2 :: Hand
hand2 =
    [ Card Queen Diamond
    , Card Ace Diamond
    , Card Ace Spade
    , Card (Number 10) Spade
    , Card (Number 7) Spade
    ]

{- Exercise
    Test 'evalHand' with 'hand1' and 'hand2' using the repl.
-}

-- evalHand hand1 => [19,29]
-- evalHand hand2 => [29,39,39,49]

-- Shapes

-- A shape is either a rectangle, a square, or a circle
data Shape
    = Rectangle Float Float
    | Square Float
    | Circle Float
    deriving (Show, Eq)

-- Calculates the area of a shape
area :: Shape -> Float
area (Rectangle a b) = a * b
area (Square a) = a * a
area (Circle r) = pi * r * r

{- Exercise
    Write a function to calculate the circumference of a shape.
    Use the 'case .. of' syntax for pattern matching.
-}
circ :: Shape -> Float
circ shape = case shape of -- own solution
    (Rectangle l w) -> 2 * (l + w)
    (Square a) -> 4 * a
    (Circle r) -> 2 * pi * r

circ' shape = case shape of -- sample solution
    Rectangle width length -> 2*width + 2*length
    Square width -> 4 * width
    Circle radius -> 2 * radius * pi

-----------------------------------------------------------
-- Typeclasses
-----------------------------------------------------------

{- Monoid
   There is a typeclass called Monoid that features
   1. One special (neutral) element 'e'
   2. A binary operation 'op'
   Moreover, there are rules:
   1. e `op` x = x `op` e = x, for all x
   2. (x `op` y) `op`z = x `op` (y `op`z) for all x,y,z

   **Note**
   The "official" names in Haskell for 'e' and 'op' are
   'mempty' and 'mconcat'.
-}
class MyMonoid a where
    e :: a
    op :: a -> a -> a

instance MyMonoid Int where
    e = 0
    op = (+)

{- Exercise
    Write a Monoid instance for [a] that satisfies the rules.
-}

instance MyMonoid [a] where
    e = []
    op = (++)