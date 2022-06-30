module Main where

import Prelude

import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Exception (throw)
import Network.RemoteData (RemoteData(..))
import React.Basic.DOM (render)
import Web.DOM.NonElementParentNode (getElementById)
import Web.HTML (window)
import Web.HTML.HTMLDocument (toNonElementParentNode)
import Web.HTML.Window (document)

import TV.UI.Container as Container

main :: Effect Unit
main = do
  mainElement <- getElementById "main" <<< toNonElementParentNode =<< document =<< window
  case mainElement of
    Nothing -> throw "Unable to find DOM element #main"
    Just element -> do
      container <- Container.component
      render (container initialProps) element
  where
  initialProps = { response: NotAsked }
