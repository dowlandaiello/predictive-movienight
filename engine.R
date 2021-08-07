install.packages("pacman")

pacman::p_load("ggplot2", "magrittr", "dplyr", "data.table", "stringr", "plotly")

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
  paste(rownames(sort(table(x), decreasing=TRUE))[1:2], collapse="|")
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
  ),
  rateTitle(
    "Three Billboards Outside Ebbing, Missouri",
    c(8.0, 8.0, 8.5, 10.0)
  ),
  rateTitle(
    "Adaptation",
    c(7.0, 8.0, 8.0, 10.0)
  ),
  rateTitle(
    "Nebraska",
    c(8.0, 9.0, 8.5, 9.0)
  ),
  rateTitle(
    "The Lady in the Van",
    c(9.0, 9.0, 8.0, 8.0)
  ),
  rateTitle(
    "Four Lions",
    c(6.0, 8.5, 8.5, 8.5)
  ),
  rateTitle(
    "Baby Driver",
    c(8.0, 9.0, 8.0, 8.0)
  ),
  rateTitle(
    "Safety Not Guaranteed",
    c(7.0, 8.0, 8.0, 8.5)
  ),
  rateTitle(
    "Amélie",
    c(8.0, 8.0, 8.0, 8.0)
  ),
  rateTitle(
    "Up in the Air",
    c(6.0, 8.0, 7.0, 7.5)
  ),
  rateTitle(
    "Cinema Paradiso",
    c(8.0, 8.0, 8.5, 9.0)
  ),
  rateTitle(
    "The Big Lebowski",
    c(9.0, 9.0, 9.0, 9.0)
  ),
  rateTitle(
    "Spy",
    c(8.0, 9.0, 8.5, 8.5)
  ),
  rateTitle(
    "Shaun of the Dead",
    c(9.0, 9.0, 9.5, 9.0)
  ),
  rateTitle(
    "Hot Fuzz",
    c(8.0, 8.5, 8.5, 9.0)
  ),
  rateTitle(
    "The World's End",
    c(5.0, 8.0, 8.0, 8.0)
  ),
  rateTitle(
    "Mission: Impossible - Fallout",
    c(7.0, 9.0, 8.5, 8.5)
  ),
  rateTitle(
    "Mission: Impossible - Rogue Nation",
    c(7.0, 9.0, 8.5, 8.5)
  ),
  rateTitle(
    "Mission: Impossible - Ghost Protocol",
    c(7.0, 9.0, 8.5, 8.5)
  ),
  rateTitle(
    "Game Night",
    c(7.0, 8.5, 8.5, 8.5)
  ),
  rateTitle(
    "The Shawshank Redemption",
    c(8.0, 9.0, 9.5, 9.5)
  ),
  rateTitle(
    "Chef",
    c(9.0, 9.0, 8.0, 9.0)
  ),
  rateTitle(
    "Starsky & Hutch",
    c(8.0, 9.0, 8.0, 8.0)
  ),
  rateTitle(
    "Borat: Cultural Learnings of America for Make Benefit Glorious Nation of Kazakhstan",
    c(6.0, 9.0, 9.0, 9.5)
  ),
  rateTitle(
    "Borat Subsequent Moviefilm",
    c(6.0, 9.0, 9.0, 9.5)
  ),
  rateTitle(
    "What We Do in the Shadows",
    c(6.0, 8.0, 8.0, 8.5)
  ),
  rateTitle(
    "The Big Sick",
    c(7.0, 9.0, 9.0, 8.5)
  ),
  rateTitle(
    "Raising Arizona",
    c(7.0, 7.0, 7.5, 8.0)
  ),
  rateTitle(
    "The Nice Guys",
    c(7.0, 8.0, 8.0, 8.5)
  ),
  rateTitle(
    "Pineapple Express",
    c(7.0, 8.0, 8.0, 6.5)
  ),
  rateTitle(
    "Best in Show",
    c(7.0, 8.5, 8.0, 9.0)
  ),
  rateTitle(
    "Fantastic Mr. Fox",
    c(8.0, 8.0, 8.0, 9.5)
  ),
  rateTitle(
    "Fargo",
    c(7.0, 8.0, 8.0, 8.5)
  ),
  rateTitle(
    "Midnight in Paris",
    c(9.0, 9.0, 8.0, 8.0)
  ),
  rateTitle(
    "Meet the Parents",
    c(8.0, 8.0, 8.0, 8.0)
  ),
  rateTitle(
    "Django Unchained",
    c(8.0, 8.0, 9.5, 9.5)
  ),
  rateTitle(
    "Superbad",
    c(9.0, 10.0, 9.5, 9.5)
  ),
  rateTitle(
    "The Sapphires",
    c(9.0, 9.0, 8.0, 8.5)
  ),
  rateTitle(
    "The Godfather",
    c(6.0, 7.0, 7.5, 10.0)
  ),
  rateTitle(
    "Rango",
    c(9.0, 9.0, 8.0, 9.0)
  ),
  rateTitle(
    "Goodfellas",
    c(7.0, 7.0, 8.0, 9.0)
  ),
  rateTitle(
    "The Score",
    c(8.0, 8.0, 7.5, 7.0)
  ),
  rateTitle(
    "In Bruges",
    c(9.0, 9.0, 8.0, 9.0)
  ),
  rateTitle(
    "The Martian",
    c(7.0, 9.0, 8.5, 8.0)
  ),
  rateTitle(
    "Interstellar",
    c(6.0, 7.0, 7.5, 9.0)
  ),
  rateTitle(
    "Robot & Frank",
    c(9.0, 9.0, 8.5, 9.0)
  ),
  rateTitle(
    "Mars Attacks!",
    c(7.0, 8.0, 8.0, 6.0)
  ),
  rateTitle(
    "Bandits",
    c(9.0, 9.0, 8.0, 8.0)
  ),
  rateTitle(
    "The Social Network",
    c(7.0, 7.0, 7.5, 8.0)
  ),
  rateTitle(
    "Paddleton",
    c(9.0, 9.0, 8.5, 9.0)
  ),
  rateTitle(
    "Paddington 2",
    c(9.0, 9.0, 9.5, 9.5)
  ),
  rateTitle(
    "Jojo Rabbit",
    c(9.5, 9.5, 9.0, 9.5)
  ),
  rateTitle(
    "Hunt for the Wilderpeople",
    c(8.0, 8.5, 8.5, 8.5)
  ),
  rateTitle(
    "Hearts Beat Loud",
    c(9.0, 9.0, 7.5, 8.0)
  ),
  rateTitle(
    "Music and Lyrics",
    c(7.5, 7.5, 6.5, 6.5)
  ),
  rateTitle(
    "Sing Street",
    c(9.0, 9.0, 8.5, 9.0)
  ),
  rateTitle(
    "Once",
    c(9.0, 9.0, 8.0, 8.0)
  ),
  rateTitle(
    "City Island",
    c(9.0, 9.5, 9.0, 9.5)
  ),
  rateTitle(
    "O Brother, Where Art Thou?",
    c(9.0, 9.0, 9.0, 9.0)
  )
)

write.csv(watched, file = "db")
 
# Include the above fields for the family's ratings
watchedContext <- watched %>%
  merge(
    ratedTitles,
    by = "tconst",
    all.x = TRUE,
  ) %>%
  select(tconst, familyRating, averageRating, genres, directors, writers, numVotes)

watched <- watchedContext %>%
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
context <- ratedTitles %>%
  mutate(
    tasteRelevance = 3 ** (
      str_count(genres, ideal$genres) +
      str_count(directors, ideal$directors) +
      str_count(writers, ideal$writers)
    ),
    audienceFactor = (
      log10(numVotes ** (1/5)) *
      averageRating
    ),
    score = (
      tasteRelevance + audienceFactor
    )
  )
context[grep("Comedy", genres)]$score =
  context[grep("Comedy", genres)]$score * 1.5

context <- context %>% arrange(desc(score))

# Differentiate between our and their ratings so we can highlight them on the
# chart
ourRatings <- context %>%
  filter(tconst %in% watched$tconst)
bestMovies <- context %>%
  filter(!(tconst %in% watched$tconst) & (titleType != "tvEpisode"))

# Graph the distribution of movies that appeal to our tastes!
summaryBestMovies <- bestMovies[bestMovies %>% nrow %>% sample(50)] %>%
  plot_ly(x = ~tasteRelevance, y = ~audienceFactor, z = ~score,
          type = "scatter3d", mode = "markers") %>%
  add_markers(x = ~ourRatings$tasteRelevance, y = ~ourRatings$audienceFactor,
              z = ~ourRatings$score)
summaryBestMovies 

# bestMovies %>% head(200) %>% write.csv(file = "res")