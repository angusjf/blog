module Markdown exposing (viewMarkdown)

import Components exposing (codeSpan, image, link)
import Html.Styled as Html exposing (Html)
import Html.Styled.Attributes as Attr
import Markdown.Block as Block
import Markdown.Html
import Markdown.Parser
import Markdown.Renderer
import MimeType exposing (MimeImage(..))
import SyntaxHighlight exposing (elm, gitHub, javascript, monokai, toBlockHtml, useTheme)


customRenderer : Markdown.Renderer.Renderer (Html msg)
customRenderer =
    { heading =
        \{ level, children } ->
            case level of
                Block.H1 ->
                    Html.h1 [] children

                Block.H2 ->
                    Html.h2 [] children

                Block.H3 ->
                    Html.h3 [] children

                Block.H4 ->
                    Html.h4 [] children

                Block.H5 ->
                    Html.h5 [] children

                Block.H6 ->
                    Html.h6 [] children
    , paragraph = Html.p []
    , hardLineBreak = Html.br [] []
    , blockQuote = Html.blockquote []
    , strong =
        \children -> Html.strong [] children
    , emphasis =
        \children -> Html.em [] children
    , strikethrough =
        \children -> Html.del [] children
    , codeSpan = codeSpan
    , link =
        \{ title, destination } content ->
            case title of
                Just t ->
                    link { url = destination, label = content }

                Nothing ->
                    link { url = destination, label = content }
    , image =
        \imageInfo ->
            image { url = imageInfo.src, alt = imageInfo.alt, title = imageInfo.title }
    , text =
        Html.text
    , unorderedList =
        \items ->
            Html.ul []
                (items
                    |> List.map
                        (\item ->
                            case item of
                                Block.ListItem task children ->
                                    let
                                        checkbox =
                                            case task of
                                                Block.NoTask ->
                                                    Html.text ""

                                                Block.IncompleteTask ->
                                                    Html.input
                                                        [ Attr.disabled True
                                                        , Attr.checked False
                                                        , Attr.type_ "checkbox"
                                                        ]
                                                        []

                                                Block.CompletedTask ->
                                                    Html.input
                                                        [ Attr.disabled True
                                                        , Attr.checked True
                                                        , Attr.type_ "checkbox"
                                                        ]
                                                        []
                                    in
                                    Html.li [] (checkbox :: children)
                        )
                )
    , orderedList =
        \startingIndex items ->
            Html.ol
                (case startingIndex of
                    1 ->
                        [ Attr.start startingIndex ]

                    _ ->
                        []
                )
                (items
                    |> List.map
                        (\itemBlocks ->
                            Html.li []
                                itemBlocks
                        )
                )
    , html = Markdown.Html.oneOf []
    , codeBlock =
        \{ body, language } ->
            let
                lang =
                    case Maybe.map String.words language of
                        Just ("elm" :: _) ->
                            elm

                        Just ("javascript" :: _) ->
                            javascript

                        _ ->
                            javascript
            in
            Html.div
                []
                [ useTheme gitHub |> Html.fromUnstyled
                , lang body
                    |> Result.map (toBlockHtml Nothing)
                    |> Result.map Html.fromUnstyled
                    |> Result.withDefault
                        (Html.pre [] [ Html.code [] [ Html.text body ] ])
                ]
    , thematicBreak = Html.hr [] []
    , table = Html.table []
    , tableHeader = Html.thead []
    , tableBody = Html.tbody []
    , tableRow = Html.tr []
    , tableHeaderCell =
        \maybeAlignment ->
            let
                attrs =
                    maybeAlignment
                        |> Maybe.map
                            (\alignment ->
                                case alignment of
                                    Block.AlignLeft ->
                                        "left"

                                    Block.AlignCenter ->
                                        "center"

                                    Block.AlignRight ->
                                        "right"
                            )
                        |> Maybe.map Attr.align
                        |> Maybe.map List.singleton
                        |> Maybe.withDefault []
            in
            Html.th attrs
    , tableCell =
        \maybeAlignment ->
            let
                attrs =
                    maybeAlignment
                        |> Maybe.map
                            (\alignment ->
                                case alignment of
                                    Block.AlignLeft ->
                                        "left"

                                    Block.AlignCenter ->
                                        "center"

                                    Block.AlignRight ->
                                        "right"
                            )
                        |> Maybe.map Attr.align
                        |> Maybe.map List.singleton
                        |> Maybe.withDefault []
            in
            Html.td attrs
    }


viewMarkdown body =
    case Markdown.Parser.parse body of
        Ok ez ->
            case Markdown.Renderer.render customRenderer ez of
                Ok e ->
                    e

                Err _ ->
                    []

        Err _ ->
            []
