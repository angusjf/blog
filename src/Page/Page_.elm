module Page.Page_ exposing (Data, Model, Msg, page)

import DataSource exposing (DataSource)
import DataSource.File
import DataSource.Glob as Glob
import Head
import Head.Seo as Seo
import Html exposing (div, span)
import Html.Attributes exposing (href, style)
import Markdown.Parser
import Markdown.Renderer
import Page exposing (Page, StaticPayload)
import Pages.PageUrl exposing (PageUrl)
import Pages.Url
import Shared
import View exposing (View)


type alias Model =
    ()


type alias Msg =
    Never


type alias RouteParams =
    { page : String }


page : Page RouteParams Data
page =
    Page.prerender
        { head = head
        , routes = routes
        , data = data
        }
        |> Page.buildNoState { view = view }


routes : DataSource (List RouteParams)
routes =
    Glob.succeed RouteParams
        |> Glob.match (Glob.literal "content/")
        |> Glob.match (Glob.literal "blog/")
        |> Glob.capture Glob.wildcard
        |> Glob.match (Glob.literal ".md")
        |> Glob.toDataSource


findFilePath : String -> DataSource ( String, String )
findFilePath slug =
    Glob.succeed Tuple.pair
        |> Glob.captureFilePath
        |> Glob.match (Glob.literal "content/")
        |> Glob.capture (Glob.literal "blog/")
        |> Glob.match (Glob.literal slug)
        |> Glob.match (Glob.literal ".md")
        |> Glob.expectUniqueMatch


data : RouteParams -> DataSource Data
data routeParams =
    findFilePath routeParams.page
        |> DataSource.andThen (\( x, y ) -> DataSource.File.bodyWithoutFrontmatter x)
        |> DataSource.map (\x -> { title = routeParams.page, body = x })


head :
    StaticPayload Data RouteParams
    -> List Head.Tag
head static =
    Seo.summary
        { canonicalUrlOverride = Nothing
        , siteName = "elm-pages"
        , image =
            { url = Pages.Url.external "TODO"
            , alt = "elm-pages logo"
            , dimensions = Nothing
            , mimeType = Nothing
            }
        , description = "TODO"
        , locale = Nothing
        , title = "TODO title" -- metadata.title -- TODO
        }
        |> Seo.website


type alias Data =
    { title : String, body : String }


customRenderer =
    let
        old =
            Markdown.Renderer.defaultHtmlRenderer
    in
    { old | strikethrough = \children -> boxed children }


boxed =
    span [ style "background-color" "black", style "color" "white", style "padding" "0px 2px" ]


markdown body =
    case Markdown.Parser.parse body of
        Ok ez ->
            case Markdown.Renderer.render customRenderer ez of
                Ok e ->
                    e

                Err _ ->
                    Debug.todo "xxxxxxxxX"

        Err _ ->
            Debug.todo "xxxxxxxxX"


header =
    Html.div [] [ Html.a [ href "/" ] [ Html.text "angusjf" ] ]


view :
    Maybe PageUrl
    -> Shared.Model
    -> StaticPayload Data RouteParams
    -> View Msg
view maybeUrl sharedModel static =
    { title = static.data.title
    , body = header :: markdown static.data.body
    }
