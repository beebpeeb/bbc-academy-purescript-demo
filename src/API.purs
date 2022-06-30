module TV.API where

import Prelude

import Affjax.Web (get, printError)
import Affjax.ResponseFormat (json)
import Control.Monad.Error.Class (throwError)
import Data.Argonaut (printJsonDecodeError)
import Data.Either (Either(..), either)
import Effect.Aff (Aff)
import Network.RemoteData (RemoteData)

import TV.Data.TVShow (TVShows, decodeTVShows)

-- | Type synonym representing the data possibly returned by the external API
type APIResponse = RemoteData String TVShows

fetchTVShows :: Aff APIResponse
fetchTVShows = do
  response <- get json "https://apis.is/tv/ruv"
  pure case response of
    Left error ->
      throwError (printError error)
    Right { body } ->
      either (throwError <<< printJsonDecodeError) pure (decodeTVShows body)
