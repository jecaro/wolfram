import Control.Concurrent (threadDelay)
import Data.Foldable (sequenceA_)
import Data.List (intersperse)
import qualified Options as O (Options (..), fromStrings, render, usage)
import System.Environment (getArgs, getProgName)
import qualified Wolfram as W (next, toPattern, toString)
import Prelude hiding (lines)

main :: IO ()
main = do
    withError . (fmap runInIO . O.fromStrings) =<< getArgs
  where
    runInIO options =
        sequenceA_ . withDelay (O.optDelay options) . output $ run options
    withDelay ms = intersperse (threadDelay (ms * 1000))
    output = fmap putStrLn
    withError (Left err) = do
        putStrLn $ O.render err
        putStrLn . O.usage =<< getProgName
    withError (Right a) = a

run :: O.Options -> [String]
run
    O.MkOptions
        { O.optRule = rule
        , O.optStart = start
        , O.optLines = lines
        , O.optWindow = window
        , O.optMove = move
        } = W.toString . center <$> zip uncenteredLines [start ..]
      where
        uncenteredLines = vert generations
        generations = iterate (W.next (W.toPattern rule)) [True]
        center = right . uncurry (flip left)
        right = take window
        left i
            | offset > 0 = (replicate offset False <>)
            | otherwise = drop (negate offset)
          where
            offset = (window `div` 2) - i + move
        vert = bottom . top
        top = drop start
        bottom = maybe id take lines
