
-------------------------------------------------------------------------------
-- Functor
-------------------------------------------------------------------------------

predec :: Int -> Maybe Int
predec x
    | x < 1    = Nothing
    | otherwise = Just $ x - 1

divS :: Int -> Int -> Maybe Int
divS x y | y == 0    = Nothing
         | otherwise = Just $ x `div` y

f :: Int -> Int
f x = 2 * x

g :: Int -> Maybe Int
g x = f <$> predec x

-------------------------------------------------------------------------------
-- Applicative
-------------------------------------------------------------------------------

-- Simple examples

-- Exercise:
-- Define h x y = (x-1) * (y-1) with the help of <$> and <*>
h :: Int -> Int -> Maybe Int
h x y = (*) <$> predec x <*> predec y

addThree :: Int -> Int -> Int -> Int
addThree x y z = x + y + z

-- Exercise:
-- Define d x y z = (x-1) + (y-1) + (z-1) with the help of <$> and <*>
d :: Int -> Int -> Int -> Maybe Int
d x y z = addThree <$> predec x <*> predec y <*> predec z


-- User lookup

data User = User
    { uName  :: String
    , uEmail :: String
    , uCity  :: String
    } deriving Show

type Profile = [(String, String)]

petersProfile :: Profile
petersProfile =
    [ ("name", "peter")
    , ("email", "peter@peter.com")
    , ("city", "zueri")
    ]

incompleteProfile :: Profile
incompleteProfile =
    [ ("name", "Hans")
    , ("emaill", "hans@abc.com")
    , ("city", "zueri")
    ]

myLookup :: String -> Profile -> Maybe String
myLookup str [] = Nothing
myLookup str ((key, value):assocs)
    | str == key = Just value
    | otherwise = myLookup str assocs

-- Exercise:
-- A simple function to build a user from a profile. All the functionality is
-- implemented by "hand"
buildUser :: Profile -> Maybe User
buildUser profile =
    case myLookup "name" profile of
        Nothing -> Nothing
        Just name -> case myLookup "email" profile of
            Nothing -> Nothing
            Just email -> case myLookup "city" profile of
                Nothing -> Nothing
                Just city -> Just $ User name email city

peter :: Maybe User
peter = buildUser petersProfile

-- Exercise:
-- Now use the fact that Maybe is an applicative (i.e., use <$> and <*>) to
-- refactor the 'buildUser' function.
buildUserAp :: Profile -> Maybe User
buildUserAp profile = User
    <$> myLookup "name" profile
    <*> myLookup "email" profile
    <*> myLookup "city" profile

-------------------------------------------------------------------------------
-- Monad
-------------------------------------------------------------------------------
type CityBase = [(String, String)]

-- Exercise:
-- A simple function to build a user from a profile and a cities database.
-- All the functionality is implemented "by hand"
buildUserWithCities :: Profile -> CityBase -> Maybe User
buildUserWithCities profile cities =
    case myLookup "name" profile of
        Nothing -> Nothing
        Just name -> case myLookup "email" profile of
            Nothing -> Nothing
            Just email -> case myLookup email cities of
                Nothing -> Nothing
                Just city -> Just $ User name email city

-- Exercise:
-- Now use the fact that Maybe is a monad (i.e., use >>= ) to
-- refactor the 'buildUserWithCities' function.
buildUserWithCitiesM :: Profile -> CityBase -> Maybe User
buildUserWithCitiesM profile cities =
    myLookup "name" profile
        >>= \name -> myLookup "email" profile
            >>= \email -> myLookup email cities
                >>= \city -> pure $ User name email city

-- Exercise:
-- Now use the 'do notation' to refactor the
-- 'buildUserWithCities' function.
buildUserWithCitiesDo :: Profile -> CityBase -> Maybe User
buildUserWithCitiesDo profile cities = do
    name <- myLookup "name" profile
    email <- myLookup "email" profile
    city <- myLookup email cities
    return $ User name email city

-- Test your functions with Anna's profile and the given cities database
annasProfile :: Profile
annasProfile =
    [ ("name", "Anna")
    , ("email", "anna@nasa.gov")
    ]

citiesBase :: CityBase
citiesBase =
    [ ("anna@nasa.gov", "Washington")
    , ("sam@spacelab.io", "Winterthur")
    ]


