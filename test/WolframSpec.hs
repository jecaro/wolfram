module WolframSpec where

import Test.Hspec (Spec, it, shouldBe)
import Wolfram (fromBinary, next, toBinary)

spec :: Spec
spec = do
    it "toBinary" $ do
        toBinary 0 `shouldBe` []
        toBinary 1 `shouldBe` [True]
        toBinary 2 `shouldBe` [True, False]
        toBinary 3 `shouldBe` [True, True]
        toBinary 4 `shouldBe` [True, False, False]
        toBinary 5 `shouldBe` [True, False, True]
        toBinary 6 `shouldBe` [True, True, False]
        toBinary 7 `shouldBe` [True, True, True]
        toBinary 8 `shouldBe` [True, False, False, False]
        toBinary 9 `shouldBe` [True, False, False, True]
        toBinary 10 `shouldBe` [True, False, True, False]
        toBinary 11 `shouldBe` [True, False, True, True]
        toBinary 12 `shouldBe` [True, True, False, False]
        toBinary 13 `shouldBe` [True, True, False, True]
        toBinary 14 `shouldBe` [True, True, True, False]
        toBinary 15 `shouldBe` [True, True, True, True]
    it "fromBinary" $ do
        fromBinary [] `shouldBe` 0
        fromBinary [True] `shouldBe` 1
        fromBinary [True, False] `shouldBe` 2
        fromBinary [True, True] `shouldBe` 3
        fromBinary [True, False, False] `shouldBe` 4
        fromBinary [True, False, True] `shouldBe` 5
        fromBinary [True, True, False] `shouldBe` 6
        fromBinary [True, True, True] `shouldBe` 7
        fromBinary [True, False, False, False] `shouldBe` 8
        fromBinary [True, False, False, True] `shouldBe` 9
        fromBinary [True, False, True, False] `shouldBe` 10
        fromBinary [True, False, True, True] `shouldBe` 11
        fromBinary [True, True, False, False] `shouldBe` 12
        fromBinary [True, True, False, True] `shouldBe` 13
        fromBinary [True, True, True, False] `shouldBe` 14
        fromBinary [True, True, True, True] `shouldBe` 15
    it "next" $ do
        next rule30 [True] `shouldBe` [True, True, True]
        next rule30 [True, True, True] `shouldBe` [True, True, False, False, True]
  where
    rule30 = [False, False, False, True, True, True, True, False]
