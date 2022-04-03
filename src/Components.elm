module Components exposing (..)

import Css exposing (color)
import Date
import Html.Styled exposing (a, div, h1, i, img, span, text)
import Html.Styled.Attributes as Attrs exposing (class, css, href, src)
import Tailwind.Utilities as Tw


wrapper children =
    div
        [ css
            [ Tw.font_sans
            ]
        ]
        [ div
            [ css
                [ Tw.mx_auto
                , Tw.max_w_2xl
                , Tw.my_12
                ]
            ]
            children
        ]


link { url, label } =
    a [ href url, css [ color Css.inherit ] ] label


viewCard { imgUrl, title, content, linksTo } =
    div
        [ css
            [ Tw.rounded_lg
            , Tw.mx_6
            , Tw.my_auto
            , Tw.px_8
            , Tw.pb_8
            , Tw.pt_3
            , Tw.bg_white
            , Tw.text_black
            , Tw.max_w_xl
            , Tw.shadow_xl
            , Tw.mb_14
            ]
        ]
        [ div
            [ css [ Tw.flex, Tw.flex_row, Tw.items_center, Tw.justify_between ] ]
            [ div
                []
                [ h1 [] <|
                    case linksTo of
                        Nothing ->
                            [ text title ]

                        Just url ->
                            [ link { url = url, label = [ text title ] } ]
                , div [] content
                ]
            , div [ css [ Tw.ml_5, Tw.flex, Tw.pt_5 ] ]
                [ roundedImage { url = imgUrl, title = Nothing, alt = title } ]
            ]
        ]


viewDescription x =
    [ span [ css [ Tw.text_gray_500 ] ] x ]


header =
    div [ css [ Tw.flex, Tw.justify_center, Tw.mb_12 ] ]
        [ link { url = "/", label = [ text "angusjf" ] } ]


viewBlog content =
    div [ css [ Tw.bg_white, Tw.py_8, Tw.px_12, Tw.pt_5, Tw.rounded_xl, Tw.shadow_xl ] ] content


boxed =
    span [ css [ Tw.bg_black, Tw.font_black, Tw.px_1 ] ]


roundedImage { url, alt } =
    img
        [ src url
        , Attrs.alt alt

        --, Attr.title title TODO
        , css [ Tw.max_h_32, Tw.object_cover, Tw.rounded_md ]
        ]
        []


image { url, alt } =
    img
        [ src url
        , Attrs.alt alt

        --, Attr.title title TODO
        , css [ Tw.max_h_32, Tw.object_cover ]
        ]
        []


date x =
    div [ css [ Tw.text_gray_400, Tw.mt_5 ] ] [ text (Date.format "ddd MMM y" x) ]


viewLinks =
    div [] << List.map viewLinkWithIcon


viewLinkWithIcon { label, url, icon } =
    div [ css [ Tw.mt_2 ] ] [ link { label = [ span [ css [ Tw.pr_2 ] ] [ i [ class icon ] [] ], text label ], url = url } ]
