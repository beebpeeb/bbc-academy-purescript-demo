module TV.UI.Container where

import Prelude

import Data.Foldable (fold)
import Data.Maybe (fromMaybe)
import Network.RemoteData (RemoteData(..))
import React.Basic.Hooks (Component)
import React.Basic.Hooks as React
import React.Basic.Hooks.Aff (useAff)

import TV.API (fetchTVShows)
import TV.UI.Common (Props)
import TV.UI.Header as Header
import TV.UI.Schedule as Schedule

component :: Component Props
component = do
  header <- Header.component
  schedule <- Schedule.component
  React.component "Container" \_ -> React.do
    response <- fromMaybe Loading <$> useAff unit fetchTVShows
    pure $ fold $ [ header, schedule ] <@> { response }
