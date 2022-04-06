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
            let
                ( head, tail ) =
                    runcons items

                children =
                    tail
                        |> List.map (draw (n ++ [ False ]))
                        |> (\x -> x ++ [ draw (n ++ [ True ]) head ])
                        |> String.concat
            in
            s n ++ label ++ "\n" ++ children


runcons list =
    case List.reverse list of
        x :: xs ->
            ( x, List.reverse xs )

        _ ->
            Debug.todo ""


s n =
    case List.reverse n of
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
