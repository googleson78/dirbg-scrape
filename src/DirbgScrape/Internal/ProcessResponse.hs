{-# LANGUAGE OverloadedStrings #-}
module DirbgScrape.Internal.ProcessResponse where

import Text.HTML.Scalpel.Core
import qualified Data.Text as T
import Control.Lens
import Network.Wreq
import qualified Data.ByteString.Lazy as BS
import qualified Data.Text.Encoding as T
import DirbgScrape.Types

articles :: Selector
articles = "div" @: [hasClass "text-news", hasClass "list-article"] // 
           "a" @: ["class" @= "img-wrapper"]

titles :: Selector -> Scraper T.Text [T.Text]
titles = attrs "title"

links :: Selector -> Scraper T.Text [T.Text]
links  = attrs "href"

scrapeArticles :: T.Text -> Maybe [Article]
scrapeArticles htmltext = (fmap (uncurry Article)) <$> scraped
    where scraped = zip <$> titles' <*> links'
          titles' = scrapeStringLike htmltext (titles articles)
          links'  = scrapeStringLike htmltext (links articles) -- $ links articles

responseText :: Response BS.ByteString -> T.Text
responseText = T.decodeUtf8 . BS.toStrict . (^. responseBody)
