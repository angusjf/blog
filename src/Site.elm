module Site exposing (config)

import DataSource
import Head
import MimeType exposing (MimeImage(..), MimeType(..))
import Pages.Manifest as Manifest exposing (IconPurpose(..))
import Pages.Url
import Path
import Route
import SiteConfig exposing (SiteConfig)


type alias Data =
    ()


config : SiteConfig Data
config =
    { data = data
    , canonicalUrl = "https://angusjf.com"
    , manifest = manifest
    , head = head
    }


data : DataSource.DataSource Data
data =
    DataSource.succeed ()


head : Data -> List Head.Tag
head static =
    [ Head.sitemapLink "/sitemap.xml"
    , Head.icon [] Png (Pages.Url.fromPath <| Path.fromString "/favicon.png")
    , Head.icon [ ( 16, 16 ) ] Png (Pages.Url.fromPath <| Path.fromString "/favicon-16x16.png")
    , Head.icon [ ( 32, 32 ) ] Png (Pages.Url.fromPath <| Path.fromString "/favicon-32x32.png")
    , Head.appleTouchIcon (Just 180) (Pages.Url.fromPath <| Path.fromString "/apple-touch-icon.png")

    --, <link rel="mask-icon" href="/safari-pinned-tab.svg" color="#5bbad5">
    , Head.metaName "msapplication-TileColor" (Head.raw "#da532c")
    , Head.metaName "theme-color" (Head.raw "#ffffff")

    -- , Head.link <link rel="stylesheet" href="//cdnjs.cloudflare.com/ajax/libs/highlight.js/11.5.0/styles/default.min.css">
    -- <script src="//cdnjs.cloudflare.com/ajax/libs/highlight.js/11.5.0/highlight.min.js"></script>
    ]


manifest : Data -> Manifest.Config
manifest static =
    Manifest.init
        { name = "Angus Findlay"
        , description = "Angus Findlay's Personal Blog"
        , startUrl = Route.Index |> Route.toPath
        , icons =
            [ { mimeType = Just Png
              , sizes = [ ( 32, 32 ) ]
              , src = Pages.Url.fromPath <| Path.fromString "/favicon-32x32.png"
              , purposes = [ IconPurposeAny ]
              }
            , { mimeType = Just Png
              , sizes = [ ( 16, 16 ) ]
              , src = Pages.Url.fromPath <| Path.fromString "/favicon-16x16.png"
              , purposes = [ IconPurposeAny ]
              }
            ]
        }
        |> Manifest.withShortName "angusjf"
