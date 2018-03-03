module Main where

import           EventHandler
import           GameBoard
import           Physics
import           Rendering

import           Graphics.Gloss
import           Graphics.Gloss.Data.ViewPort
import           Graphics.Gloss.Interface.IO.Game

import           Debug.Trace

-- | Update the game in IO
updateIO :: (Float -> PongGame -> IO PongGame)
updateIO s game = return $ update s game

-- | Update the game by moving the ball and bouncing off walls.
update :: Float     -- ^ The number of seconds since last update
       -> PongGame  -- ^ The intial game state
       -> PongGame  -- ^ A new game state with an updated ball and paddles positions.
update seconds =
  movePaddles . wallBounce . paddleBounce . moveBall seconds

-- | Window
window :: Display
window = InWindow "Pong" (width, height) (offset, offset)

-- | Background Color
background :: Color
background = black

-- | Frames per second
fps :: Int
fps = 60

-- | Main
-- play :: Display   -- ^ Display window
--      -> Color     -- ^ Background color
--      -> Int       -- ^ Frames per second (FPS)
--      -> PongGame  -- ^ Initial state of the game
--      -> (PongGame -> Picture) -- ^ Rendering the game
--      -> (Event -> PongGame -> PongGame) -- ^ Handlering key events
--      -> (Float -> PongGame -> PongGame) -- ^ Update Game

main :: IO ()
main = playIO window background fps initialState renderIO handleKeysIO updateIO
