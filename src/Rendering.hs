{-# LANGUAGE NamedFieldPuns #-}

module Rendering where

  import GameBoard

  import Graphics.Gloss

  paddleColor = black


  --Make stateText
  mkStateText :: Color -> String -> Float -> Float -> Picture
  mkStateText col text x y = translate (-120) 0 $ scale x y $ color col $ Text text

  --Make a paddle of a given border and vertical offset.
  mkPaddle :: Color -> Float -> Float -> Picture
  mkPaddle col x y = pictures
    [ translate x y $ color col $ rectangleSolid paddleWidth paddleHeight
    , translate x y $ color paddleColor $ rectangleSolid
          (paddleWidth - paddleBorder) (paddleHeight - paddleBorder)
    ]

  -- | Render game in IO
  renderIO :: (PongGame -> IO Picture)
  renderIO game = return $ render game

  -- | Draw a pong game state (convert it to a picture).
  render :: PongGame  -- ^ The game state to render
         -> Picture   -- ^ A picture of this game state

  -- Paused state
  render game @ Game { gameState = Paused } =
    mkStateText orange "PAUSED" 0.5 0.5

  -- Playing state
  render game @ Game { gameState = Playing } =
    pictures [ball, walls,
              mkPaddle blue paddlesDistance $ player1 game,
              mkPaddle orange (-paddlesDistance) $ player2 game]

    where

      -- State text
      stateText = "Paused"

      -- The pong ball.
      ball = uncurry translate (ballLoc game) $ color ballColor $ circleSolid ballRadius
      ballColor = dark red

      -- The bottom and top walls
      wall :: Float -> Picture
      wall offset =
        translate 0 offset $
          color wallColor $
            rectangleSolid 270 10

      wallColor = greyN 0.5
      walls = pictures [wall 150, wall (-150)]
