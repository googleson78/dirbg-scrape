{-# LANGUAGE OverloadedStrings #-}
module Main where

import DirbgScrape.Types
import DirbgScrape.ProcessResponse
import qualified Data.Text as T
import qualified Data.Text.IO as T
import qualified Data.Text.Encoding as T
import qualified Data.ByteString.Lazy as BS
import Network.Wreq
import System.Environment
import Data.Maybe
import Data.Aeson
import Control.Lens

usage :: T.Text
usage = "usage: Pass exactly 2 arguments of the form: <search-query> <output-path>"

main :: IO ()
main = do
    args <- getArgs
    if length args /= 2
    then 
        T.putStrLn usage
    else do
        let query   = args !! 0
        let outPath = args !! 1
        response <- get ("https://dir.bg/search?q=" ++ query)
        let html = responseText response
        let articles = scrapeArticles html
        if isNothing articles 
        then
            T.putStrLn "malformed response (or something)"
        else
            BS.writeFile outPath $ encode $ take 10 $ fromJust articles
