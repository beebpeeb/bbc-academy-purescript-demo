module TV.Data.Description
  ( Description
  , fromString
  , hasText
  , isEmpty
  , isRepeat
  , toString
  ) where

import Prelude

import Data.Argonaut (class DecodeJson, decodeJson)
import Data.Either (hush)
import Data.Maybe (Maybe, fromMaybe)
import Data.String (trim)
import Data.String.Regex (Regex, regex, replace, test)
import Data.String.Regex.Flags (multiline)

-- | Custom type representing the possible description of a TV show.
-- | Construct a `Description` with `fromString`.
data Description
  = NoDescription
  | Description String
  | RepeatDescription String

derive instance eqDescription :: Eq Description

derive instance ordDescription :: Ord Description

instance decodeJsonDescription :: DecodeJson Description where
  decodeJson = decodeJson >=> fromString >>> pure

instance showDescription :: Show Description where
  show =
    case _ of
      NoDescription -> "NoDescription"
      Description s -> "(Description " <> show s <> ")"
      RepeatDescription s -> "(RepeatDescription " <> show s <> ")"

-- | Construct a `Description` from the given string
fromString :: String -> Description
fromString =
  trim >>> case _ of
    "" -> NoDescription
    s -> if hasSuffix s
           then RepeatDescription (removeSuffix s)
           else Description s

-- Return `true` if the given string matches the repeat broadcast regex
hasSuffix :: String -> Boolean
hasSuffix s = fromMaybe false $ test <$> rx <@> s

-- | Return `true` if the given `Description` has text
hasText :: Description -> Boolean
hasText = not isEmpty

-- | Return `true` if the given `Description` has no text
isEmpty :: Description -> Boolean
isEmpty =
  case _ of
    NoDescription -> true
    _ -> false

-- | Return `true` if the given `Description` represents a repeat transmission
isRepeat :: Description -> Boolean
isRepeat =
  case _ of
    RepeatDescription _ -> true
    _ -> false

-- Remove the redundant repeat marker suffix from the given string
removeSuffix :: String -> String
removeSuffix s = trim $ fromMaybe s $ replace <$> rx <@> "$1" <@> s

-- Regular expression which identifies a repeat broadcast
rx :: Maybe Regex
rx = hush $ regex """(\W+)e.?\s*$""" multiline

-- | Return a `Description` as a plain string
toString :: Description -> String
toString =
  case _ of
    NoDescription -> mempty
    Description s -> s
    RepeatDescription s -> s
