module GameBoard where

  paddleWidth, paddleHeight, paddleBorder, paddlesDistance, paddleStep, ballRadius  :: Float
  paddleWidth = 26
  paddleHeight = 86
  paddleBorder = 11
  paddlesDistance = 120
  paddleStep = 5
  ballRadius = 10

  width, height, offset:: Int
  width = 300
  height = 300
  offset = 100

  type Radius = Float
  type Position = (Float, Float)

  -- | The game state
  data GameState =
    Playing | Paused
    deriving Show

  -- | A data structure to hold the state of the Pong game.
  data PongGame = Game
    { gameState :: GameState
    , ballLoc :: (Float, Float) -- ^ Pong ball (x, y) location.
    , ballVel :: (Float, Float) -- ^ Pong ball (x, y) velocity.
    , player1 :: Float          -- ^ Left player paddle height.
                                -- Zero is the middle of the screen.
    , player1v :: Float   -- ^ player1's paddle's velocity.
    , player2 :: Float          -- ^ Right player paddle height.
    , player2v ::Float    -- ^ player2's paddle's velocity
    , paused :: Bool            -- ^ if the game is paused
    } deriving Show

  -- | Initialize the game with this game state.
  initialState :: PongGame
  initialState = Game
    { gameState = Playing
    , ballLoc = (0, 0)
    , ballVel = (40, -140)
    , player1 = 40
    , player1v = 0
    , player2 = 6
    , player2v = 0
    , paused  = False
    }
