{-# LANGUAGE TemplateHaskell #-}

module Predef (injectPredef) where

import Data.ByteString       (ByteString, unpack)
import Data.ByteString.Char8 (pack)
import Data.Char             (chr)
import Data.FileEmbed        (embedFile)
import Data.List             (intercalate)

injectPredef :: String -> String
injectPredef s = predef ++ s

predef :: String
predef = intercalate "\n" (map toString [predefIO])

predefIO :: ByteString
predefIO = $(embedFile "lib/predef/IO.sf")

toString :: ByteString -> String
toString = map (chr . fromEnum) . unpack
