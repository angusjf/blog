module Metadata exposing (..)

import Date exposing (Date)
import MimeType exposing (MimeImage(..))
import OptimizedDecoder as D exposing (Decoder)


frontmatterDecoder : Decoder BlogMetadata
frontmatterDecoder =
    D.map8
        BlogMetadata
        (D.field "title" D.string)
        (D.field "summary" D.string)
        (D.field "date" (D.andThen (resultToDecoder << Date.fromIsoString) D.string))
        (D.field "img_url" D.string)
        (D.field "img_alt" D.string)
        (D.field "tags" (D.list D.string))
        (D.field "hidden" D.bool)
        (D.field "seo_description" D.string)


type alias ExperimentMetadata =
    { summary : String
    , title : String
    , date : Date
    , imgUrl : String
    , imgUlt : String
    , urls : List Link
    }


jsonDecoder : Decoder ExperimentMetadata
jsonDecoder =
    D.map6 ExperimentMetadata
        (D.field "summary" D.string)
        (D.field "title" D.string)
        (D.field "date" (D.andThen (resultToDecoder << Date.fromIsoString) D.string))
        (D.field "img_url" D.string)
        (D.field "img_alt" D.string)
        (D.field "urls" (D.list urlDecoder))


type alias Link =
    { url : String, label : String, icon : String }


urlDecoder =
    D.map3 Link
        (D.field "href" D.string)
        (D.field "label" D.string)
        (D.field "icon" D.string)


type alias BlogMetadata =
    { title : String
    , summary : String
    , date : Date
    , imgUrl : String
    , imgAlt : String
    , tags : List String
    , hidden : Bool
    , seoDescription : String
    }


resultToDecoder : Result String x -> Decoder x
resultToDecoder r =
    case r of
        Ok x ->
            D.succeed x

        Err x ->
            D.fail x
