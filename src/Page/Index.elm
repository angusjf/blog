module Page.Index exposing (Data, Model, Msg, page)

import Components exposing (date, link, viewCard, viewDescription, viewLinkWithIcon, viewLinks)
import Css exposing (color)
import DataSource exposing (DataSource)
import DataSource.File
import DataSource.Glob as Glob
import Date exposing (Date, toRataDie)
import Head
import Head.Seo as Seo
import Html.Styled exposing (a, canvas, code, div, h1, i, iframe, img, p, span, text)
import Html.Styled.Attributes exposing (class, css, href, id, src)
import Markdown exposing (viewMarkdown)
import Metadata exposing (BlogMetadata, ExperimentMetadata, frontmatterDecoder, jsonDecoder)
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
    {}


page : Page RouteParams Data
page =
    Page.single
        { head = head
        , data = data
        }
        |> Page.buildNoState { view = view }


type Path
    = BlogPath
    | ExperimentPath


blogs =
    Glob.succeed
        identity
        |> Glob.match (Glob.literal "content/blog/")
        |> Glob.capture Glob.wildcard
        |> Glob.match (Glob.literal ".md")
        |> Glob.toDataSource


experiments =
    Glob.succeed
        identity
        |> Glob.match (Glob.literal "content/experiments/")
        |> Glob.capture Glob.wildcard
        |> Glob.match (Glob.literal ".json")
        |> Glob.toDataSource


data : DataSource Data
data =
    DataSource.combine
        [ blogs
            |> DataSource.andThen
                (\urls ->
                    urls
                        |> List.map
                            (\url ->
                                DataSource.File.onlyFrontmatter frontmatterDecoder ("content/blog/" ++ url ++ ".md")
                                    |> DataSource.map
                                        (\metadata ->
                                            Blog
                                                { metadata = metadata
                                                , url = url
                                                }
                                        )
                            )
                        |> DataSource.combine
                )
        , experiments
            |> DataSource.andThen
                (\urls ->
                    urls
                        |> List.map
                            (\url ->
                                DataSource.File.jsonFile jsonDecoder ("content/experiments/" ++ url ++ ".json")
                                    |> DataSource.map
                                        (\metadata ->
                                            Experiment
                                                { metadata = metadata
                                                , url = url
                                                }
                                        )
                            )
                        |> DataSource.combine
                )
        ]
        |> DataSource.map List.concat
        |> DataSource.map (List.sortBy datePublished)


datePublished x =
    (case x of
        Blog { metadata } ->
            metadata.date

        Experiment { metadata } ->
            metadata.date
    )
        |> toRataDie
        |> negate


head :
    StaticPayload Data RouteParams
    -> List Head.Tag
head static =
    Seo.summary
        { canonicalUrlOverride = Nothing
        , siteName = "Angus Findlay's Blog"
        , image =
            { url = Pages.Url.external "www.angusjf.com"
            , alt = "TODO"
            , dimensions = Nothing
            , mimeType = Nothing
            }
        , description = "TODO"
        , locale = Nothing
        , title = "TODO title" -- metadata.title -- TODO
        }
        |> Seo.website


type alias Data =
    List Content


type Content
    = Blog { url : String, metadata : BlogMetadata }
    | Experiment { url : String, metadata : ExperimentMetadata }


view :
    Maybe PageUrl
    -> Shared.Model
    -> StaticPayload Data RouteParams
    -> View Msg
view maybeUrl sharedModel static =
    { title = "Angus Findlay"
    , body =
        me
            :: (static.data
                    |> List.filter visible
                    |> List.map viewContent
               )
    }


visible content =
    case content of
        Blog { metadata } ->
            not metadata.hidden

        Experiment _ ->
            True


viewContent content =
    case content of
        Blog { metadata, url } ->
            viewCard
                { imgUrl = metadata.imgUrl
                , linksTo = Just url
                , title = metadata.title
                , content =
                    viewDescription (viewMarkdown metadata.summary)
                        ++ [ date metadata.date
                           ]
                }

        Experiment { metadata } ->
            viewCard
                { imgUrl = metadata.imgUrl
                , linksTo = Nothing
                , title = metadata.title
                , content =
                    [ div []
                        (viewDescription
                            (viewMarkdown metadata.summary)
                            ++ [ viewLinks metadata.urls
                               ]
                        )
                    , date metadata.date
                    ]
                }


me =
    viewCard
        { title = "Angus Findlay"
        , imgUrl = "images/portrait.jpg"
        , linksTo = Nothing
        , content =
            --[ link
            --    { url = "https://eps.leeds.ac.uk/electronic-engineering-undergraduate/news/article/5740/undergraduate-student-angus-findlay-recognised-for-outstanding-engineering-talent"
            --    , label = [ text "Award winning" ]
            --    }
            [ div [] <|
                viewDescription
                    [ p [] [ text "Fullstack Engineer based in London!" ]
                    ]

            --, p []
            --    [ text "MEng Computer Science & Electrical Engineering (University of Leeds & KU Leuven)." ]
            --, p []
            --    [ text "Interested in design, programming languages and people." ]
            , viewLinks
                [ { url = "https://github.com/angusjf/"
                  , icon = "fab fa-github"
                  , label = "github/angusjf"
                  }
                , { url = "https://www.linkedin.com/in/angus-findlay/"
                  , icon = "fab fa-linkedin"
                  , label = "linkedin/angus-findlay"
                  }
                ]
            ]
        }
