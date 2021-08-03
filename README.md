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

This graph makes it pretty evident that the data points we've gathered are very
sparse so far. If we ignore the ratings my family gives, we can see a much more
digestible view of the ratings the algorithm produces:
