module Shape where

import Data.List
import Matrix (Matrix (Matrix), Vector, Point, invert, apply)
-- :l 6_Combiners_and_EDSL/Matrix.hs 6_Combiners_and_EDSL/A_Shapes.hs

{- Definition of 'Shape'
    Shapes are things that discriminate between outside and inside
-}
newtype Shape = Shape { inside :: Point -> Bool }

{- Basic Shapes
    These are the basic shapes used to construct more complicated shapes
-}

{-
    A simple empty shape
-}
empty :: Shape
empty = Shape $ const False

{-
    A disc with radius 1 located at (0,0)
-}
unitDisc :: Shape
unitDisc = Shape $ \(x, y) ->
    x^2 + y^2 <= 1

{-
    A square with length/width 1 located at (0,0)
-}
unitSq :: Shape
unitSq = Shape $ \(x, y) ->
    abs x <= 1 && abs y <= 1

{- Manipulations
   Functions to change and combine existing shapes into new shapes
-}

{- Translation
    Moving a shape along a vector
-}
translate :: Vector -> Shape -> Shape
translate (dx, dy) s = Shape $ \(x, y) ->
    inside s (x - dx, y - dy)

{- Inverting
    Inverting a shape i.e. switching outside vs inside
-}
negate :: Shape -> Shape
negate s = Shape $ not . inside s

{- General combinator
    Combining two shapes with a parametric boolean function
-}
combineBool
    :: (Bool -> Bool -> Bool)
    -> Shape
    -> Shape
    -> Shape
combineBool f s1 s2 = Shape $ \p -> f (f1 p) (f2 p)
    where
        f1 = inside s1
        f2 = inside s2

{-
    All points that are in both shapes
-}
intersect :: Shape -> Shape -> Shape
intersect = combineBool (&&)

{-
    All points that in at least one of the shapes
-}
merge :: Shape -> Shape -> Shape
merge = combineBool (||)

{-
    All points in the first shape that are not in the secnond shape
-}
minus :: Shape -> Shape -> Shape
minus = combineBool c
    where
        c b1 b2 = b1 && not b2


{- Matrix transformations
    Applying a matrix/linear transformation to a shape
-}
transformM :: Matrix -> Shape -> Shape
transformM m s = Shape $ \p ->
    inside s $ apply m' p
    where
        m' = invert m

{-
    Stretch a shape along the X axis
-}
stretchX :: Float -> Shape -> Shape
stretchX r = transformM $ Matrix (r, 0) (0, 1)

{-
    Stretch a shape along the Y axis
-}
stretchY :: Float -> Shape -> Shape
stretchY r = transformM $ Matrix (1, 0) (0, r)

{-
    Stretch a shape
-}
stretch :: Float -> Shape -> Shape
stretch r = transformM $ Matrix (r, 0) (0, r)

{-
    Mirror a shape at the X-axis
-}
flipX :: Shape -> Shape
flipX = transformM (Matrix (1, 0) (0, -1))

{-
    Mirror a shape at the Y-axis
-}
flipY :: Shape -> Shape
flipY = transformM (Matrix (-1, 0) (0, 1))


flip45 :: Shape -> Shape
flip45 = transformM (Matrix (0, 1) (1, 0))

{-
    Mirror a shape at the origin
-}
flip0 :: Shape -> Shape
flip0 = transformM (Matrix (-1, 0) (0, -1))


{-
    Rotate a shape around the origin
-}
rotate :: Float -> Shape -> Shape
rotate a = transformM $ Matrix
        (cos a, -(sin a))
        (sin a, cos a)

{- Semantics
    Here we render/interpret shapes in terms of "ASCII-Art" text files
-}

render :: Float -> Float -> Shape -> IO ()
render length height shape = writeFile "shape.txt" lines
    where
        draw p
            | inside shape p = ('#', p)
            | otherwise = (' ', p)

        breakLn (d, (x,y))
            | x == length = [d,'\n']
            | otherwise = [d]

        pixels = [draw (x,y) | y <- [(-height)..height],  x <- [(-length)..length]]

        lines = concatMap breakLn pixels

-- Examples

shape1 = translate (100, 100) $ stretch 10 unitDisc
shape2 = rotate 1 unitSq

shape3 = translate (100, 100) $ merge shape1 shape2

iShape = flipX $ merge
    (stretchY 2 unitSq)
    (translate (0, 5) unitDisc)

disc50 = stretch 50 unitDisc