{- Contents
    A short introduction to Haskell;
    On how to create your own types
-}

{- Preliminary Remark
    There are several different Keywords to declare new 
    types ('data', 'newtype', 'type'). We will discuss the
    difference of these keywords and when to use
    which later.    
-}

-----------------------------------------------------------
-- Product Types
-----------------------------------------------------------

{- Records
    Records are tuples with custom named fields and a 
    constructor.
-}
data Character = Character
    { firstName :: String
    , lastName:: String
    }

han :: Character
han = Character
    { firstName = "Han"
    , lastName = "Solo"
    }

obiWan :: Character
obiWan = Character
    { firstName = "Obi-Wan"
    , lastName = "Kenobi"
    }

{- "Getters"
    Values can be extracted from records by using the fields
    name as a function.
    firstName :: Character -> String
    age :: Character -> Integer
-}
solo :: String
solo = firstName han

kenobi :: String
kenobi = lastName obiWan

{- 'first' and 'last' can be used like any other function.
-}
firstNames :: [String]
firstNames = map firstName [ han, obiWan ]

{- Exercise
Greet Obi-Wan and Han, each with a phrase like e.g. 
"Hello Obi-Wan". Use 'map' and 'first'.
-}
greetings :: [String]
greetings = map ( \n -> "Hello " ++ firstName n) [ han, obiWan ] -- own solution
greetings2 = map (("Hello " ++) . firstName) [ han, obiWan ] -- sample solution

{- "Setters"
    Values of a record can be changed with the syntax below.
    What is important to note here is that 'han' will not be
    changed. A copy of 'han' will be made with the first 
    name changed.
-}
ben :: Character
ben = han {firstName = "Ben"}

-----------------------------------------------------------
-- Sum Types
-----------------------------------------------------------

{- Sum Types
    The values of a sum type come in a number of different
    variants. Each value can be uniquely assigned to one of
    the variants.
    Our first sum type contains exactly two values. This 
    type is isomorphic to 'Bool'.
-}
data YesNo
    = Yes -- Constructors
    | No

yes :: YesNo
yes = Yes

{- The following types look similar to the type above, but
    they contain values in the options.
-}
data Identification
    = Email String
    | Username String

hanId :: Identification
hanId = Username "han_32"

obiWanId :: Identification
obiWanId = Email "kenobi@rebel-alliance.space"

{- Recursive Types
    A cool fact about union types is that they can be
    recursive. The standard example is that of binary trees.
-}
data BinaryTree a
    = Node a (BinaryTree a) (BinaryTree a)
    | Leaf a

{-
    A simple binary tree with integers.
-}
tree :: BinaryTree Int
tree = Node 1 (Leaf 2) (Leaf 3)

{- Lists are also a recursive sum type (with syntactic sugar
    for 'Cons' and 'E') 
-}
data MyList a
    = Cons a (MyList a)
    | Nil

{- 
    [1,2,3] as 'MyList'
-}
list :: MyList Integer
list = 
    Cons
        1
        (Cons 
            2
            (Cons
                3
                Nil
            )
        )

{- Combining Unions and Records
    It is possible to "inline" records in cases of union
    types.
-}
data Shape
    =  Circle { radius :: Float }
    |  Rectangle 
        { len :: Float
        , width :: Float
        }
    
