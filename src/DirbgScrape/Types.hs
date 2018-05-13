module DirbgScrape.Types
    (Article(..)
    ) where

import Data.Text

data Article = Article {name  :: Text,
                        url   :: Text}
    deriving (Show, Eq)
