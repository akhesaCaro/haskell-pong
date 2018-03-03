module CollisionDetection where

  import GameBoard

  -- | Given position and radius of the ball, return whether a collision occurred on a player
  paddleCollision :: PongGame -- ^ The game
                  -> Bool     -- ^ Collision with the paddles?

  paddleCollision game =
    ((deltaXP1 * deltaXP1 + deltaYP1 * deltaYP1) <
      (ballRadius * ballRadius)) ||
        ((deltaXP2 * deltaXP2 + deltaYP2 * deltaYP2) <
          (ballRadius * ballRadius))
    where

      -- Ball's center
      (ballX, ballY) = ballLoc game

      -- Player 1's paddle's center
      recXP1 = paddlesDistance
      recYP1 = player1 game

      -- Player 2's paddle's center
      recXP2 = -paddlesDistance
      recYP2 = player2 game

      -- Player A's paddle's left bottom corner (needed for collision math)
      rectCornerXP1 = recXP1 -paddleWidth / 2
      rectCornerYP1 = recYP1 -paddleHeight / 2

      -- Player 2's paddle's left bottom corner (needed for collision math)
      rectCornerXP2 = recXP2 -paddleWidth / 2
      rectCornerYP2 = recYP2 -paddleHeight / 2

      deltaXP1 = ballX - max rectCornerXP1 (min ballX (rectCornerXP1 + paddleWidth))
      deltaYP1 = ballY - max rectCornerYP1 (min ballY (rectCornerYP1 + paddleHeight))

      deltaXP2 = ballX - max rectCornerXP2 (min ballX (rectCornerXP2 + paddleWidth))
      deltaYP2 = ballY - max rectCornerYP2 (min ballY (rectCornerYP2 + paddleHeight))

  -- | Given position and radius of the ball, return whether a collision occurred on the wall.
  wallCollision :: Position -- ^ Ball's position
                -> Radius   -- ^ Ball's radius
                -> Bool     -- ^ Collision with the walls?
  wallCollision (_, y) radius =
      topCollision || bottomCollision
    where
      topCollision = y + radius >= fromIntegral width / 2
      bottomCollision = y - radius <= -(fromIntegral width / 2)
