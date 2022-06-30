module TV.UI.Header where

import Prelude

import Network.RemoteData (RemoteData(..))
import React.Basic.DOM as DOM
import React.Basic.Hooks (Component)
import React.Basic.Hooks as React

import TV.Data.TVShow as TVShow
import TV.UI.Common (Props)

component :: Component Props
component =
  React.component "Header" \props -> React.do
    pure
      $ DOM.header
          { className: "mb-5 mt-3"
          , children:
              [ DOM.div
                  { className: "container"
                  , children:
                      [ DOM.h1
                          { className: "display-5"
                          , children: [ DOM.text "Dagskrá RÚV" ]
                          }
                      , DOM.p
                          { className: "text-info"
                          , children: [ DOM.text $ info props.response ]
                          }
                      ]
                  }
              ]
          }
  where
  info = case _ of
    NotAsked -> mempty
    Loading -> "Hleð..."
    Success tvShows -> TVShow.scheduleDate tvShows
    Failure error -> "Eitthvað fór úrskeiðis! " <> error
