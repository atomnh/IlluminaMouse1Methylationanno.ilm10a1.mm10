#' Data of annotation for illumina mouse methylation array on 02/11/2021
#'
#' Annotation object of IlluminaMethylationAnnotation. 
#'
#' @format A tibble with several sub DataFrames:
#' \describe{
#'   \item{Locations}{probe locations}
#'   \item{Month}{dbl Month price was recorded. Ranges from 1-12 for January - December} 
#'   \item{Manifest}{Manifest information about the probes}
#'   \item{Islands.UCSC}{CpG island information}
#'   \item{Other}{other annotation}
#' }
#' @source \url{https://github.com/atomnh/IlluminaMouseMethylationanno.ilm10a1.mm10}
"IlluminaMouse1Methylationanno.ilm10a1.mm10"