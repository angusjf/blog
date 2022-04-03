module Page.Page_ exposing (Data, Model, Msg, page)

import Components exposing (header, image, viewBlog)
import DataSource exposing (DataSource)
import DataSource.File
import DataSource.Glob as Glob
import Date exposing (toIsoString)
import Head
import Head.Seo as Seo
import Html.Styled as Html exposing (Html)
import Html.Styled.Attributes as Attr
import Markdown exposing (viewMarkdown)
import Markdown.Block as Block
import Markdown.Html
import Markdown.Parser
import Markdown.Renderer
import Metadata exposing (BlogMetadata, frontmatterDecoder)
import MimeType exposing (MimeImage(..), MimeType(..))
import OptimizedDecoder
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
        |> DataSource.andThen
            (\( filename, _ ) ->
                DataSource.File.bodyWithFrontmatter
                    (\body ->
                        OptimizedDecoder.map
                            (\metadata -> { body = body, metadata = metadata })
                            frontmatterDecoder
                    )
                    filename
            )


head :
    StaticPayload Data RouteParams
    -> List Head.Tag
head static =
    Seo.article
        { tags = static.data.metadata.tags
        , section = Nothing
        , publishedTime = Just <| toIsoString static.data.metadata.date
        , modifiedTime = Nothing
        , expirationTime = Nothing
        }
        (Seo.summary
            { canonicalUrlOverride = Nothing
            , siteName = "angusjf"
            , image =
                { url = Pages.Url.external <| "https://angusjf.com/" ++ static.data.metadata.imgUrl
                , alt = static.data.metadata.imgAlt
                , dimensions = Nothing
                , mimeType = Just "image/png"
                }
            , description = static.data.metadata.seoDescription
            , locale = Nothing
            , title = static.data.metadata.title
            }
        )


type alias Data =
    { body : String, metadata : BlogMetadata }




view :
    Maybe PageUrl
    -> Shared.Model
    -> StaticPayload Data RouteParams
    -> View Msg
view _ _ static =
    { title = static.data.metadata.title
    , body = [ header, (viewBlog << viewMarkdown) static.data.body ]
    }
