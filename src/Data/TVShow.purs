module TV.Data.TVShow
  ( Status(..)
  , TVShow
  , TVShows
  , date
  , decodeTVShows
  , descriptionString
  , hasDescription
  , isLive
  , isRepeat
  , scheduleDate
  , startTimeString
  , status
  , timestamp
  , titleString
  ) where

import Prelude

import Data.Argonaut (class DecodeJson, Json, JsonDecodeError, (.:), decodeJson)
import Data.Array.NonEmpty (NonEmptyArray, head)
import Data.Either (Either)
import Data.String.NonEmpty (NonEmptyString)
import Data.String.NonEmpty as NES
import Data.Traversable (traverse)

import TV.Data.Description (Description)
import TV.Data.Description as Description
import TV.Data.StartTime (StartTime)
import TV.Data.StartTime as StartTime

-- | Union type representing the transmission status of a TV show.
data Status = Live | Repeat | Standard

-- | Sum type representing a TV show listing.
-- | A `TVShow` is constructed from a JSON object only.
-- |
-- | This type represents only the data needed from the external API.
-- | Everything else is derived from this data by functions in this module.
newtype TVShow = TVShow
  { description :: Description
  , live :: Boolean
  , startTime :: StartTime
  , title :: NonEmptyString
  }

derive instance eqTVShow :: Eq TVShow

instance decodeJsonTVShow :: DecodeJson TVShow where
  decodeJson json = do
    obj <- decodeJson json
    description <- obj .: "description"
    live <- obj .: "live"
    startTime <- obj .: "startTime"
    title <- obj .: "title"
    pure $ TVShow { description, live, startTime, title }

instance ordTVShow :: Ord TVShow where
  compare (TVShow a) (TVShow b) = compare a.startTime b.startTime

instance showTVShow :: Show TVShow where
  show (TVShow { title }) = "(TVShow " <> show title <> ")"

type TVShows = NonEmptyArray TVShow

date :: TVShow -> String
date (TVShow { startTime }) = StartTime.toDateString startTime

decodeTVShows :: Json -> Either JsonDecodeError TVShows
decodeTVShows = decodeJson >=> (_ .: "results") >=> traverse decodeJson

-- | Returns the description of a `TVShow` as a plain `String`.
descriptionString :: TVShow -> String
descriptionString (TVShow { description }) = Description.toString description

-- | Returns `true` if the given `TVShow` has a description.
hasDescription :: TVShow -> Boolean
hasDescription (TVShow { description }) = Description.hasText description

-- | Returns `true` if the given `TVShow` is a live transmission.
isLive :: TVShow -> Boolean
isLive (TVShow { live }) = live

-- | Returns `true` if the given `TVShow` is a repeat transmission.
isRepeat :: TVShow -> Boolean
isRepeat (TVShow { description }) = Description.isRepeat description

scheduleDate :: TVShows -> String
scheduleDate = date <<< head

-- | Returns the start time of a `TVShow` as a `String`.
startTimeString :: TVShow -> String
startTimeString (TVShow { startTime }) = StartTime.toTimeString startTime

-- | Returns the derived transmission `Status` of the given `TVShow`.
status :: TVShow -> Status
status = flap [ isLive, isRepeat ] >>> case _ of
  [ true, _ ] -> Live
  [ false, true ] -> Repeat
  _ -> Standard

-- | Returns the timestamp of the given `TVShow`.
timestamp :: TVShow -> String
timestamp (TVShow { startTime }) = StartTime.toTimestamp startTime

-- | Returns the title of the given `TVShow` as a plain `String`.
titleString :: TVShow -> String
titleString (TVShow { title }) = NES.toString title
