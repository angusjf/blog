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
    , codeSpan =
        \content -> Html.code [] [ Html.text content ]
    , link =
        \link content ->
            case link.title of
                Just title ->
                    Html.a
                        [ Attr.href link.destination
                        , Attr.title title
                        ]
                        content

                Nothing ->
                    Html.a [ Attr.href link.destination ] content
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
                classes =
                    -- Only the first word is used in the class
                    case Maybe.map String.words language of
                        Just (actualLanguage :: _) ->
                            [ Attr.class <| "language-" ++ actualLanguage ]

                        _ ->
                            []
            in
            Html.pre []
                [ Html.code classes
                    [ Html.text body
                    ]
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


markdown body =
    case Markdown.Parser.parse body of
        Ok ez ->
            case Markdown.Renderer.render customRenderer ez of
                Ok e ->
                    [ viewBlog e ]

                Err _ ->
                    []

        Err _ ->
            []


view :
    Maybe PageUrl
    -> Shared.Model
    -> StaticPayload Data RouteParams
    -> View Msg
view _ _ static =
    { title = static.data.metadata.title
    , body = [ header, (viewBlog << viewMarkdown) static.data.body ]
    }
