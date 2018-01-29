
`podr` is a very simple package containing two functions for reading and cleaning data from a podcast feed.

Installation
------------

``` r
devtools::install_github("erramirez/podr")
```

Key Functions
-------------

`podr` is primarily composed of two functions:

1.  The first function, `readpod`, will extract relevant information from a podcast feed according to the information available within the **item** node. Additionally, it will read and append the podcast title according to what is present in **channel/title**.
2.  The second function, `cleapod`, will read a data frame created with `readpod` and reduce to a tibble with four variables:
    -   podtitle: the title of the podcast
    -   title: the episdoe title
    -   date: the date the episode was published
    -   showlength: the duration of the podcast in seconds

`cleanpod` is primarily used to clean up the date and duration information in a podcast feed in order to make it computable.

Usage
-----

Let't say you were really interested in learning how much time you spent listening to your favorite podcast, *Jordan, Jesse Go!*, in 2017.

First we would use `readpod` to read the podcast feed.

``` r
library(podr)

jjgo <- readpod("http://thornmorris.libsyn.com/rss")

jjgo
```

    ## # A tibble: 528 x 14
    ##    title  pubDate guid  link  image description encoded enclosure duration
    ##    <chr>  <chr>   <chr> <chr> <chr> <chr>       <chr>   <chr>     <chr>   
    ##  1 Ep. 5… Tue, 2… 4907… http… ""    "<p>Jordan… "<p>Jo… ""        01:13:35
    ##  2 Ep. 5… Tue, 1… 593e… http… ""    "<p>Jordan… "<p>Jo… ""        01:22:55
    ##  3 Ep. 5… Tue, 0… 7f52… http… ""    <p>Eliza S… <p>Eli… ""        01:24:50
    ##  4 Ep. 5… Tue, 0… 8b79… http… ""    <p>Live fr… <p>Liv… ""        01:42:59
    ##  5 Ep. 5… Tue, 1… e9bf… http… ""    "<p class=… "<p cl… ""        01:00:31
    ##  6 Ep. 5… Tue, 1… 868a… http… ""    <p>Comedia… <p>Com… ""        01:26:16
    ##  7 Ep. 5… Tue, 0… a0a8… http… ""    "<p>Comedi… <p>Com… ""        01:17:34
    ##  8 Ep. 5… Tue, 2… e349… http… ""    <p>Fan fav… <p>Fan… ""        01:08:55
    ##  9 Ep. 5… Tue, 2… 3322… http… ""    <p>Interna… <p>Int… ""        01:04:24
    ## 10 Ep. 5… Tue, 1… dbe9… http… ""    "<p>Jordan… <p>Jor… ""        01:19:09
    ## # ... with 518 more rows, and 5 more variables: explicit <chr>,
    ## #   keywords <chr>, subtitle <chr>, episodeType <chr>, podtitle <fct>

We can then use `cleanpod` to clean up the podcast data to something usable to answer our question.

``` r
jjgoclean <- cleanpod(jjgo)

jjgoclean
```

    ## # A tibble: 528 x 4
    ##    podtitle          title                           date       showlength
    ##    <fct>             <chr>                           <date>          <dbl>
    ##  1 Jordan, Jesse GO! Ep. 515: Catillion with Haley … 2018-01-23       4415
    ##  2 Jordan, Jesse GO! Ep. 514: Tree Bees with Kevin … 2018-01-16       4975
    ##  3 Jordan, Jesse GO! Ep. 513: Martinelli Toots with… 2018-01-09       5090
    ##  4 Jordan, Jesse GO! Ep. 512: Live in London with N… 2018-01-02       6179
    ##  5 Jordan, Jesse GO! Ep. 511: Bunny Shy with Elizab… 2017-12-19       3631
    ##  6 Jordan, Jesse GO! Ep. 510: Hammerstice with Josh… 2017-12-12       5176
    ##  7 Jordan, Jesse GO! Ep. 509: Hand to Hand to Mouth… 2017-12-05       4654
    ##  8 Jordan, Jesse GO! Ep. 508: Wide Dumper with Chri… 2017-11-28       4135
    ##  9 Jordan, Jesse GO! Ep. 507: Gooble Gooble with Jo… 2017-11-21       3864
    ## 10 Jordan, Jesse GO! Ep. 506: The Sensitive Man in … 2017-11-14       4749
    ## # ... with 518 more rows

Now that we have a cleaned data set that contains all the relevant information we can use a few simple tidy tools.

``` r
library(tidyverse)
library(lubridate)

jjgoclean2k17 <- jjgoclean %>% 
  filter(date > "2016-12-31" & date < "2018-01-01")

#find the total duration of Jordan, Jesse GO! in seconds
sum(jjgoclean2k17$showlength)
```

    ## [1] 240727

``` r
#find the total as a period 
seconds_to_period(sum(jjgoclean2k17$showlength))
```

    ## [1] "2d 18H 52M 7S"

So there you have it. You can use `podr` to find out *Jordan, Jesse GO!* put out **2d 18H 52M 7S** of hilarious shows in 2017.

Note
----

Please feel free to share issues, notes, and ideas. This is my first public R package and I'd love to learn from you.

*made with RStudio and* ❤️ *in* ☀️ *Los Angeles*
