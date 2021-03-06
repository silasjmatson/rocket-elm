module Mover exposing (Mover, tickMover, moverView)

import Html exposing (Html)
import Svg exposing (image)
import Svg.Attributes exposing (x, y, width, height, xlinkHref, transform)


type alias Mover a =
    { a |
      x : Float
    , y : Float
    , d : Float         -- direction
    , s : Float         -- speed
    , acc : Float       -- accelerating -1 0 1
    , turn : Float      -- turning -1 0 1
    }


tickMover : Mover a -> Float -> Float -> Float -> Float -> Mover a
tickMover mover x1 y1 x2 y2 =
    { mover |
      s = (accelerateMover mover)
    , d = (turnMover mover)
    , x = (moveX mover x1 x2)
    , y = (moveY mover y1 y2)
    }


normalize : Float -> Float -> Float -> Float
normalize low high curr =
    if curr < low then curr + (high - low)
    else if curr >= high then curr - (high - low)
    else curr


moveX : Mover a -> Float -> Float -> Float
moveX {x, s, d} x1 x2 =
    clamp x1 x2 x + s * (cos <| turns <| d - 0.25)


moveY : Mover a -> Float -> Float -> Float
moveY {y, s, d} y1 y2 =
    clamp y1 y2 y + s * (sin <| turns <| d - 0.25)


accelerateMover : Mover a -> Float
accelerateMover mover =
    clamp 1 10 mover.s + (mover.acc * 0.1)


turnMover : Mover a -> Float
turnMover mover =
    normalize 0 1.0 mover.d + (mover.turn * 0.01)


moverView : Mover a -> String -> (Float, Float) -> Html msg
moverView mover img (w, h) =
    let
        angle = toString (mover.d * 360)
        rx = toString (mover.x - (w / 2))
        ry = toString (mover.y - (h / 2))

        transforms =
            "rotate("
            ++ angle
            ++ " " ++ (toString mover.x)
            ++ " " ++ (toString mover.y)
            ++ ")"
    in
        image
          [ x rx
          , y ry
          , width (toString w)
          , height (toString h)
          , xlinkHref img
          , transform transforms
          ] []
