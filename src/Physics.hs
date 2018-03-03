{-# LANGUAGE NamedFieldPuns #-}

module Physics where

  import GameBoard
  import CollisionDetection

  import Data.Maybe


  -- | Move both paddles depending on the velocity
  movePaddles :: PongGame -- ^ Initial game state
              -> PongGame -- ^ new game with updated paddle position
  movePaddles game = game { player1 = movePaddle paddleStep (player1v game) (player1 game)
                          , player2 = movePaddle paddleStep (player2v game) (player2 game)
                          }

  -- | Update the paddle position
  movePaddle :: Float     -- ^ The step
             -> Float     -- ^ Paddle's velocity
             -> Float     -- ^ The initial player state
             -> Float     -- ^ The new player state with an updated paddle position


  movePaddle step velocity player

        -- ^ No step , no mouvement
        | velocity == 0 = player
        -- ^ Below ceiling, but trying to go down.
        | player >= fromIntegral offset && velocity < 0 =
            player + (step *  velocity)
        -- ^ Under floor, but trying to go up.
        | player <= fromIntegral (-offset) && velocity > 0 =
            player + (step *  velocity)
        -- ^Between the two walls.
        | player > fromIntegral (-offset) && player < fromIntegral offset =
            player + (step *  velocity)
        | otherwise = player

  -- | Ball Universe

  -- | Update the ball position using its current velocity.
  moveBall :: Float     -- ^ The number of seconds since last Update
           -> PongGame  -- ^ The initial game state
           -> PongGame  -- ^ A new game state with an updated ball position


  -- When paused, don't move.
  moveBall _ game@ Game { paused } | paused = game

  -- Moving the ball.
  moveBall seconds game =
    game { ballLoc = (x' , y') }
    where
      -- Old locations and velocities
      (x, y) = ballLoc game
      (vx, vy) = ballVel game

      --New locations
      x' = x + vx * seconds
      y' = y + vy * seconds


  -- | Detect a collision with a paddle. Upon collisions,
  -- change the velocity of the ball to bounce it off the paddle.
  paddleBounce :: PongGame  -- ^ The initial game state
               -> PongGame  -- ^ A new game state with an updated ball velocity

  paddleBounce game = game { ballVel = (vx', vy) }
    where
        (vx, vy) = ballVel game

        vx' = if paddleCollision game
              then
                  -- Update the velocity
                  (-vx)

                  else
                  -- Do nothing.Return te old velocity
                  vx

  -- | Detect a collision with one of the side walls. Upon collisions,
  -- update the velocity of the ball to bounce it off the wall.
  wallBounce :: PongGame  -- ^ The initial game state
             -> PongGame  -- ^ A new game state with an updated ball velocity

  wallBounce game = game { ballVel = (vx, vy') }
    where
        -- Radius. Use the same thing as in `render`.

        -- The old Velocities.
        (vx, vy) = ballVel game

        vy' = if wallCollision (ballLoc game) ballRadius
              then
                  -- Update the velocity
                  (-vy)
                  -- -vy
                  else
                  -- Do nothing.Return te old velocity
                  vy
