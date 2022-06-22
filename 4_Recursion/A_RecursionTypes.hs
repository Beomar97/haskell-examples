{- Important Note
    We will treat natural numbers as 'Integers' througout this file. In
    particular, that means that function calls with negative integers will
    result in all kinds of unexpected/faulty behaviour. As an exercise, rewrite
    everything with the 'Nat' type.
-}


{- A Standard Example
    The function \x -> 2^x, recursively defined
-}

exp2 :: Integer -> Integer
exp2 0 = 1
exp2 n = 2 * exp2 (n-1)

{-
    With explicit "recursion body"
-}
exp2g :: Integer -> Integer
exp2g 0 = 1
exp2g n = g $ exp2g (n-1)
    where
        g x = 2 * x

{- Exercise:
    Implement the function \x -> 3^x with explicit "recursion body".
-}
exp3g :: Integer -> Integer
exp3g 0 = 1
exp3g n = g $ exp3g (n-1)
    where
        g x = 3 * x

{- A First Recursion Schema
    We can write a general schema to capture recursion of this style.
-}
simpleRec :: a -> (a -> a) -> Integer -> a
simpleRec c g 0 = c
simpleRec c g n = g $ simpleRec c g (n-1)

{- exp2 Defined with SimpleRec
    Now we can define exp2/g just as an instance
-}
exp2sr :: Integer -> Integer
exp2sr = simpleRec 1 (2*)

{- Exercise:
    Implement the function \x -> 5*x as an instance of simpleRec
-}
mul5 :: Integer -> Integer
mul5 = simpleRec 0 (5+)

{-
    Sometimes recursion not only depends on the previous value (of the function
    being defined), but also on the current "parameter". Such an example is
    the factorial, because (n+1)! = (n+1)*n! depends not only on n! but also on
    n. We can catch that in a schema as well.
-}
simpleRecN :: a -> (a -> Integer -> a) -> Integer -> a
simpleRecN c g 0 = c
simpleRecN c g n = g (simpleRecN c g (n-1)) (n-1)

{-
    Factorial as simple recursion with additional dependency
-}
fak :: Integer -> Integer
fak = simpleRecN 1 g
    where
        g x n = x * (n+1)

sum_ :: Integer -> Integer
sum_ = simpleRecN 0 g
    where
        g x n = x + (n+1)

{-
    Other functions such as general exponentials \x y -> x^y require additionl
    parameters. We can simply add these parameters to the simple recursion
    scheme from before. The schema that we obtain is called 'primitive recursion'
-}
primRec :: (x -> a) -> (a -> Integer -> x -> a) -> Integer -> x -> a
primRec c g 0 x = c x
primRec c g n x = g (primRec c g (n-1) x) (n-1) x

{-
    Exponentials as primitive recursive definition.
-}
exp_ :: Integer -> Integer -> Integer
exp_ = primRec c g
    where
        c = const 1
        g a _n x = x * a

{- Course of Value Recursion
    The "next" value may depend on all previous values.
-}
valueRec :: ([a] -> a) -> Integer -> a
valueRec g n = g values
    where
        f = valueRec g
        values = [f (n-k) | k <- [1..n]]

{- Course of Value Recursion with Parameters
    The same thing with additional parameters.
-}
valueRecParam :: ([a] -> Integer -> x -> a) -> Integer -> x -> a
valueRecParam g n x = g values n x
    where
        f = valueRecParam g
        values = [f (n-k) x | k <- [1..n]]

{-
    Fibonacci as corse of value recursion.
-}
fib :: Integer -> Integer
fib = valueRec g
    where
        g [] = 1
        g [_] = 1
        g (a:b:_) = a + b