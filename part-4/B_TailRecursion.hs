{-
    Not tail-recursive
-}
add :: [Integer] -> Integer
add [] = 0
add (x:xs) = x + add xs

{- The Accumulator Pattern
    Using the accumulator pattern, we can write 'add' as a
    tail recursive function.
-}
addT :: [Integer] -> Integer
addT = addT' 0
    where
        addT' n [] = n
        addT' n (x:xs) = addT' (n+x) xs

{-
    The same procedure can be applied to other recursive
    functions as well.
-}
fact :: Integer -> Integer
fact 0 = 1
fact n = n * fact (n-1)

factT :: Integer -> Integer
factT = factT' 1
    where
        factT' n 0 = n
        factT' n k = factT' (n*k) (k-1)

{- Exercise
    Now try it yourself and use the accumulator pattern to
    write tail-recursive versions of the functions 'pow'
    and 'palindrome'.
-}
pow :: Integer -> Integer -> Integer
pow _ 0 = 1
pow n k = n * pow n (k-1)

pow_ x y
    | y < 1 = 1
    | otherwise = x * pow x ( y - 1)

powT :: Integer -> Integer -> Integer
powT n = powT' 1
    where
        powT' a 0 = n
        powT' a k = powT' (a*n) (k-1)

powT_ = powTR_ 1
    where
        powTR_ acc x y
            | y < 1 = acc
            | otherwise = powTR_ (acc*x) x (y-1)

palindrome :: String -> Bool
palindrome w =
    l < 2 || (first_ == last_ && palindrome middle)
    where
        l = length w
        first_ = head w
        last_ = last w
        middle = tail $ init w

palindromeT :: String -> Bool
palindromeT = pal True
    where
        pal p w
            | length w < 2 = p
            | otherwise =
                pal (p && head w == last w) (tail (init w))

{-
    Sometimes the accumulator is a bit more complex, or there
    is more than one accululator, for example when multiple
    recursive calls are used together.
-}

fib :: Integer -> Integer
fib n | n < 2 = 1
      | otherwise = fib (n-1) + fib (n-2)

fib_ a b n
    | n == 0 = a
    | n == 1 = b
    | otherwise = fib_ b (a+b) (n-1)

fibT :: Integer -> Integer
fibT = fibT' 1 1
    where
        fibT' a b 1 = a
        fibT' a b n = fibT' (a+b) a (n-1)

{- Test
    Try out 'fib' and 'fibT' and see how far you can go in
    terms of larger input numbers.
-}

{- Continuation Pattern
    when the accumulator is a function, then the accumulator
    pattern is also called "continuation pattern".
-}

factAcc :: Integer -> Integer -> Integer
factAcc acc n
    | n < 1 = acc
    | otherwise = factAcc (n*acc) (n-1)

factCont :: (Integer -> Integer) -> Integer -> Integer
factCont cont n
    | n < 2 = cont n
    | otherwise = factCont (\x -> cont (n*x)) (n-1) -- B
--    | otherwise = factCont (\x -> n * cont x) (n-1) -- A

factC :: Integer -> Integer
factC = factC' (+1)
    where
        factC' f 0 = f 0
        factC' f n = factC'
            (\x -> n * f x)
            (n-1)

{- Exercise
    Now try it yourself and use the continuation pattern to
    write a tail-recursive version of the function 'myMap'.
-}

myMap :: (a -> b) -> [a] -> [b]
myMap f [] = []
myMap f (x:xs) = f x : myMap f xs

mapC :: (a -> b) -> [a] -> [b]
mapC f = mapC' id
    where
        mapC' h [] = h []
        mapC' h (x:xs) = mapC' (\y -> h (f x : y)) xs

myMapAcc :: (a -> b) -> [b] -> [a] -> [b]
myMapAcc f acc xs = case xs of
    [] -> reverse acc
    x:xs -> myMapAcc f (f x : acc) xs

--myMapCont :: (a -> b) -> ([b] -> [b]) -> [a] -> [b]
myMapCont f cont xs = case xs of
    [] -> cont []
    --x:xs -> myMapCont f (\ys -> cont ((f x):ys)) xs
    x:xs -> myMapCont f (\ys -> ((f x):cont (ys))) xs