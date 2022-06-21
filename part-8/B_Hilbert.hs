{- 
    Das Mathematics Genealogy Project (https://www.mathgenealogy.org/id.php?id=7298)
    ist eine Auflistung aller/vieler Mathematiker/innen und deren Absolventen (als Doktoranden).
    Der Datentyp Descendant soll eine "Abstammungshierarchie" ausgehend von
    einer Mathematikerin oder eines Mathematikers wie folgt darstellen:
    Descendant 'Name Mathematiker/in' 'Abschlussjahr' 'Liste der Nachfolger/innen'
-}

type Name = String
type Year = Int

data Descendant = Descendant Name Year [Descendant]


{- BEISPIEL
    Das ist ein Teil der Hierarchie von David Hilbert.
-}
hilbert :: Descendant 
hilbert = 
    Descendant "David Hilbert" 1885
        [ Descendant "Wilhelm Ackermann" 1925 []
        , Descendant "Haskell Curry" 1930 
            [ Descendant "Bruce Lercher" 1963 []
            ]
        , Descendant "Anne Bosworth" 1899 []
        ]

{- AUFGABE
    Vervollständigen Sie die untenstehende Funktion 'countDescendants', 
    die alle Nachfolger (inklusive Nachfolger von Nachfolgern etc) eines 
    Mathematikers oder einer Mathematikerin zählen soll.

    Beispielausgabe:
    Eingabe: countDescendants hilbert
    Ausgabe: 4
-}
countDescendants :: Descendant -> Int
countDescendants (Descendant _ _ xs) =
    length xs + (sum (map countDescendants xs))

check :: Descendant -> Bool
check descendant = case descendant of
    Descendant _ _ [] -> True
    Descendant n year (x:xs) ->
        year < getYear x 
        && check x 
        && check (Descendant n year xs)
    where
        getYear :: Descendant -> Year
        getYear (Descendant _ y _) = y 

