{- Fuzzy Logik 
    In der Fuzzy-Logik sind Wahrheitswerte nicht bloss Falsch/0 oder Wahr/1, sondern 
    können beliebige Werte zwischen 0 und 1 annehmen.
    Für die Spezifikation der logischen Operatoren (And, Or, Not) können Sie sich 
    auf den untenstehenden Code des 'shallow embeddings', oder auf 
    https://de.wikipedia.org/wiki/Fuzzylogik beziehen.
-}

{- Shallow Embedding
    Im folgenden ist eine sehr einfache EDSL für die Fuzzy-Logik als 'shallow
    embedding' gegeben.
-}

newtype FuzzyBool = FuzzyBool {value :: Float}
    deriving Show

fuzzyAnd :: FuzzyBool -> FuzzyBool -> FuzzyBool
fuzzyAnd v w = FuzzyBool $ min (value v) (value w)

fuzzyOr :: FuzzyBool -> FuzzyBool -> FuzzyBool
fuzzyOr v w = FuzzyBool $ max (value v) (value w)

fuzzyNot ::FuzzyBool -> FuzzyBool
fuzzyNot v = FuzzyBool $ 1 - (value v)

-- Beispiel eines Ausdruckes mit 'Wahrheitswert' 0.5.
fShallow :: FuzzyBool
fShallow = fuzzyAnd
    ( fuzzyOr
        (FuzzyBool 0.5)
        (FuzzyBool 0.3)
    )
    ( fuzzyNot
        (FuzzyBool 0.1)
    )

{- AUFGABE
    Implementieren Sie ein DEEP EMBEDDING für die Fuzzy-Logik. Sie können die
    untenstehenden Codefragmente verwenden (vervollständigen).    
-}

{- TEILAUFGABE (a)
    Vervollständigen Sie den untenstehenden Datentyp (mit mehreren Fällen) so,
    dass die logischen Operatoren 'And', 'Or' und 'Not' ausgedrückt werden
    können.
-}
data FuzzyFormula
    = Simple Float 
    | FAnd FuzzyFormula FuzzyFormula
    | FOr FuzzyFormula FuzzyFormula
    | FNot FuzzyFormula        
    deriving Show  


{- TEILAUFGABE (b)
    Vervollständigen Sie den untenstehenden Code so, dass beliebige Terme vom
    Typ 'FuzzyFormula' ausgewertet werden können (vgl. Signatur).
-}
eval :: FuzzyFormula -> FuzzyBool
eval f = case f of
    Simple v -> FuzzyBool v
    FAnd f1 f2 -> FuzzyBool $ 
        min (value (eval f1)) (value (eval f2))
    FOr f1 f2 -> FuzzyBool $
        max (value (eval f1)) (value (eval f2))
    FNot f1 -> FuzzyBool $
        1 - (value (eval f1))
    
    

{- TEILAUFGABE (c)
    Deklarieren Sie den Term fDeep so, dass dieser inhaltlich dem Ausdruck
    'fShallow' entspricht.
-}
fDeep :: FuzzyFormula
fDeep = FAnd
    ( FOr
        (Simple 0.5)
        (Simple 0.3)
    )
    ( FNot
        (Simple 0.1)
    )