module Components exposing (..)

import Css exposing (color)
import Date
import Html.Styled exposing (a, code, div, h1, h2, i, img, p, span, text)
import Html.Styled.Attributes as Attrs exposing (class, href, src)


viewHomepage =
    div [ class "homepage" ]


wrapper =
    div [ class "wrapper" ]


link { url, label } =
    a [ href url ] label


viewCard { imgUrl, title, content, linksTo } =
    div
        [ class "card" ]
        [ div []
            [ div []
                [ roundedImage { url = imgUrl, title = Nothing, alt = title } ]
            , div
                []
                [ h2 [] <|
                    case linksTo of
                        Nothing ->
                            [ text title ]

                        Just url ->
                            [ link { url = url, label = [ text title ] } ]
                , div [] content
                ]
            ]
        ]


viewDescription x =
    x


header =
    div [ class "link-back" ]
        [ link { url = "/", label = [ text "angusjf" ] } ]


viewBlog content =
    div [ class "blog" ] content


boxed =
    span []


roundedImage { url, alt } =
    img
        [ src url
        , Attrs.alt alt

        --, Attr.title title TODO
        ]
        []


image { url, alt } =
    div [ class "image-container" ]
        [ img
            [ src url
            , Attrs.alt alt

            --, Attr.title title TODO
            ]
            []
        ]


date x =
    div [] [ text (Date.format "ddd MMM y" x) ]


viewLinks =
    p [] << List.map viewLinkWithIcon


viewLinkWithIcon { label, url, icon } =
    div [] [ link { label = [ span [] [ i [ class icon ] [] ], text label ], url = url } ]


codeSpan t =
    code [] [ text t ]
