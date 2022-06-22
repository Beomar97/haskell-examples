{- Simple Arithmetic Expressions
-}
data Exp
    = Const Int
    | Add Exp Exp
    | Mul Exp Exp
    | Div Exp Exp
    deriving Show

{- Examples
-}
x = Const 304
y = Const 7
z = Const 0
good = (Const 7 `Mul` (x `Add` z)) `Div` y
bad = (x `Add` y) `Div` z

{- Simple Evaluation
    is error prone
-}
sEval :: Exp -> Int
sEval e = case e of
    Const x -> x
    Add e1 e2 -> sEval e1 + sEval e2
    Mul e1 e2 -> sEval e1 * sEval e2
    Div e1 e2 -> sEval e1 `div` sEval e2

{- Error Handling Result Type
-}
data Result a
    = DivisionByZeroError
    | Success a
    deriving Show

{- Exercise
    Rewrite the eval function so that errors are handled correctly.
    Write the function "by hand", without using abstractions (Monad, Applicative).
-}
evalE :: Exp -> Result Int
evalE e = case e of
    Const x -> Success x
    Add e1 e2 -> case evalE e1 of
        DivisionByZeroError -> DivisionByZeroError
        Success x1 -> case evalE e2 of
            DivisionByZeroError -> DivisionByZeroError
            Success x2 -> Success $ x1 + x2
    Mul e1 e2 -> case evalE e1 of
        DivisionByZeroError -> DivisionByZeroError
        Success x1 -> case evalE e2 of
            DivisionByZeroError -> DivisionByZeroError
            Success x2 -> Success $ x1 * x2
    Div e1 e2 -> case evalE e1 of
        DivisionByZeroError -> DivisionByZeroError
        Success x1 -> case evalE e2 of
            DivisionByZeroError -> DivisionByZeroError
            Success x2
                | x2 /= 0 -> Success $ x1 `div` x2
                | otherwise -> DivisionByZeroError

{- Exercise
    We want to refactor the code from before using abstactions of Functor,
    Applicative and Monad.
-}
{- Exercise
    First write instances for the Result type.
-}
instance Functor Result where
    -- (a - > b) -> f a -> f b
    fmap f (Success x) = Success (f x)
    fmap f _ = DivisionByZeroError

instance Applicative Result where
    -- f (a -> b) -> f a -> f b
    Success f <*> Success x = Success $ f x
    _ <*> _ = DivisionByZeroError
    -- pure :: a -> Result a
    pure = Success

instance Monad Result where
    -- m a -> ( a -> m b) -> m b
    Success x >>= f = f x
    _ >>= _ = DivisionByZeroError

{- Exercise
    Now use the instances to refactor the eval function.
-}
evalE2 :: Exp -> Result Int
evalE2 e = case e of
    Const x -> Success x
    Add e1 e2 -> (+) <$> evalE2 e1 <*> evalE2 e2
    Mul e1 e2 -> (*) <$> evalE2 e1 <*> evalE2 e2
    Div e1 e2 -> do
        x1 <- evalE2 e1
        x2 <- evalE2 e2
        if x2 == 0 then
            DivisionByZeroError
        else
            return $ x1 `div` x2