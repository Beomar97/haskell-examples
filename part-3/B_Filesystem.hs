
{-
 Gegeben ist ein einfacher Datentyp für Verzeichnisstrukturen (Ordnerbäume).
 Eine Verzeichnisstruktur besteht in diesem Modell entweder aus einem
 enzelnen File (durch seinen Namen und Grösse gegeben), oder durch eine Liste
 von Unterverzeichnissen.
-}
type Name = String
type FileSizeKB = Int

data FileSystem
    = File Name FileSizeKB
    | Dir Name [FileSystem]
    deriving Show

example :: FileSystem
example = Dir "root"
    [ Dir "desktop"
        [ File "notes.txt" 87
        , File "brochure.pdf" 581
        ]
    , Dir "pictures"
        [ Dir "holiday2019"
            [ File "paris1.png" 2075
            , File "paris2.png" 3017
            ]
        , Dir "holiday2018"
            [ File "rome1.jpg" 2075
            , File "rome2.jpg" 4584
            , File "rome3.png" 2075
            , File "notes.txt" 112
            ]
        ]
    ]


{- Aufgabe:
    implementieren Sie eine "allgemeine fold Funktion" wie in der Vorlesung
    besprochen.
-}
filesystem :: (Name -> FileSizeKB -> b) -> (Name -> [b] -> b) -> FileSystem -> b
filesystem file directory fs = case fs of -- sample solution
    File name size -> file name size
    Dir name subdirectories -> directory name $ map (filesystem file directory) subdirectories

filesystem' file dir fs = case fs of -- discussion solution
    File name size -> file name size
    Dir name subs -> dir name (map recursion subs)
        where
            recursion = filesystem file dir

{-
    Ausgehend von der Funktion 'filesystem' wollen wir nun konkrete Funktionen
    implementieren, die uns im Umgang mit dem 'FileSystem' Typ nützlich
    erscheinen.
-}

{- Grösse eines Verzeichnisses
    Implementieren Sie die Funktion 'size', die die grösse einer gegebenen
    Verzeichnisstruktur zurück gibt. Verwenden Sie die Funktion 'filesystem'.
-}
size :: FileSystem -> Int
size = filesystem (\_ filesize -> filesize) (\_ sizes -> sum sizes)

{- Datei abfragen
    Implementieren Sie die Funktion 'existsFile', die bei einer gegebenen
    Verzeichnisstruktur zurück gibt, ob darin eine Datei mit dem mitgegebenen
    Namen zu finden ist. Verwenden Sie die Funktion 'filesystem'.
-}
existsFile :: Name -> FileSystem -> Bool
existsFile name = filesystem file dir -- sample solution
    where
        file n _ = n == name
        dir _ = or

existsFile' name = filesystem -- discussion solution
    (\filename _ -> filename == name)
    (\_ answers -> or answers)

{- Pfade
     Ein Pfad ist eine Liste von Namen.
     Beispiel: "/pictures/holiday2019/paris1.png" wäre
                ["pictures", "holiday2019", "paris1.png"]
-}
type Path = [Name]

{- Alle Pfade finden
    Implementieren Sie die Funktion 'findAll' mit folgendem Verhalten:
    Input: Dateiname, Verzeichnisstruktur
    Rückgabe: Alle Pfade in der gegebenen Struktur, die auf eine Datei mit dem
              gegebenen Namen zeigen.
    Verwenden Sie auch hier die Funktion 'filesystem'.
-}
findAll :: Name -> FileSystem -> [Path]
findAll name = filesystem file dir
    where
        file :: Name -> Int -> [Path]
        file n _ | n == name = [[n]]
                 | otherwise = []
        dir :: Name -> [[Path]] -> [Path]
        dir n subs = map ((:) n) $ concat subs

