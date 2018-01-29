#' Given a podcast data frame created with readpod, this function will return
#' a data frame that contains four variables:
#' #' \enumerate{
#'   \item podtitle (podcast title)
#'   \item title (episode title)
#'   \item date (publish date)
#'   \item showlength (show length in seconds)
#' }
#'
#' @note Every podcast feed is not created equally and some feeds may
#' be missing data. Be on the lookout for the following issues:
#' \itemize{
#'   \item episode as announcement == duration of 00 or NA
#'   \item duration not entered in <itunes:duration> results in empty character
#'   vector
#'   \item episode durations in <itunes:duration> may be in HH:MM:SS and
#'   some may be in H:MM:SS, and still others in just MM:SS. This function should
#'   be able to handle each.
#'   \item duplication of episodes in the feed
#' }
#'
#'
#' @param dfreadpod a data frame created with readpod
#' @return cleaned episode data contained in \code{dfreadpod}
#'
#' @import dplyr
#' @import magrittr
#' @importFrom purrr map map_df map_chr
#' @importFrom lubridate dmy hms
#' @importFrom stringr str_split
#' @importFrom graphics title
#' @importFrom stats setNames
#' @importFrom utils type.convert
#'
#' @export
#' 
#' @examples {
#' jjgo <- readpod("http://thornmorris.libsyn.com/rss")
#' jjgoclean <- cleanpod(jjgo)
#' }

cleanpod <- function(dfreadpod) {
  df2 <- dfreadpod %>%
    mutate(day = pubDate %>%
             map(str_split, pattern = " ") %>%
             map_chr(c(1,2)),
           month = pubDate %>%
             map(str_split, pattern = " ") %>%
             map_chr(c(1,3)),
           year = pubDate %>%
             map(str_split, pattern = " ") %>%
             map_chr(c(1,4)),
           date = dmy(paste(day, month, year, sep= "")),
           hms = ifelse(is.na(suppressWarnings(hms(duration))), 0, 1),
           showlengthminutes = ifelse(hms == 1,
                                      sapply(strsplit(as.character(duration),":"),
                                             function(x) {
                                               x <- as.numeric(x)
                                               x[1]*60+x[2]+x[3]/60
                                             }
                                      ),
                                      sapply(strsplit(as.character(duration),":"),
                                             function(x) {
                                               x <- as.numeric(x)
                                               x[1]+x[2]/60
                                             }
                                      )
           ),
           showlength = showlengthminutes*60
    ) %>%
    select(podtitle, title, date, showlength)
  df2
}
