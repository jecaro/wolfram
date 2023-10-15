module Options (Options (..), Error (..), fromStrings, render, usage) where

import Data.Bifunctor (Bifunctor (second))
import Text.Read (readMaybe)
import Prelude hiding (lines)

data Options = MkOptions
    { optRule :: Int
    , optStart :: Int
    , optLines :: Maybe Int
    , optWindow :: Int
    , optMove :: Int
    , optDelay :: Int
    }
    deriving (Eq, Show)

data Error = MustBeInt String | UnknownArg String | MissingRule
    deriving (Eq, Show)

fromStrings :: [String] -> Either Error Options
fromStrings args = do
    (rule, args') <- getRule args
    go args' $ def rule
  where
    go (arg@"--start" : str : xs) o = go xs . setStart o =<< toInt str arg
    go (arg@"--lines" : str : xs) o = go xs . setLinesAndDelay o . Just =<< toInt str arg
    go (arg@"--window" : str : xs) o = go xs . setWindow o =<< toInt str arg
    go (arg@"--move" : str : xs) o = go xs . setMove o =<< toInt str arg
    go (arg@"--delay" : str : xs) o = go xs . setDelay o =<< toInt str arg
    go (arg : _) _ = Left $ UnknownArg arg
    go [] o = pure o

    setStart o x = o{optStart = x}
    setLinesAndDelay o x = o{optLines = x, optDelay = 0}
    setWindow o x = o{optWindow = x}
    setMove o x = o{optMove = x}
    setDelay o x = o{optDelay = x}

    toInt str arg
        | Just i <- readMaybe str = pure i
        | otherwise = Left $ MustBeInt arg

    def rule =
        MkOptions
            { optRule = rule
            , optStart = 0
            , optLines = Nothing
            , optWindow = 80
            , optMove = 0
            , optDelay = 100
            }

render :: Error -> String
render (MustBeInt str) = str <> " argument must be an int"
render (UnknownArg str) = "Unknown argument " <> str
render MissingRule = "You must define a rule"

usage :: String -> String
usage progName =
    unlines
        [ progName <> " --rule <RULE> [OPTIONS]"
        , "Options:"
        , "--rule   <RULE>   the rule to run"
        , "--start  <START>  starting line (default 0)"
        , "--lines  <LINES>  number of lines to output, 0 to never stop (default 0)"
        , "--window <WINDOW> width of the window (default 80)"
        , "--move   <MOVE>   offset to apply to the window (default 0)"
        , "--delay  <DELAY>  delay between each line in ms (default 100)"
        ]

getRule :: [String] -> Either Error (Int, [String])
getRule (arg@"--rule" : ruleStr : xs) = withError ((,xs) <$> readMaybe ruleStr)
  where
    withError Nothing = Left $ MustBeInt arg
    withError (Just r) = Right r
getRule (x : xs) = second (x :) <$> getRule xs
getRule [] = Left MissingRule
