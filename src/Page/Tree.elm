module Page.Tree exposing (Data, Model, Msg, page)

import DataSource exposing (DataSource)
import Head
import Head.Seo as Seo
import Html.Styled exposing (div, p, pre, text)
import Html.Styled.Attributes exposing (css)
import Markdown exposing (viewMarkdown)
import Page exposing (Page, PageWithState, StaticPayload)
import Page.Index exposing (..)
import Pages.PageUrl exposing (PageUrl)
import Pages.Url
import Shared
import Tree exposing (Tree(..))
import View exposing (View)


type alias Model =
    Page.Index.Model


type alias Data =
    Page.Index.Data


type alias Msg =
    Never


type alias RouteParams =
    {}


page : Page RouteParams Data
page =
    Page.single
        { head = Page.Index.head
        , data = data
        }
        |> Page.buildNoState { view = view }


view :
    Maybe PageUrl
    -> Shared.Model
    -> StaticPayload Data RouteParams
    -> View Msg
view _ _ static =
    { title = "angusjf"
    , body =
        [ div []
            [ pre [] <| Markdown.viewMarkdown <| Tree.render (toTree static.data) ]
        ]
    }


toTree : Data -> Tree
toTree dat =
    Collection
        { label = "[angusjf](/)"
        , items =
            [ Collection
                { label = "blog"
                , items =
                    List.filterMap
                        (\d ->
                            case d of
                                Blog { url, metadata } ->
                                    Just <|
                                        Link
                                            { label = metadata.title
                                            , url = "/" ++ url
                                            }

                                Experiment _ ->
                                    Nothing
                        )
                        dat
                }
            , Collection
                { label = "experiments"
                , items =
                    List.filterMap
                        (\d ->
                            case d of
                                Blog _ ->
                                    Nothing

                                Experiment { metadata } ->
                                    Just <|
                                        Collection
                                            { label = metadata.title
                                            , items =
                                                List.map
                                                    (\link ->
                                                        Link
                                                            { label = link.label
                                                            , url = link.url
                                                            }
                                                    )
                                                    metadata.urls
                                            }
                        )
                        dat
                }
            ]
        }
