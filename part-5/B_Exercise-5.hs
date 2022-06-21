import Data.Functor.Contravariant

------------------------------------------------------------
-- Aufgabe 1
------------------------------------------------------------

-- Gegeben ist folgender Datentyp und Funktor Instanz:
newtype Boxed a = Boxed {unbox :: a}

instance Functor Boxed where
    fmap f (Boxed x) = Boxed $ f x

-- Beweisen Sie im Detail (die “Functor Laws”):
{-
Functor law 1:
fmap id b = b
fmap (f . g) b = fmap f $ fmap g b

id <$> Boxed x = Boxed (id x) = Boxed x

Functor law 2:
id <$> b = b
(f . g) <$> b = f <$> (g <$> b)

(f . g) <$> Boxed x = Boxed $ (f . g) x
                    = Boxed $ (f (g x))
                    = f <$> (Boxed (g x))
                    = f <$> (g <$> Boxed x)
-}

------------------------------------------------------------
-- Aufgabe 2
------------------------------------------------------------

-- Gegeben ist der Datentyp:
newtype FromInt a = FromInt {fun :: Int -> a}

-- a) Schreiben Sie eine Funktor Instanz für FromInt:
instance Functor FromInt where
    fmap f fi = FromInt $ f . (fun fi)

-- b) Beweisen Sie die Funktor Regeln:
{-
Functor law 1:
id <$> FromInt f = FromInt (id . f)
                 = FromInt f

Functor law 2:
consider:
left side =
    (f . g) <$> fi = FromInt $ (f . g) . (fun fi)
                   = FromInt $ f . (g . (fun fi))
                   = FromInt $ f . (g . (fun fi))

right side =
    f <$> (g <$> fi) = f <$> (FromInt (g . (fun fi)))
                     = FromInt $ f . (fun (FromInt (g. (fun fi))))
                     = FromInt $ f . (g . (fun fi))

thus, q.e.d
-}

------------------------------------------------------------
-- Aufgabe 3
------------------------------------------------------------

-- Die Klasse Contravariant ist fast gleich wie die Klasse Functor definiert,
-- nur etwas “verdreht”. Anstelle der Funktion 
fmap :: (a -> b) -> f a -> f b
-- muss man eine Funktion
contramap :: (b -> a) -> f a -> f b
-- implementieren. Definieren Sie einen Datentyp und eine dazu passende Instanz für Contravariant:
newtype MyPredicate a = MyPredicate (a -> Bool)
instance Contravariant MyPredicate where
    contramap f (MyPredicate g) = MyPredicate $ g . f