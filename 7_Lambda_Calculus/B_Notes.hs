import qualified Data.Set as S

data LambdaExp
    = Var String
    | App LambdaExp LambdaExp
    | Abs String LambdaExp
    deriving Show

lambdaExp :: (String -> a) -> (a -> a -> a) -> (String -> a -> a) -> LambdaExp -> a
lambdaExp var app abs exp = case exp of
    Var x -> var x
    App t1 t2 -> app (recurse t1) (recurse t2)
    Abs x t -> abs x (recurse t)
    where
        recurse = lambdaExp var app abs

freeVars :: LambdaExp -> S.Set String
freeVars = lambdaExp var app abs
    where
        var :: String -> S.Set String
        var = S.singleton

        app :: S.Set String -> S.Set String -> S.Set String
        app = S.union

        abs :: String -> S.Set String -> S.Set String
        abs varName termVars = S.delete varName termVars



prettyPrint :: LambdaExp -> String
prettyPrint = lambdaExp id app abs
    where
        app :: String -> String -> String
        app s1 s2 = "(" ++ s1 ++ " " ++ s2 ++ ")"

        abs :: String -> String -> String
        abs x t = "L" ++ x ++ "." ++ t


-- Lx.(x x)
exp1 :: LambdaExp
exp1 = Abs "x" (App (Var "x") (Var "x"))


-- Lx.x
expId :: LambdaExp
expId = Abs "x" (Var "x")