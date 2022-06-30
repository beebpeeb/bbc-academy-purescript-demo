module TV.UI.Schedule where

import Prelude

import Data.Array.NonEmpty (sort)
import Data.Foldable (foldMap)
import Data.Monoid (guard)
import Network.RemoteData (RemoteData(..))
import React.Basic.DOM as DOM
import React.Basic.Hooks (Component)
import React.Basic.Hooks as React

import TV.Data.TVShow (Status(..))
import TV.Data.TVShow as TVShow
import TV.UI.Common (Props)

component :: Component Props
component =
  React.component "Schedule" \props -> React.do
    pure
      $ DOM.section
          { className: "container"
          , children:
              [ case props.response of
                  Success tvShows -> foldMap tvShow $ sort tvShows
                  Loading -> spinner
                  _ -> mempty
              ]
          }
  where
  description t =
    guard (TVShow.hasDescription t)
      $ DOM.p
          { className: "text-muted"
          , children: [ DOM.text $ TVShow.descriptionString t ]
          }

  spinner =
    DOM.div
      { className: "spinner-border text-muted"
      , children: []
      }

  startTime t =
    DOM.h4
      { className: "text-info"
      , children: [ DOM.text $ TVShow.startTimeString t ]
      }

  statusBadge =
    TVShow.status >>> case _ of
      Standard -> mempty
      Live ->
        DOM.p
          { className: "badge bg-danger"
          , children: [ DOM.text "bein útsending" ]
          }
      Repeat ->
        DOM.p
          { className: "badge bg-success"
          , children: [ DOM.text "endurtekinn" ]
          }

  title t =
    DOM.h4
      { className: "text-primary"
      , children: [ DOM.text $ TVShow.titleString t ]
      }

  tvShow t =
    React.keyed (TVShow.timestamp t)
      $ DOM.div
          { className: "row mb-3"
          , children:
              [ DOM.div
                  { className: "col-2"
                  , children: [ startTime t ]
                  }
              , DOM.div
                  { className: "col-10"
                  , children: [ title, description, statusBadge ] <@> t
                  }
              ]
          }
