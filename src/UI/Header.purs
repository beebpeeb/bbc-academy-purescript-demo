module TV.UI.Header where

import Prelude

import Network.RemoteData (RemoteData(..))
import React.Basic.DOM as DOM
import React.Basic.Hooks (Component)
import React.Basic.Hooks as React

import TV.Data.TVShow (scheduleDate)
import TV.UI.Common (Props)

component :: Component Props
component =
  React.component "Header" \props -> React.do
    pure
      $ DOM.header
          { className: "my-5"
          , children:
              [ DOM.div
                  { className: "container"
                  , children:
                      [ DOM.h1
                          { className: "display-5"
                          , children: [ DOM.text $ "Dagskrá RÚV" ]
                          }
                      , DOM.p
                          { className: "text-info"
                          , children: [ DOM.text $ subtitle props.response ]
                          }
                      ]
                  }
              ]
          }
  where
  subtitle = case _ of
    Loading -> "Hleð..."
    Success tvShows -> scheduleDate tvShows
    Failure error -> "Eitthvað fór úrskeiðis! " <> error
    _ -> mempty
