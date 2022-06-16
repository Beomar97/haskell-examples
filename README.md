# Funktionale Programmierung FS22

## Part 1

**Das Imperative Modell** basiert auf Zuständen, Zustandsübergängen und deren zeitlichen Abfolge (Schritt-für-Schritt).

```c
sum(L) {
	l = length(L)
	i=0 acc = 0
	while (i < l) {
		acc = acc + L[i]
		i=i+1
  }
	return acc
}
```

**Das Funktionale Modell** ist nahe ander mathematischen Notation (Funktionen sind mathematische Objekte). Definition einer Funktion anstelle expliziter Anweisungen.

```haskell
sum [] = 0
sum (a1:rest) = a1 + sum rest
```

**Pragmatische Interpretation** für die funktionale Programmierung:

- Vollwertige Unterstützung von Funktionen (1st Class Functions)
  - Funktionen höherer Ordnung, Lambda-Terme, Currying, Partielle Anwendung, ...
- Immutable Data
  - Referenzielle Transparenz, Type Safety, ...
- Hoch entwickeltes Typensystem
  - Algebraische Datentypen, Pattern Matching, Typinferenz, ...
- Rekursion
  - Tail-Call-optimization

**Anwendungen:** Compilerbau, Theorembeweiser, KI, Numerik, Data Science, FIntech, Sonstiges bis hin zu GUI Programmierung

### Code

#### Basics

**Types:**

Integer e.g. `5`

Float e.g. `5.0`

Bool e.g. `True` or `False`

Char e.g. `'a'`

String e.g. `"string"`

Lists e.g. `[Type]`

**Bool Operators:**

Oder `||`

Und `&&`

Nicht (!=) `not`

concat => `greeting = "hello" ++ " " ++ "world"`

`greeting2 = concat ["hello", " ", "world"]`

**Math Operators:**

Integer Division \`div\`

Normal Division `/ `

**List Comprehension:**

Range e.g. `someInts = [1..15]`

`someEvens = [2*x | x <- [-5..5]]`

#### Functions

**Functions:**

General Syntax: Input on Left, Output on Right

`inc1 n = n + 1`

Lambda Notation: Everything written on right side

`inc1 = \n -> n + 1`

Tupled Inputs

`addTupled :: (Integer, Integer) -> Integer`

`addTupled (x, y) = x + y`

**Curried Functions:** a function that returns a function

`add = \ x y -> x + y` (collapsed lambdas)

`add = \x -> \y -> x + y`

`add x = \y -> x + y`

`add x y = x + y`

**Partial Application:** special case of 'add'

`add3 = add 3`

`add3 x = add 3 x`

Binary Function `(++)` concatenates strings

`prepArrow = (++) "=> "`

`prepArrow string = "=> " ++ string`

**High-Order Functions:**

Function as Input

`apply f x = f x` accepts function as input and apply to argument

Function as Input and Output

`twice f x = f (f x)` Accepts and returns a function

`compose f g x = g (f x)` accepts two functions and applies them to the argument

**List Map:**

Apply a function to every element in the list

`mapping = map (\n -> n + 1) [1, 2, 3]`

`mapping2 = map (+ 1) [1, 2, 3]`

#### Types

**Product Types:**

```haskell
-- Records are tuples with custom named fields and a constructor.
data Character = Character
    { firstName :: String
    , lastName:: String
    }
    
han :: Character
han = Character
    { firstName = "Han"
    , lastName = "Solo"
    }
    
-- Getters
-- Values can be extracted from records by using the fields name as a function.
solo :: String
solo = firstName han

-- Setters
-- Values of a record can be changed with the syntax below.
-- A copy of 'han' will be made.
ben :: Character
ben = han {firstName = "Ben"}
```

**Sum Types:**

The values of a sum type come in a number of different variants. Each value can be uniquely assigned to one of the variants.

```haskell
data YesNo
    = Yes
    | No

yes :: YesNo
yes = Yes

data Identification
    = Email String
    | Username String

hanId :: Identification
hanId = Username "han_32"

obiWanId :: Identification
obiWanId = Email "kenobi@rebel-alliance.space"
```

**Recursive Types:**

```haskell
data BinaryTree a
    = Node a (BinaryTree a) (BinaryTree a)
    | Leaf a

tree :: BinaryTree Int
tree = Node 1 (Leaf 2) (Leaf 3)

-- Lists are also a recursive sum type (with syntactic sugar for 'Cons' and 'E') 
data MyList a
    = Cons a (MyList a)
    | Nil

-- [1,2,3] as 'MyList'
list :: MyList Integer
list = Cons 1 (Cons 2 (Cons 3 Nil))

-- Combining Unions and Records
data Shape
    =  Circle { radius :: Float }
    |  Rectangle 
        { len :: Float
        , width :: Float
        }
```

#### Control

**If Else:**

`three = if True then 3 else 4`  Ternary operator

```haskell
describe :: Integer -> String
describe x =
    if x < 3 then 
        "small"
    else if x < 5 then 
        "medium"
    else
        "large"
```

**Guards:**

```haskell
describe' :: Integer -> String
describe' x
    | x < 3     = "small"
    | x < 4     = "medium"
    | otherwise = "large"
```

**Cases:**

```haskell
count :: Integer -> String
count 0 = "zero"
count 1 = "one"
count 2 = "two"
count _ = "I don't know"

-- Alternative Syntax
count' :: Integer -> String
count' n = case n of
    0 -> "zero"
    1 -> "one"
    2 -> "two"
    _ -> "I don't know"
```

**Let Bindings:**

```haskell
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
```

**Where:**

Where is the same as let, but it does not preceed but follow a "main" declaration.

```haskell
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
```

