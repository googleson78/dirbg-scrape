{-# LANGUAGE OverloadedStrings #-}
module DirbgScrape.Internal.ProcessResponse where

import Text.HTML.Scalpel.Core
import qualified Data.Text as T
import Control.Lens
import Network.Wreq
import qualified Data.ByteString.Lazy as BS
import qualified Data.Text.Encoding as T
import Control.Applicative
import DirbgScrape.Types

asdf :: IO T.Text
asdf = do
    a <- get "https://dir.bg/search?q=lol"
    pure $ T.decodeUtf8 $ BS.toStrict $ a ^. responseBody

articles :: Selector
articles = "div" @: [hasClass "text-news", hasClass "list-article"]

titles :: Selector -> Scraper T.Text [T.Text]
titles = attrs "title"

links :: Selector -> Scraper T.Text [T.Text]
links  = attrs "href"

scrapeArticles :: T.Text -> Maybe [Article]
scrapeArticles html = (fmap (uncurry Article)) <$> scraped
    where scraped = zip <$> titles' <*> links'
          titles' = scrapeStringLike html (titles articles)
          links'  = scrapeStringLike html (links articles) -- $ links articles

responseText :: Response BS.ByteString -> T.Text
responseText = T.decodeUtf8 . BS.toStrict . (^. responseBody)

scrape' :: T.Text -> Maybe [Article]
scrape' html = fmap (fmap (Article "")) $ scrapeStringLike html (links articles)
