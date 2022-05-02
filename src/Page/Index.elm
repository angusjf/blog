module Page.Index exposing (Content(..), Data, Model, Msg, data, head, page)

import Components exposing (date, viewCard, viewDescription, viewHomepage, viewLinks)
import DataSource exposing (DataSource)
import DataSource.File
import DataSource.Glob as Glob
import Date exposing (toRataDie)
import Head
import Head.Seo as Seo
import Html.Styled exposing (div, p, text)
import Markdown exposing (viewMarkdown)
import Metadata exposing (BlogMetadata, ExperimentMetadata, frontmatterDecoder, jsonDecoder)
import MimeType exposing (MimeImage(..))
import Page exposing (Page, StaticPayload)
import Pages.PageUrl exposing (PageUrl)
import Pages.Url
import Path
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


title =
    "Angus Findlay's Blog - angusjf"


description =
    "Angus Findlay's (angusjf) Blog - Experiments in Code, Functional Programming, Art and Language."


head :
    StaticPayload Data RouteParams
    -> List Head.Tag
head _ =
    Seo.summary
        { canonicalUrlOverride = Nothing
        , siteName = title
        , image =
            { url = "plants.webp" |> Path.fromString |> Pages.Url.fromPath
            , alt = "Angus Findlay"
            , dimensions = Nothing
            , mimeType = Just "image/jpeg"
            }
        , description = description
        , locale = Just "en_GB"
        , title = title
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
view _ _ static =
    { title = "Angus Findlay"
    , body =
        [ viewHomepage <|
            me
                :: (static.data
                        |> List.filter visible
                        |> List.map viewContent
                   )
        ]
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
