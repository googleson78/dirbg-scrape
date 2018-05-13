{-# LANGUAGE DeriveGeneric #-}
module DirbgScrape.Types
    (Article(..)
    ) where

import Data.Text
import Data.Aeson
import GHC.Generics

data Article = Article {name  :: Text,
                        url   :: Text}
    deriving (Generic, Show, Eq)

instance ToJSON Article where

instance FromJSON Article where
