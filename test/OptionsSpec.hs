module OptionsSpec (spec) where

import Options (Error (..), Options (..), fromStrings)
import Test.Hspec (Spec, it, shouldBe)

spec :: Spec
spec = do
    it "fails on empty args list" $ do
        fromStrings [] `shouldBe` Left MissingRule
    it "fails when not an int --rule" $ do
        fromStrings ["--rule", "abc"] `shouldBe` Left (MustBeInt "--rule")
    it "fails when no rule" $ do
        fromStrings
            [ "--start"
            , "1"
            , "--lines"
            , "1"
            , "--window"
            , "1"
            , "--move"
            , "1"
            ]
            `shouldBe` Left MissingRule

    it "fails when not an int --start" $ do
        fromStrings ["--rule", "1", "--start", "abc"]
            `shouldBe` Left (MustBeInt "--start")
    it "fails when not an int --lines" $ do
        fromStrings ["--rule", "1", "--lines", "abc"]
            `shouldBe` Left (MustBeInt "--lines")
    it "fails when not an int --window" $ do
        fromStrings ["--rule", "1", "--window", "abc"]
            `shouldBe` Left (MustBeInt "--window")
    it "fails when not an int --move" $ do
        fromStrings ["--rule", "1", "--move", "abc"]
            `shouldBe` Left (MustBeInt "--move")
    it "fails with an unknown arg" $ do
        fromStrings
            [ "--rule"
            , "1"
            , "--start"
            , "2"
            , "--what"
            , "3"
            , "--window"
            , "4"
            , "--move"
            , "5"
            , "--delay"
            , "6"
            ]
            `shouldBe` Left (UnknownArg "--what")
    it "succeed with a rule in the front" $ do
        fromStrings
            [ "--rule"
            , "1"
            , "--start"
            , "2"
            , "--lines"
            , "3"
            , "--window"
            , "4"
            , "--move"
            , "5"
            , "--delay"
            , "6"
            ]
            `shouldBe` Right
                ( MkOptions
                    { optRule = 1
                    , optStart = 2
                    , optLines = Just 3
                    , optWindow = 4
                    , optMove = 5
                    , optDelay = 6
                    }
                )

    it "succeed with a rule in the back" $ do
        fromStrings
            [ "--start"
            , "2"
            , "--lines"
            , "3"
            , "--window"
            , "4"
            , "--move"
            , "5"
            , "--delay"
            , "6"
            , "--rule"
            , "1"
            ]
            `shouldBe` Right
                ( MkOptions
                    { optRule = 1
                    , optStart = 2
                    , optLines = Just 3
                    , optWindow = 4
                    , optMove = 5
                    , optDelay = 6
                    }
                )
    it "succeed with a rule in the middle" $ do
        fromStrings
            [ "--start"
            , "2"
            , "--lines"
            , "3"
            , "--rule"
            , "1"
            , "--window"
            , "4"
            , "--move"
            , "5"
            , "--delay"
            , "6"
            ]
            `shouldBe` Right
                ( MkOptions
                    { optRule = 1
                    , optStart = 2
                    , optLines = Just 3
                    , optWindow = 4
                    , optMove = 5
                    , optDelay = 6
                    }
                )
