-----------------------------------------------------------
-- If Else and Guards
-----------------------------------------------------------

{- IfElse
    * If-else expressions denote "normal" values
-}
three :: Integer
three = if True then 3 else 4

four :: Integer
four = if False then 0 else 4

collatzNext :: Integer -> Integer
collatzNext x =
    if x `mod` 2 == 0 then
        x `div` 2
    else
        3*x+1

{- Nesting
    If-else expressions with multiple cases are possible
    with nesting.
-}
describe :: Integer -> String
describe x =
    if x < 3 then 
        "small"
    else if x < 5 then 
        "medium"
    else
        "large"

{- Guards
    An alternative way to declare functions by case analysis
    are guards.
-}
describe' :: Integer -> String
describe' x
    | x < 3     = "small"
    | x < 4     = "medium"
    | otherwise = "large"

sign :: Integer -> Integer
sign x 
    | x < 0     = -1
    | x > 0     = 1 
    | otherwise = 0

{- Exercise
    rewrite the function 'fIfElse' using guards.
-}
fIfElse :: Integer -> String
fIfElse n = 
    if n `mod` 2 == 1 then
        if n `mod` 3 /= 0 then
            "Oddity"
        else 
            "Odd"
    else 
        "Even"


fGuard :: Integer -> String -- nesting not possible using guards
fGuard n
    | n `mod` 2 == 0 = "Even"
    | n `mod` 3 == 0 = "Odd"
    | otherwise      = "Oddity"


-----------------------------------------------------------
-- Cases and pattern matching
-----------------------------------------------------------

{- Cases 1
    Aside from if-else and guards, Haskell also allows for
    functions to be declared in separate clauses.
-}

count :: Integer -> String
count 0 = "zero"
count 1 = "one"
count 2 = "two"
count _ = "I don't know"

{- Cases 2
    There is also an alternative syntax for cases (that make
    declarations a bit easier to maintain in some cases).
-}

count' :: Integer -> String
count' n = case n of
    0 -> "zero"
    1 -> "one"
    2 -> "two"
    _ -> "I don't know"


{- Cases Importance
    The true "power" of cases is in conjunction with custom
    types and pattern matching. We will learn how this works
    later.
-}

data Shape
    = Rectangle Float Float
    | Circle Float

circumference :: Shape -> Float
circumference shape = case shape of
    Rectangle length width -> 
        2*length + 2*width
    Circle radius -> 
        2*radius*pi

{- Exercise
    Define a function 
    'area :: Shape -> Float'
    to compute the area of any given shape. Use spearate 
    cases such as in 'Case 1' above.
-}
area :: Shape -> Float
area shape = case shape of
    Rectangle length width ->
        length * width
    Circle radius ->
        radius * radius * pi

area2 (Rectangle l w) = l * w
area2 (Circle r) = r * r * pi

-----------------------------------------------------------
-- Let and where
-----------------------------------------------------------

{- Let Bindings 
    It is possible to name one or more values in a 
    "let-block" and these abbreviations in the subsequent
    expression.
-}
five :: Integer
five =
    let 
        x = 2
        y = x + 1
    in
    x + y

myFunc :: Integer -> Integer
myFunc x =
    let 
        complicated = 
            x `mod` 2 == 0 && x `mod` 4 /= 0
    in
    if complicated then 
        x `div` 2
    else 
        x + 1

{- Where 
    Where is the same as let, but it does not preceed but
    follow a "main" declaration.
-}
six :: Integer
six =
    x + y
    where
        x = 2
        y = x + 2

myFunc' :: Integer -> Integer
myFunc' x =
    (magicNumber * x) + 1
    where
        magicNumber = x + 42
