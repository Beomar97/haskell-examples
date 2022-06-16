{- Contents
    A short introduction to Haskell;
    The very basics
-}


-----------------------------------------------------------
-- Comments
-----------------------------------------------------------

-- a single line comment

{- a multiline comment
   {- can be nested -}
-}

{- Usually (from now on), we will try to adhere to the
    following conventuion/structure for multiline comments:
-}

{- Optional "title" of the comment
    Content of the comment possibly spaning multiple lines
    with length <= 60.
-}


-----------------------------------------------------------
-- Simple declarations
-----------------------------------------------------------

{- Declaring a variable
    Generally, in Haskell we define the type of a variable
    in a separate line before we define the variable.
-}

-- 'five' is the integer 5
five :: Integer
five = 5

{-
    'six' is the integer 6. The type 'Integer' can
    accomodate integers of arbitrary size
-}
six :: Integer
six = 6

-- 'four' is the float 4.0
four :: Float
four = 4


-----------------------------------------------------------
---- Numeric operations
-----------------------------------------------------------

seven :: Integer
seven = five + 2

theIntEight :: Integer
theIntEight = 3 + five

theFloatSeven :: Float
theFloatSeven = 3 + four

twentyFour :: Float
twentyFour = 3 * 2 ^ 3

{- Integer division
    'div' denotes integer division. Generally, it is
    possible to write a function between '`' to use infix
    notation. I order to define functions that are
    "natively" infix, you would use brackets '(...)' when
    defining the function/operator.
-}
intSevenByThree :: Integer
intSevenByThree = seven `div` 3

{- Division
    The "normal" division '/' is for "fractional numbers,
    e.g. floats.
-}
floatSevenByThree :: Float
floatSevenByThree = 7 / 3

{- Exercise
    Fill out the types where possible
    Check your solutions with the REPL.
-}

x :: Integer
x = 2 ^ 3

y :: Float
y = 2.0 ^ 3

a :: Integer
a = x + 5

b :: Float
b = y / 2

c :: Float -- Does not work => change from `div` to /
-- c = y `div` 3
c = y / 3 


-----------------------------------------------------------
---- Booleans and boolean operations
-----------------------------------------------------------

true :: Bool
true = True

false :: Bool
false = False

alsoTrue :: Bool
alsoTrue = true || false

alsoFalse :: Bool
alsoFalse = true && false

moreTruth :: Bool
moreTruth = not alsoFalse


-----------------------------------------------------------
---- Strings and chars
-----------------------------------------------------------

aChar :: Char
aChar = 'a'

aString :: String
aString = "Happy new year"

greeting :: String
greeting = aString ++ " " ++ "2022"

greeting2 :: String
greeting2 = concat
    [ aString
    , " "
    , "2022"
    ]



{- Warning
    The operators are strongly typed; they can only digest
    values of the same type. The following declarations are
    thus rejected by the type checker:

    aString = "Happy new year"
    greeting = aString ++ " " ++ 2022

    five :: Int
    five = 5
    seven = five + 2.0
-}


-----------------------------------------------------------
---- Lists
-----------------------------------------------------------

{-
    We will often use `List` (linked lists), a generic
    container to hold multiple values of *the same type*.
-}

aListOfStrings :: [String]
aListOfStrings = [ "one", "two", "three" ]

aListOfInts :: [Integer]
aListOfInts = [ 1, 2, 3 ]

{- Exercise
    Fill out the type, check your solutions with the REPL.
-}

friendGroups :: [[String]]
friendGroups = [
    ["Peter", "Anna", "Roman", "Laura"],
    ["Anna","Reto"],
    ["Christoph", "Mara", "Andrew"]
    ]


{- List comprehension
    Aside from declaring lists explicitly by writing down
    their element (as shown before), lists can also be
    declared by "list comprehension" and also as "ranges".
-}

someInts :: [Integer]
someInts = [1..15] -- range

someEvens :: [Integer]
someEvens = [ 2*x | x <- [-5..5]]

pairs :: [(Integer, Bool)]
pairs = [ (x,y) | x <- [0..5], y <- [True, False]]

lessThanPairs :: [(Integer,Integer)]
lessThanPairs = [ (x,y)
                  | x <- [0..5]
                  , y <- [0..5]
                  , x < y -- guard
                  , x > 1 -- second guard
                  ]

{- Exercise
    Use list comprehension to declare a list that contains
    all square numbers between 1 and 100.
-}

squares :: [Integer]
squares = [ x*x | x <- [1..100], x*x <= 100] -- own solution
squares2 = [ x*x | x <- [1..10]] -- sample solution


{- Exercise
    Use list comprehension to declare a list that contains
    all  odd square numbers between 1 and 100.
-}

oddSquares :: [Integer]
oddSquares = [ x*x | x <- [1..100], x*x <= 100, x*x `mod` 2 == 1] -- own solution
oddSquares2 = [ x | x <- squares, x `mod` 2 /= 0 ] -- sample solution
oddSquares3 = [ x | x <- squares, odd x ] -- ide suggestion solution