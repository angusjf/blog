module Tree exposing (..)


type Tree
    = Link { url : String, label : String }
    | Collection { label : String, items : List Tree }


render : Tree -> String
render =
    draw []


draw : List Bool -> Tree -> String
draw n tree =
    case tree of
        Link { url, label } ->
            s n ++ "[" ++ label ++ "]" ++ "(" ++ url ++ ")" ++ "\n"

        Collection { items, label } ->
            case runcons items of
                Just ( init, last ) ->
                    let
                        children =
                            String.concat
                                (List.map (draw (False :: n)) init
                                    ++ [ draw (True :: n) last ]
                                )
                    in
                    s n ++ label ++ "\n" ++ children

                Nothing ->
                    ""


runcons : List a -> Maybe ( List a, a )
runcons l =
    case l of
        [ x ] ->
            Just ( [], x )

        x :: xs ->
            case runcons xs of
                Just ( ys, y ) ->
                    Just ( y :: ys, x )

                Nothing ->
                    Just ( [], x )

        [] ->
            Nothing


s n =
    case n of
        [] ->
            ""

        x :: xs ->
            String.concat
                (List.map
                    (\b ->
                        if b then
                            "    "

                        else
                            "│   "
                    )
                    (List.reverse xs)
                )
                ++ (if x then
                        "└── "

                    else
                        "├── "
                   )
