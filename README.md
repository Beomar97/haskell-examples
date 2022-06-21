# Funktionale Programmierung

## Einleitung

**Das Imperative Modell** basiert auf Zuständen, Zustandsübergängen und deren zeitlichen Abfolge (Schritt-für-Schritt).

```c
sum(L) {
	l = length(L)
	i=0 acc = 0
	while (i < l) {
		acc = acc + L[i]
		i=i+1
  }
	return acc
}
```

**Das Funktionale Modell** ist nahe ander mathematischen Notation (Funktionen sind mathematische Objekte). Definition einer Funktion anstelle expliziter Anweisungen.

```haskell
sum [] = 0
sum (a1:rest) = a1 + sum rest
```

**Pragmatische Interpretation** für die funktionale Programmierung:

- Vollwertige Unterstützung von Funktionen (1st Class Functions)
  - Funktionen höherer Ordnung, Lambda-Terme, Currying, Partielle Anwendung, ...
- Immutable Data
  - Referenzielle Transparenz, Type Safety, ...
- Hoch entwickeltes Typensystem
  - Algebraische Datentypen, Pattern Matching, Typinferenz, ...
- Rekursion
  - Tail-Call-optimization

**Anwendungen:** Compilerbau, Theorembeweiser, KI, Numerik, Data Science, FIntech, Sonstiges bis hin zu GUI Programmierung

## Funktionen und Typen I

Variablen haben in der funktionalen Programmierung **fundamental** eine andere Bedeutung als in der imperativen Programmierung.

`x = 3`

**Funktional:** `x` benennt unabhängig von der Zeit den **Wert** `3`

**Imperativ:** `x` benennt einen **Ort**. Sein Wert ändert sich mit der Zeit.

Wert-Variable-Relation ist im funktionalen Paradigma **zeitunabhängig**. Entsprechen daher eher Konstanten als Variablen (**immutability**).

**Nebeneffekte** werden möglichst **vermieden** oder mindestens **isoliert**. *Interne* Nebeneffekte ändern den Zustand des Programms und kommen in rein funktionalen Sprachen nicht vor. *Externe* Nebeneffekte verändern den Zustand des Kontextes (Aussenwelt) und werden vom Rest des Programms isoliert => **Referenzielle Transparenz**.

Vorteile der referenziellen Transparenz: Lazy evaluation, simplere Programmverifikation, erleichterte Beweisführung, equational reasoning.

**Typen** ≃ Mengen, anstelle $x \in t$ schreibt man `x :: t` in Haskell. **Grundtypen** in Haskell sind `Bool` True oder False, `Char` 'a', `String` "abc" und `Integer` 12 ($-2^{31} \leq x < 2^{31}$). Typ `a` gibt es einen Typ `[a]` für Listen.

**Funktionstyp** `a -> b` akzeptiert Eingabe vom Typ `a` und gibt eine Ausgabe vom Typ `b` zurück.

**Tupel** mit Typ `(a, b, c)` bzw. `(Int, String, Char)` beinhaltet z.B das Tripel `(1, "1", '1')`.

**Records** sind Tupel, in denen Einträge Labels tragen:

```haskell
data Customer = Customer
	{	customerId :: Integer
	,	name :: String
	}
```

**Summentyp** entspricht der Vereinigung von disjunkten Mengen:

```haskell
data Shape
	= Rectangle Float Float
	| Square Float
	| Circle Float
	
-- Können auch rekursiv sein
data Tree a
	= Node (Tree a) a (Tree a)
	| Leaf a
	
-- Listen sind als Summentyp definiert
data List a
	= Cons a (List a)
	| Nil
```

In **Typklassen** werden verschiedene Typen, die bestimmte Eigenschaften teilen zusammengefasst. Z.b enthält die Typklasse `Eq` alle Typen deren Elemente vergleichbar sind => `(==) :: Eq a => a -> a -> Bool`

## Funktionen und Typen II

Funktionen sind Werte von einem Gestalt `a -> b` und entpricht der Menge $\{f | f : \text{Typ}_1 \rightarrow \text{Typ}_2\}$. `f : a -> b` => f ist eine Funktion von `a` nach `b`.

**Pfeile** sind rechtsassoziativ zu lesen: Typ `a -> b -> c -> d` is als `a -> (b -> (c -> d))` zu interpretieren.

Aus einer Funktionsdefinition lässt sich der Typ oft ableiten (**Type Inference**).

Bestimmung des Typs einer Funktion von Hand:

```haskell
a b c d e = c (b d) (b e)
-- 1. d un e haben irgendwelche Typen d :: D und e :: E
-- 2. b wird auf d UND e angewendet, d.h. E = D und b :: D -> B
-- 3. c wird auf zwei Argumente vom Typ B angewendet: c :: B -> B -> C
a :: (D -> B) -> (B -> B -> C) -> D -> D -> C
```

**Mehrstellige Funktionen** sind Funktionen deren Eingabe aus mehreren Argumenten bestehen.

**Zwei Sichtweisen** auf mehrstellige Funktionen:

1. Eine *n*-stellige Funktion, die *n*-Tupel als Eingabewerte akzeptiert:

   `(a1, ..., an) -> b`

   ```haskell
   max1 :: (Int, Int) -> Int
   max1 (x, y) = if x > y then x else y
   ```

2. Eine *n*-stellige Funktion, die *n - 1*-stellige Funktionen zurückgibt:

   `a1 -> a2 -> ... -> an`

   ```haskell
   max2 :: Int -> Int -> Int
   max2 x y = if x > y then x else y
   ```

**Currying** bzw. Uncurrying ist das Übersetzen zischen den beiden genannten Ansätzen:

```haskell
curry f a1 .. an = f (a1, .., an)
uncurry f (a1, .., an) = f a1 .. an
```

**Partielle Anwendung** bedeutet eine *curried* Funktion nicht erschöpfend mit Argumenten zu versehen:

```haskell
plus4 :: Num a => a -> a
plus4 = (+) 4
```

**Funktionen höherer Ordnung** sind Funktionen die andere Funktionen als Argumente erhält oder andere Funktionen als Ergebnis liefern. Bieten die Möglichkeit via **Komposition** und **partieller Anwendung** weitere Funktionen *zusammenzubauen* und konstituieren ein Mittel zur Abstraktion.

Eine **partielle Funktion** gibt eventuell für gewisse Eingaben keinen Funktionswert zurück und sind in der Mathematik und insbesondere in der Informatik häufig. Beispiel $f(x,y)=\frac{x}{y}$.

Der `Maybe` Typ von Haskell ist ein einfacher Summentyp und stellt damit einen Typ zur Modellierung von optionalen/partiellen Rückgabewerten bereit.

```haskell
data Maybe a = Just a | Nothing
```

Partielle Funktionen können damit explizit modelliert werden:

```haskell
f :: Fractional a => a -> a -> Maybe a
f x y = case y of
	0 -> Nothing
	_ -> Just (x / y)
```

Der `Either` Typ kann verwendet werden, um mehr Informationen zu übergeben, wieso eine Funktion an einer bestimmten Stelle keinen Rückgabewert liefert (z.B Error Handling). Oder alternativ ein massgeschneideter Datentyp implementieren:

```haskell
data Either a b
	= Left a
	| Right b

data Result a b c
	= Success a
	| XError b
	| YError c
```

## Rekursion

Rekurisve Definitionen zeichnen sich durch die **Bezugnahme** auf das zu **definierende Objekt** *in einer einfacheren Form* aus.
$$
2^0 = 1 \\
\underbrace{2^{n+1}}_\text{definiere} = 2 \cdot \underbrace{2^n}_\text{Selbstbezug}
$$
 Ist ein Algorithmus der aus bereits vorhandenen Funktionswerten weitere Funktionswerte generiert. Wesentliche Zutaten eienr rekursiven Definition sind **bekannte Funktionswerte** und **Funktion G zum Erweitern der Menge bekannter Werte**:

| Formel                  | Info                                                       | Beschreibung                                                 |
| ----------------------- | ---------------------------------------------------------- | ------------------------------------------------------------ |
| $2^0 = 1$               | Bekannter Wert                                             | Funktionswert an Stelle 0 ist bekannt.                       |
| $2^{n+1} = 2 \cdot 2^n$ | $\underbrace{G(x) = 2 \cdot x}_\text{body des rek. Calls}$ | Durch Verdoppeln eines bekannten Funktionswertes erhält man den nächsten Funktionswert. |

Arten von Rekursionsgleichungen werden als *Rekursionsschemas* bezeichnet.

**Primitive Rekursion:**
$$
f(0, \overrightarrow{x}) = c(\overrightarrow{x}) \\
f(n+1, \overrightarrow{x}) = G(f(n,\overrightarrow{x}),n,\overrightarrow{x})
$$
Beispiel allgemeine Exponentialfunktion:

| Funktion                | Schema               |
| ----------------------- | -------------------- |
| $x^0 = 1$               | $c(x) = 1$           |
| $x^{n+1} = x \cdot x^n$ | $G(a,x) = x \cdot a$ |

Beispiel Fakultätsfunktion:

| Funktion                | Schema                   |
| ----------------------- | ------------------------ |
| $0! = 1$                | $c=1$                    |
| $n+1! = (n+1) \cdot n!$ | $G(a,n) = (n+1) \cdot a$ |

**Wertverlaufrekursion:**

Definition nimmt auf mehrere Vorgänger Bezug.
$$
f(n) = G(f \uparrow n) \\
f(n, \overrightarrow{x}) = G(f \uparrow n, n, \overrightarrow{x})
$$
Beispiel Fibonacci:

$fib(0) = 0$

$fib(1) = 1$

$fib(n) = fib(n-1) + fib(n-2)$

**Allgemeine Rekursion:**

Rekursion kann grundsätzlich entlang jeder Relation angewendet werden. Die zu definierende Definition ist möglicherweise nicht immer wohldefiniert.

Beispiel Collatz Funktion $col(x)$:

$\frac{x}{2}$ : falls $x$ gerade

$3x + 1$ : sonst

Die Funktion $x \rightarrow C_x$ ist eine rekursiv definierbare Funktion, von der nicht bekannt ist, ob sie zu jedem Input ein Output generiert.

### Endrekursion

In der funktionalen Programmierung werden viele, in anderen Paradigmen typischerweise iterativ formulierte, Algorithmen rekursiv ausgedrückt. Rekursion soll effizient übersetzt werden. Wichtig ist dabei insbesondere, nicht für jeden rekursiven Funktionsaufruf den Aufrufstapel zu vergrössern. Dadurch können Stapelüberläufe auch bei tiefer Rekursion verhindert werden. Die “tail-call” Optimierung behandelt genau diesen Fall.

Deklaration liegt in endrekursiver Form oder *tail-recursive* vor, wenn Resultate von rekursiven Aufrufen direkt zurückgegeben werden.

```haskell
sum_ :: [Integer] -> Integer -- nicht endrekursiv
sum_ [] = 0
sum_ (x:xs) = x + (sum_ xs)

sumTR_ :: Integer -> [Integer] -> Integer
sumTR_ acc [] = acc
sumTR_ acc (x:xs) = sumTR_ (x + acc) xs
```

**Akkumulator Pattern** um eine rekursive Funktion in eine endrekursive Form zu bringen. Zwischenresultat explizit in einem Akkumulator mitführen.

```haskell
-- Beispiel Fakultätsfunktion mit einem Akkumulator
fakTR :: Integer -> Integer
fakTR = fakTR_ 1
	where
		fakTR_ :: Integer -> Integer -> Integer
		fakTR_ acc 0 = acc
		fakTR_ acc n = fakTR_ (n * acc) (n-1)
```

**Continuation Pattern** führt einen Funktionsparameter mit, der die noch leistende Arbeit darstellt. Ein Akkumulator repräsentiert dagegen bereits geleistete Arbeit.

```haskell
-- Fakultätsfunktion mit dem Continuation Pattern
fakC :: Integer -> Integer
fakC = fakC_ (const 1)
	where
		fakC_ f n
		|n<1=fn
		| otherwise = fakC_ (\x -> n * (f x)) $ n-1
```

### Fixpunkte

Fixpunkte bieten einen konstruktiven Zugang zu rekursiv definierten Funktionen. Sie formalisieren die Idee des “Aufbauens einer rekursiven Struktur von Unten”.

Als Fixpunkte einer Funktion $F: X \rightarrow Y$werden Elemente $x \in X \cap Y$ mit $F(x) = x$ bezeichnet. Unter geeigneten Umständen lassen sich Definitionen als Fixpunktlgeichungen darstellen.

Betrachten nun **Fixpunkte höherer Ordnung**. Beispiel Exponentialfunktion:

$\text{expF}(f) = x \rightarrow$

$1$  :  falls $x = 0$

$2 \cdot f(x-1)$  :  sonst

```haskell
expF f x
	| x == 0 = 1
	| otherwise = 2 * f (x - 1)
```

 Vergleich mit normalen rekursiven Funktion:

```haskell
 exp x
	| x == 0 = 1
	| otherwise = 2 * exp (x - 1)
```

Konkret besteht der einzige Unterschied darin, dass in expF der Parameter f anstelle eines rekursiven Aufrufes steht.

Wir können in Haskell direkt eine Funktion fix zum finden von Fixpunkten definieren:

```haskell
fix f = f $ fix f
```

## Functor, Applicative und Monad

Die **Functor** Typklasse und die zur Functor Klasse gehörenden Regeln:

```haskell
class Functor f where
	fmap :: (a -> b) -> f a -> f b
	
-- Infix Variante von fmap
(<$>) = fmap
	
-- Identität
fmap id = id
id <$> x = x

-- Komposition
fmap (f . g) = (fmap f) . (fmap g)
(f . g) <$> x = f <$> (g <$> x)
```

Eine Funktion, die den *Vorgänger* einer natürlichen Zahl berechnet:

```haskell
predec :: Int -> Maybe Int
predec x
	| x <= 1 = Nothing
	| otherwise = Just $ x - 1
```

Weil `Maybe` ein Functor ist, kann diese Funktion bequem mit anderen Funktionen kombiniert werden, die eigentlich einen `Int` statt einen `Maybe Int` konsumieren.

Jedoch ist dies nicht im Kontext einer zweistelligen Funktion möglich:

```haskell
h x y= (*) <$> (predecx) (predecy)
-- Nicht möglich da
(*) <$> (predec x) :: Maybe (Int -> Int)
predec y :: Maybe Int
-- Eine Funktion von folgendem Typ wird benötigt
(<*>) :: Maybe (Int -> Int) -> Maybe Int -> Maybe Int
```

Die **Applicative Functor** Klasse und die Applicative Instanz von `Maybe` bietet genau dies:

```haskell
-- Applicative Functor Klasse
class (Functor f) => Applicative f where
	pure :: a -> f a
	(<*>) :: f (a -> b) -> f a -> f b
	
-- Aplicative Instanz von Maybe
pure = Just
Just f <*> x = f <$> x
Nothing <*> _ = Nothing
```

Die Applicative Klasse hat folgende Regeln:

```haskell
-- Identität
pure id <*> vv = vv

-- Komposition
pure (.) <*> f <*> g <*> x = f <*> (g <*> x)

-- Homomorphismus
pure f <*> pure v = pure (f v)

-- Interchange
f <*> pure x = pure ($ x) <*> f
```

Beispiel Funktion `buildUser :: Profile -> Maybe User`

```haskell
-- Daten
data User = User
	{ uName :: String
	, uEmail :: String
	, uCity :: String
	}
type Profile = [(String , String)]
petersProfile :: Profile
petersProfile =
	[ ("name", "peter")
	, ("email", "peter@peter.com")
	, ("city", "zueri")
	]

-- Lookup Funktion
myLookup :: String -> Profile -> Maybe String
myLookup str [] = Nothing
myLookup str ((key, value):assocs)
	| str == key = Just value
	| otherwise = myLookup str assocs

-- buildUser ohne Applicative Instanz von Maybe
buildUser :: Profile -> Maybe User
buildUser prof = case myLookup "name" prof of
	Nothing -> Nothing
	Just name -> case myLookup "email" prof of
		Nothing -> Nothing
		Just email -> case myLookup "city" prof of
			Nothing -> Nothing
			Just city -> Just $ User name email city
			
-- buildUser mithilfe von (<$>) und (<*>)
buildUser profile = User
	<$> myLookup "name" profile
	<*> myLookup "email" profile
	<*> myLookup "city" profile
```

Erweiterung der Funktion; City eines Benutzers wird neu in einer separaten Liste mit der Email zugeordnet. Email Daten müssen verwendet werden und müssen daher bereits vorhanden sein. Daten können nicht unabhängig voneinander hergestellt werden, Lösung nur mit einem Applicative ist nicht mehr möglich.

Weil wir die Email Daten brauchen um auf die City Daten zugreifen zu können, benötigen wir eine Funktion, die folgende Signatur hat:

```haskell
 bind :: Maybe String -> (String -> Maybe String) -> Maybe String
```

Weil wir damit Funktionen vom Typ `String -> Maybe String` hintereinander ausführen können.

Die **Monad** Klasse bietet das passende Interface:

```haskell
class (Applicative m) => Monad m where
	(>>=) :: m a -> (a -> m b) -> m b
```

Regeln der Monad Klasse:

```haskell
-- Left Identity
pure a >>= f = f a

-- Right Identity
m >>= pure = m

-- Assozitivität
(m >>= f) >>= g = m >>= (\x -> f x >>= g)
```

Beispiel Funktion `buildUser :: Profile -> Maybe User`

```haskell
-- Neue Typen
type CityBase = [(String , String)]
annasProfile :: Profile
annasProfile =
	[ ("name", "Anna")
	, ("email", "anna@nasa.gov")
	]
citiesB :: CityBase
citiesB =
	[ ("anna@nasa.gov", "Washington")
	, ("peter@peter.com", "Zueri")
	]
	
-- Von Hand
buildUserC :: Profile -> CityBase -> Maybe User
buildUserC p cities = case myLookup "name" p of
	Nothing -> Nothing
	Just name -> case myLookup "email" p of
		Nothing -> Nothing
		Just email -> case myLookup email cities of
			Nothing -> Nothing
			Just city -> Just $
				User name email city
				
-- Mit Monad
buildUserB :: Profile -> CityBase -> Maybe User
buildUserB profile cities =
	myLookup "name" profile
		>>= \n -> myLookup "email" profile
		>>= \e -> myLookup e cities
		>>= \c -> pure $ User n e c
		
-- Mit do Notation
buildUserCM :: Profile -> CityBase -> Maybe User
buildUserCM profile cities = do
	name <- myLookup "name" profile
	email <- myLookup "email" profile
	city <- myLookup email cities
	pure $ User name email city
```

## Kombinatorenbibliotheken und EDSL

Domänenspezifische Sprachen (**Domain Specific Languages DSLs**) verstehen und verarbeiten Sprache und Begriffe in der Industrie. Deren Keywords sollen möglichst direkt Industriespezifische Begriffe und Konstrukte wiederspiegeln und interpretieren.

DSLs sind eigenständige formale Sprachen udn haben auch einen eigenen Interpreter / Compiler, Parser und mehr. **EDSLs** sind in einer bestehenden Sprache eingebettet. Terme der EDSL sind auch Terme der Host Language (Echte Teilmenge).

Haskell bietet eine geeignete Umgebung zum Implementieren von EDSLs. Als Beispiel wird eine einfache EDSL für 2D-Grafiken in Haskell implementiert:

```haskell
-- Basic Shapes
empty :: Shape
unitDisc :: Shape
unitSq :: Shape

-- Modifikatoren
translate :: Vector -> Shape -> Shape
stretchX :: Float -> Shape -> Shape
stretchY :: Float -> Shape -> Shape
stretch :: Float -> Shape -> Shape
flipX :: Shape -> Shape
flipY :: Shape -> Shape
flip45 :: Shape -> Shape
flip0 :: Shape -> Shape
rotate :: Float -> Shape -> Shape

-- Kombinatoren
intersect :: Shape -> Shape -> Shape
merge :: Shape -> Shape -> Shape
minus :: Shape -> Shape -> Shape

-- Syntax (AST) der EDSL sind nun beschrieben
-- Formen können nun direkt beschrieben werden
iShape = merge
	(stretchY 2 unitSq)
	(translate (0, 4) unitDisc)
	
-- Semantik für die EDSL angeben.
-- Formen in unserer Sprache beschreiben und als Bild wiedergeben
type Point = (Float , Float)
newtype Shape = Shape { inside :: Point -> Bool }
-- Interpretieren Shape als Menge von Pixeln in der Ebene
```

**Shallow Embedding** ist zum Beispiel diese *Shape* EDSL. Grundformen plus Funktionen, die Formen verändern und kombinieren.

**Deep Embedding** entpricht die EDSL einem Datentyp in Haskell:

```haskell
data Shape
	= Empty
	| UnitDisk
	| UnitSq
	| Translate Vector Shape
	| ...
```

Syntax und Sematnik sind klarer getrennt in einem Deep Embedding. Interessante EDSLs bestehen meist aus einer Mischung dieser beiden Ansätze.

Beispiel einer extrem einfachen EDSL für arithmetische Ausdrücke:

```haskell
data Exp
	= Const Int
	| Add Exp Exp
	| Mul Exp Exp
	| Div Exp Exp
	
-- Interpretation
sEval :: Exp -> Int sEval e = case e of
	Const x -> x
	Add e1 e2 -> sEval e1 + sEval e2
	Mul e1 e2 -> sEval e1 * sEval e2
	Div e1 e2 -> sEval e1 `div` sEval e2
```

