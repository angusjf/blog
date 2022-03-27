module Page.Index exposing (Data, Model, Msg, page)

import DataSource exposing (DataSource)
import DataSource.Glob as Glob
import Head
import Head.Seo as Seo
import Html exposing (a, canvas, code, div, h1, i, img, p, text)
import Html.Attributes exposing (class, href, id, src)
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


data : DataSource Data
data =
    Glob.succeed
        (\x ->
            { url = x, title = x }
        )
        |> Glob.match (Glob.literal "content/blog/")
        |> Glob.capture Glob.wildcard
        |> Glob.match (Glob.literal ".md")
        |> Glob.toDataSource


head :
    StaticPayload Data RouteParams
    -> List Head.Tag
head static =
    Seo.summary
        { canonicalUrlOverride = Nothing
        , siteName = "Angus Findlay's Blog"
        , image =
            { url = Pages.Url.external "TODO"
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
    List { url : String, title : String }


view :
    Maybe PageUrl
    -> Shared.Model
    -> StaticPayload Data RouteParams
    -> View Msg
view maybeUrl sharedModel static =
    { title = "Angus Findlay"
    , body =
        [ div [ class "card" ]
            [ img [ src "images/portrait.jpg" ]
                []
            , div []
                [ h1 []
                    [ text "Angus Findlay" ]
                , p []
                    [ a [ href "https://eps.leeds.ac.uk/electronic-engineering-undergraduate/news/article/5740/undergraduate-student-angus-findlay-recognised-for-outstanding-engineering-talent" ]
                        [ text "Award winning" ]
                    , text "Fullstack Engineer based in London!"
                    ]
                , p []
                    [ text "MEng Computer Science & Electrical Engineering (University of Leeds & KU Leuven)." ]
                , p []
                    [ text "Interested in design, programming languages and people." ]
                , div [ class "list" ]
                    [ a [ href "https://github.com/angusjf/" ]
                        [ i [ class "fab fa-github" ]
                            []
                        , text "github/angusjf          "
                        ]
                    , a [ href "https://www.linkedin.com/in/angus-findlay/" ]
                        [ i [ class "fab fa-linkedin" ]
                            []
                        , text "linkedin/angus-findlay          "
                        ]
                    ]
                ]
            ]
        ]
            ++ List.map (\{ url, title } -> a [ href url ] [ text title ]) static.data
    }


cards =
    [ { imgUrl = "images/vimle.png"
      , title = "Vimle"
      , content = [ text "Wordle for ", code [] [ text "vim" ], text "fans." ]
      , links =
            [ a [ href "./vimle.html" ]
                [ i [ class "fas fa-code" ]
                    []
                , text "/vimle"
                ]
            , a [ href "https://github.com/angusjf/vimle" ]
                [ i [ class "fab fa-github" ]
                    []
                , text "angusjf/vimle"
                ]
            ]
      }
    ]


viewCard { imgUrl, title, content, links } =
    div [ class "card" ]
        [ img [ src imgUrl ] []
        , div []
            [ h1 []
                [ text title ]
            , p [] content
            , div [ class "list" ] links
            ]
        ]


allCards =
    [ div [ class "card" ]
        [ img [ src "images/vimle.png" ]
            []
        , div []
            [ h1 []
                [ text "Vimle" ]
            , p []
                [ text "Wordle for "
                , code []
                    [ text "vim" ]
                , text "fans.        "
                ]
            , div [ class "list" ]
                [ a [ href "./vimle.html" ]
                    [ i [ class "fas fa-code" ]
                        []
                    , text "/vimle          "
                    ]
                , a [ href "https://github.com/angusjf/vimle" ]
                    [ i [ class "fab fa-github" ]
                        []
                    , text "angusjf/vimle          "
                    ]
                ]
            ]
        ]
    , div [ class "card" ]
        [ img [ src "https://blog.theodo.com/static/941450517ed84e3ad0080437b79bf332/a79d3/thumbnail.png" ]
            []
        , div []
            [ h1 []
                [ text "An Intro to Elm for React Developers" ]
            , p []
                [ text "Blogpost written for the Theodo Blog. Published in the "
                , a [ href "https://reactnewsletter.com/issues/289" ]
                    [ text "React Newsletter" ]
                ]
            , div [ class "list" ]
                [ a [ href "https://blog.theodo.com/2021/10/intro-to-elm-for-react-devs/" ]
                    [ i [ class "fas fa-book" ]
                        []
                    , text "Read it on the Theodo blog          "
                    ]
                ]
            ]
        ]
    , div [ class "card" ]
        [ img [ src "images/visualiser.png" ]
            []
        , div []
            [ h1 []
                [ text "Visualise Java Projects in Visual Studio Code" ]
            , p []
                [ text "A Visual Studio code extension to make large Java codebases more          accessible.        " ]
            , div [ class "list" ]
                [ a [ href "https://marketplace.visualstudio.com/items?itemName=angusjf.visualise" ]
                    [ i [ class "fas fa-project-diagram" ]
                        []
                    , text "Visual Studio Marketplace          "
                    ]
                ]
            ]
        ]
    , div [ class "card" ]
        [ img [ src "images/hanzi.png" ]
            []
        , div []
            [ h1 []
                [ text "Learn Chinese & Japanese Characters" ]
            , p []
                [ text "A tiny quiz web app for Hanzi/Kanji." ]
            , div [ class "list" ]
                [ a [ href "/hanzi.html" ]
                    [ i [ class "fas fa-trophy" ]
                        []
                    , text "/hanzi"
                    ]
                ]
            ]
        ]
    , div [ class "card" ]
        [ img [ src "images/code-genius.png" ]
            []
        , div []
            [ h1 []
                [ text "Code Genius" ]
            , p []
                [ text "A Rap Genius inspired website for people learning to code." ]
            , div [ class "list" ]
                [ a [ href "/code-genius.html" ]
                    [ i [ class "fas fa-code" ]
                        []
                    , text "/code-genius          "
                    ]
                ]
            ]
        ]
    , div [ class "card" ]
        [ img [ src "images/beta.png" ]
            []
        , div []
            [ h1 []
                [ text "Songscore" ]
            , p []
                [ text "A music reviewing platform, with a Single Page Application for the Web          and a mobile application for iOS & Android. Built with Elm,          Flutter & Go.        " ]
            , div [ class "list" ]
                [ a [ href "https://songscore.herokuapp.com/" ]
                    [ i [ class "fas fa-star" ]
                        []
                    , text "songscore.herokuapp.com          "
                    ]
                , a [ href "https://github.com/angusjf/songscore" ]
                    [ i [ class "fab fa-github" ]
                        []
                    , text "angusjf/songscore          "
                    ]
                ]
            ]
        ]
    , div [ class "card" ]
        [ canvas [ id "canvas" ]
            []
        , div []
            [ h1 []
                [ text "Functional Plants" ]
            , p []
                [ text "Experimenting with functional programming & data structures to          create live animations of plant growth.        " ]
            , div [ class "list" ]
                [ a [ href "https://github.com/angusjf/plants" ]
                    [ i [ class "fas fa-seedling" ]
                        []
                    , text "angusjf/plants          "
                    ]
                ]
            ]
        ]
    , div [ class "card" ]
        [ img [ src "images/cy.png" ]
            []
        , div []
            [ h1 []
                [ text "HyperGlich" ]
            , p []
                [ text "Some small programs for intentional aesthetic image-glitching, written          in Haskell & Elm.        " ]
            , div [ class "list" ]
                [ a [ href "./glitch.html" ]
                    [ i [ class "fas fa-bolt" ]
                        []
                    , text "/glitch "
                    ]
                , a [ href "https://github.com/angusjf/hyperglitch" ]
                    [ i [ class "fab fa-github" ]
                        []
                    , text "angusjf/hyperglitch          "
                    ]
                ]
            ]
        ]
    ]
