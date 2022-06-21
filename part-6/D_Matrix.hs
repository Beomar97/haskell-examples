module Matrix where

type Point = (Float, Float)
type Vector = Point

data Matrix = Matrix (Float, Float) (Float, Float)
    deriving Show

scale :: Float -> Matrix -> Matrix
scale r (Matrix (a, b) (c, d)) = Matrix (r*a, r*b) (r*c, r*d)

invert :: Matrix -> Matrix
invert (Matrix (a, b) (c, d)) = scale
    (1/(a*d - b*c))
    (Matrix (d, -b) (-c, a))

apply :: Matrix -> Vector -> Vector
apply (Matrix (a, b) (c, d)) (x, y) =
    ( a*x + b*y
    , c*x + d*y
    )

