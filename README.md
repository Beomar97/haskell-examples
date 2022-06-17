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

