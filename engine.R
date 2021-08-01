install.packages("pacman")

pacman::p_load("ggplot2")

ratings <- read.table(
  "~/Downloads/title.ratings.tsv",
  header = TRUE,
  sep = "\t",
  na.strings = "\\N",
)

filmInfos <- read.table(
  "~/Downloads/title.basics.tsv",
  header = TRUE,
  sep = "\t",
  na.strings = "\\N",
  comment.char = "",
  quote = "",
)

# We only want movies around 1h 30m - 2h 30m that were made after 1970
ctmpTitles <- filmInfos[
  filmInfos$startYear >= 1970 &
  filmInfos$runtimeMinutes >= 1.5 * 60 &
  filmInfos$runtimeMinutes <= 2.5 * 60,
]
ratedTitles <- merge(ctmpTitles, ratings)

approximateMovieMatches <- function(m, name) {
  # The name my family knows is probably the name most people know.
  # These are the only possibilities. Filter them by matches
  # with both the original and primary title that matches
  m <- m[m$primaryTitle == name,]
  
  return(
    head(
      m[
        order(
          m$primaryTitle,
          m$originalTitle,
          m$startYear
        ),
        c("tconst"),
        drop = FALSE
      ],
      1
    )
  )
}

# Attach columns for the fam's ratings to the movie's ID
rateMovie <- function(m, m_rating, j_rating, d_rating, h_rating) {
  return(
    merge(
      m,
      data.frame(
        tconst = m$tconst,
        martha = m_rating,
        john = j_rating,
        dowland = d_rating,
        hayden = h_rating
      )  
    )
  )
}

# Rates a movie by the first matching title, not an ID, and records it
rateTitle <- function(title, m_rating, j_rating, d_rating, h_rating) {
  return(
    rateMovie(
      approximateMovieMatches(ratedTitles, title),
      m_rating, j_rating, d_rating, h_rating
    )
  )
}

# Collect the fam's movie ratings
watched <- rateTitle(
  "50/50",
  8.0, 8.0, 8.0, 7.8
)
write.csv(watched, file = "db")
