------------------------------------------------------------
-- Aufgabe 1
------------------------------------------------------------

-- Implementieren Sie die Shapes EDSL als “Deep Embedding”.

import Matrix ( Vector, Point, Matrix (Matrix), apply, invert )

data Shape
    = Empty
    | UnitDisc
    | UnitSquare
    | Translate Vector Shape
    | Negate Shape
    | Intersect Shape Shape
    | Merge Shape Shape
    | Minus Shape Shape
    | Stretch Vector Shape
    | FlipX Shape
    | FlipY Shape
    | Flip45 Shape
    | Flip0 Shape
    | Rotate Float Shape
    deriving (Eq, Show)

inside :: Shape -> Point -> Bool
inside shape (x,y) = case shape of
    Empty -> False
    UnitDisc -> x^2 + y^2 <= 1
    UnitSquare -> abs x <= 1 && abs y <= 1
    Translate (dx, dy) s -> inside s (x - dx, y - dy)
    Negate s -> not $ inside s (x, y)
    Intersect s1 s2 -> combine s1 s2 (&&)
    Merge s1 s2 -> combine s1 s2 (||)
    Minus s1 s2 -> combine s1 (Negate s2) (&&)
    Stretch (rx, ry) s -> transformByM s $
        Matrix (rx, 0) (0, ry)
    FlipX s -> transformByM s $
        Matrix (1, 0) (0, -1)
    FlipY s -> transformByM s $
        Matrix (-1, 0) (0, 1)
    Flip45 s -> transformByM s $
        Matrix (0, 1) (1, 0)
    Flip0 s -> transformByM s $
        Matrix (-1, 0) (0, -1)
    Rotate a s -> transformByM s $
        Matrix (cos a, -(sin a)) (sin a, cos a)
    where
        combine s1 s2 op = op (inside s1 (x,y)) (inside s2 (x,y))

        transformByM :: Shape -> Matrix -> Bool
        transformByM s m = inside s $ apply (invert m) (x,y)

render :: Float -> Float -> Shape -> IO ()
render canvasLength canvasHeight shape = writeFile "shape.txt" lines
    where
        draw p
            | inside shape p = ('#', p)
            | otherwise = (' ', p)

        breakLn (d, (x,y))
            | x == canvasLength = [d,'\n']
            | otherwise = [d]

        pixels =
            [ draw (x,y)
                | y <- [(-canvasHeight)..canvasHeight]
                , x <- [(-canvasLength)..canvasLength]
            ]

        lines = concatMap breakLn pixels

------------------------------------------------------------
-- Aufgabe 2
------------------------------------------------------------

-- Implementieren Sie eine EDSL für die LOOP Programmiersprache (https://en.wikipedia.org/wiki/LOOP_(programming_language)).
-- Orientieren Sie sich an diesem Repo (https://gitlab.com/olodnad/while-cli/).

-- Solution see here: https://gitlab.com/olodnad/while-cli/