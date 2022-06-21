{-
We want to work with lambda expressions. For this it will
be beneficial to work with Set-types.
-}

import Data.Set (Set, singleton, union, empty, delete, insert, disjoint)

{-
Let's first look at simple lambda terms
-}


-----------------------------------------------------------
-- | Simple lambda terms
-----------------------------------------------------------

data Term
    = Var String
    | App Term Term
    | Abs String Term
    deriving (Show, Eq)

pretty :: Term -> String
-- Variables
pretty (Var name) = name
-- Application
pretty (App t l) = "(" ++ pretty t ++ " " ++ pretty l ++ ")"
-- Abstraction
pretty (Abs x t) = "L" ++ x ++ "." ++ pretty t


{-
It's beneficial to have a generalized fold
for the Term-type. We can use this opportunity
to exercise our generalized fold skills.

Exercise: implement the generalized fold `term`
-}

term
    :: (String -> a)
    -> (a -> a -> a)
    -> (String -> a -> a)
    -> Term
    -> a
term var app abst lTerm = case lTerm of
    Var str -> var str
    App t s -> app (recurse t) (recurse s)
    Abs str t -> abst str (recurse t)
    where
        recurse = term var app abst


{- We can now implement the functions:
  'freeVars' to compute the free variables of a term
  'boundVars' to compute the bound variables of a term.
-}
freeVars :: Term -> Set String
freeVars = term singleton union delete

boundVars :: Term -> Set String
boundVars = term (const empty) union insert


{-
Having equiped ourselves with the possibility to
check for free vars and bound vars, we can substitute
terms into other terms.

Exercise: Implement the substituion of a term into another term
-}

-- | subs A x B = A [x:=B]
subs :: Term -> String -> Term -> Term
subs a v b = case a of
    Var str | str == v  -> b
            | otherwise -> a
    App t1 t2 -> App (subs t1 v b) (subs t2 v b)
    Abs x t | x == v -> a
            | disjoint (freeVars b) (boundVars a) ->
                Abs x (subs t v b)
            | otherwise -> undefined


-- Some simple terms
exampleTermVar = Var "x" -- "(x)"
exampleTermApp = App (Var "x") (Var "y") -- "(x y)"
exampleTermAbs = Abs "x" (Var "x") -- lambda x . x

-- Often used variables
var_x = Var "x"
var_y = Var "y"
var_z = Var "z"
var_f = Var "f"
var_g = Var "g"


-- Define some simple Terms
term_xy = App var_x var_y -- "(x y)
term_Lf.x = Abs "f" var_x -- "lambda f . x"

{-
Exercise: Define the following lambda expressions as terms
-}

-- (λz.zx)
term_1 = Abs "z" term_zx where term_zx = App var_z var_x

-- (λv.xv)(λwu.wuw)
term_2 = let links  = Abs "v" (App (Var "x")(Var "v"))
             rechts = Abs "w" (Abs "u" (App (App (Var "w") (Var "u")) (Var "w")))
         in App links rechts

-- (λxy.x(yz))
term_3 = Abs "x" (Abs "y" (App var_x (App var_y var_z)))

-- x((λz.xz)z)
term_4 = App var_x (App (Abs "z" (App var_x var_z)) var_z)

-- x((λz.xz)(λy.z))
term_5 = let lz_xz = Abs "z" (App var_x var_z)
             ly_z = Abs "y" var_z
         in App var_x (App lz_xz ly_z)



{-
You can now use the pretty print to test `term_1`, ..., `term_5`
-}

-- pretty term_1 -- (λz.zx)
-- pretty term_2 -- (λv.xv)(λwu.wuw)
-- pretty term_3 -- (λxy.x(yz))
-- pretty term_4 -- x((λz.xz)z)
-- pretty term_5 -- x((λz.xz)(λy.z))


-- You can also test the substituion function

-- pretty term_2
-- --==>"(Lv.(x v) Lw.Lu.((w u) w))"
-- pretty $ subs term_2 "x" var_z
-- --==>"(Lv.(z v) Lw.Lu.((w u) w))"

{-
Note that substition is sometimes undefined
-}