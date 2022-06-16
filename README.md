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

