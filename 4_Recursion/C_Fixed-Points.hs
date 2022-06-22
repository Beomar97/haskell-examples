-- Simplifying type annotations
type I = Integer

-- The fixed point cimbinator
fix f = f $ fix f

-- Realizing the recursive exponentiation via a fixed point
expF :: I -> (I -> I) -> I -> I
expF base f x
    | x <= 0 = 1
    | otherwise = base * (f (x-1))

exp2 :: I -> I
exp2 = fix $ expF 2

-- Realizing the Fibonacci function via a fixed point

fibnacciF :: (I -> I) -> I -> I
fibnacciF f x
    | x <= 1 = 1
    | otherwise = f (x-1) + f (x-2)

fibonacci :: I -> I
fibonacci = fix $ fibnacciF

-- Realizing the Collatz function via a fixed point
collatzF :: (I -> [I]) -> I -> [I]
collatzF f x
    | x <= 1 = [1]
    | otherwise = x:(f (next x))
    where
        next x
            | x `mod` 2 == 0 = x `div` 2
            | otherwise = 3*x+1

collatz :: I -> [I]
collatz = fix $ collatzF


-- Fixed Points with effectful functions

fix f = f $ fix f

fibE :: (Monad m) => (I -> m I) -> (I -> m I)
fibE _ 0 = return 0
fibE _ 1 = return 1
fibE f n = (+) <$> f (n-1) <*> f (n-2)

expE :: (Monad m) => (I -> m I) -> (I -> m I)
expE _ 0 = return 1
expE f n = (*) 2 <$> f (n-1)

memoize :: (MonadState (MS.Map I I) m) => (I -> m I) -> (I -> m I)
memoize f x = do
  v <- gets (MS.lookup x)
  case v of
    Just y -> return y
    _      -> do
      y <- f x
      modify $ MS.insert x y
      return y

log' :: (I -> IO I) -> (I -> IO I)
log' g x = do
  putStrLn $ "put on stack:   " ++ (show x)
  y <- g x
  -- putStrLn $ "compute result: " ++ (show y)
  return y

memoFib :: I -> I
memoFib n = evalState (fix (memoize . fibE) n) MS.empty

loggedFib :: I -> IO I
loggedFib = fix $ log' . fibE

loggedExp :: I -> IO I
loggedExp = fix $ log' . expE

