install.packages("pacman")

pacman::p_load("ggplot2", "magrittr", "dplyr", "data.table", "stringr")

# John always goes first
RATING_WEIGHTS <- c(0.475, 0.275, 0.125, 0.125)

# Don't want to over fit
SIGNIFICANT_ATTRIBUTES <- c("averageRating", "genres", "directors", "writers")

ratings <- as.data.table(read.table(
  "~/Downloads/title.ratings.tsv",
  header = TRUE,
  sep = "\t",
  na.strings = "\\N",
))

filmInfos <- read.table(
  "~/Downloads/title.basics.tsv",
  header = TRUE,
  sep = "\t",
  na.strings = "\\N",
  comment.char = "",
  quote = "",
) %>%
  as.data.table

castInfos <- read.table(
  "~/Downloads/title.crew.tsv",
  header = TRUE,
  sep = "\t",
  na.strings = "\\N",
  comment.char = "",
  quote = "",
) %>%
  as.data.table

# We only want movies around 1h 30m - 2h 30m that were made after 1970
ctmpTitles <- filmInfos[
  startYear >= 1970 &
  runtimeMinutes >= 1.5 * 60 &
  runtimeMinutes <= 2.5 * 60,
]
ratedTitles <- merge(ctmpTitles, ratings) %>%
  merge(castInfos)

approximateMovieMatches <- function(m, name) {
  # The name my family knows is probably the name most people know.
  # These are the only possibilities. Filter them by matches
  # with both the original and primary title that matches.
  m[primaryTitle == name,] %>%
    # Then, sort them by the closest matching second title
    mutate(
      titleDiff = (originalTitle == name)
    ) %>%
    .[order(titleDiff, numVotes, decreasing = TRUE), .(tconst)] %>%
    head(1)
}

# Rates a movie by the first matching title, not an ID, and records it
rateTitle <- function(title, ratings) {
  approximateMovieMatches(ratedTitles, title) %>%
    mutate(familyRating = weighted.mean(ratings, RATING_WEIGHTS))
}

mode <- function(x) {
  if (is.vector(x)) {
    x <- unlist(x)
  }
  
  u <- unique(x)
  
  # Get the two most frequent values
  paste(
    u[sort(tabulate(match(x, u)), decreasing = TRUE)[1:2]],
    collapse = "|"
  )
}

# Collect the fam's movie ratings
watched <- rbind(
  rateTitle(
    "50/50",
    c(8.0, 8.0, 8.0, 7.8)
  ),
  rateTitle(
    "The Imitation Game",
    c(9.0, 9.0, 9.0, 9.0)
  )
)

write.csv(watched, file = "db")
 
# Include the above fields for the family's ratings
watched <- watched %>%
  merge(
    ratedTitles,
    by = "tconst",
    all.x = TRUE,
  ) %>%
  select(tconst, familyRating, averageRating, genres, directors, writers) %>%
  # Consolidate family ratings and IMDB ratings. TODO: This should be weighted
  # more for family in the future
  mutate(
    averageRating = rowMeans(select(., averageRating, familyRating))
  ) %>%
  # No reason for extra columns
  select(-c(familyRating)) %>%
  arrange(desc(averageRating))

# The IDEAL movie
ideal <- watched %>%
  select(genres, directors, writers) %>%
  summarise(
    genres = mode(strsplit(genres, ",")),
    directors = mode(strsplit(directors, ",")),
    writers = mode(strsplit(writers, ","))
  )

# Movies are only eligible if they have at least one genre in common
bestMovies <- ratedTitles %>%
  mutate(score =
           2 ** (
              str_count(genres, ideal$genres) +
              str_count(directors, ideal$directors) +
              str_count(writers, ideal$writers)
           ) +
           (
              log10(numVotes ** (1/5)) *
              averageRating
           )
         ) %>%
  arrange(desc(score)) %>%
  filter(!(tconst %in% watched$tconst) & (titleType != "tvEpisode"))

bestMovies %>% head(200) %>% write.csv(file = "res")