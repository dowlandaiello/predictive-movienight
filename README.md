# predictive-movienight
My brother and I aren't that great at picking movies. I decided to fix that!

## What is this?

Basically, every Friday night, my family watches a movie. My brother and I often
have difficulty picking one, so I wrote this R script to automate the process of
looking through IMDB, weighing the genres, their appeal to my parents, and etc.

This script allows you to input the ratings of individual family members, with
weights, for movies you've seen. Then, based on the genres, cast, writers, etc
of that movie, it will filter and rank IMDB's database of movies for you to
peruse. NOTE: The script itself isn't very modular at this point, and it has
MANY hard-coded constants that I'll remove soon.

## How has it worked so far?

Well, I don't have many datapoints from my family yet, since we've only watched
2 movies since I started working on this script (but not since I completed it).
For what it's worth, I've graphed the results of the algorithm I use to rank
movies against the ratings our family gave movies we've watched. Take a look:

![Movies our family has watched Vs IMDB database](./.github/media/our_ratings_vs_predictions_all.png)

This graph makes it pretty evident that the data points we've gathered are very
sparse so far. If we ignore the ratings my family gives, we can see a much more
digestible view of the ratings the algorithm produces:

![All IMDB movies vs Predicted Ratings](./.github/media/all_imdb.png)

Here, we can see the clear distinction between movies who have a high appeal to
my family's interests (i.e., genres, writers, directors, cast, etc), which have
an immediate leg up, and movies that get on the charts by simply being popular
and highly acclaimed.

## Usage

Using this R script is relatively convoluted at the moment. However, its results
are easy to interpret: a CSV file of the top 200 IMDB movies, ranked by their
combined audience score and taste relevance. The results will look like
this:

```
      tconst        primaryTitle startYear                 genres averageRating    score
1: tt0099685          Goodfellas      1990  Biography,Crime,Drama           8.7 19.48013
2: tt1675434    The Intouchables      2011 Biography,Comedy,Drama           8.5 19.02272
3: tt0253474         The Pianist      2002  Biography,Drama,Music           8.5 18.99665
4: tt0268978    A Beautiful Mind      2001        Biography,Drama           8.2 18.74277
5: tt0264464 Catch Me If You Can      2002  Biography,Crime,Drama           8.1 18.62060
```
