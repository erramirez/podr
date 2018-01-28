#' Given a podcast rss feed, this function will return a data frame
#' that contains the data contained in the <item> node.
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
#' If the feed link is broken, or entered incorrectly, you will get an error
#' indicating "xmlParseEntityRef: no name". Please check your feed link.
#'
#' @param feed A rss link
#' @return the episode data contained in \code{feed}
#' @return will also append pocast title to each episode in variable 'podtitle'
#'
#'
#' @import xml2
#' @import tidyverse
#'
#'
#' @examples
#' readpod("http://thornmorris.libsyn.com/rss")
#' readpod("http://feeds.feedburner.com/stoppodcastingyourself")

readpod <- function(x, y) {
  doc <- read_xml(x)
  podtitle <- xml_find_first(doc, "//channel//title") %>%
    xml_text()
  nodes <- xml_find_all(doc, ".//item")
  df <- map_df(nodes, function(x) {
    kids <- xml_children(x)
    setNames(as.list(as.character(type.convert(xml_text(kids)))), xml_name(kids))
  }) %>%
    mutate(podtitle = as.factor(podtitle))
  df
}
