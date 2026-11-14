-- SQL Zoo Tutorial 7: More JOIN operations (movies)
-- https://sqlzoo.net/wiki/More_JOIN_operations
-- Tables:
--   movie(id, title, yr, director, budget, gross)
--   actor(id, name)
--   casting(movieid, actorid, ord)   ord = position in the credits (1 = star)
-- casting is a "join table": it links many movies to many actors.

-- 1. id and title of 1962 movies.
SELECT id, title FROM movie WHERE yr = 1962;

-- 2. Year of 'Citizen Kane'.
SELECT yr FROM movie WHERE title = 'Citizen Kane';

-- 3. All Star Trek movies (id, title, yr), ordered by year.
SELECT id, title, yr FROM movie WHERE title LIKE '%Star Trek%' ORDER BY yr;

-- 4. id of actor 'Glenn Close'.
SELECT id FROM actor WHERE name = 'Glenn Close';

-- 5. id of the film 'Casablanca'.
SELECT id FROM movie WHERE title = 'Casablanca';

-- 6. Cast list for 'Casablanca'.
-- Using a subquery means we don't have to hard-code the id from question 5.
SELECT name
FROM casting
JOIN actor ON casting.actorid = actor.id
WHERE movieid = (SELECT id FROM movie WHERE title = 'Casablanca');

-- 7. Cast list for 'Alien'.
SELECT name
FROM casting
JOIN actor ON casting.actorid = actor.id
WHERE movieid = (SELECT id FROM movie WHERE title = 'Alien');

-- 8. Films in which 'Harrison Ford' has appeared.
-- Three tables: movie <- casting -> actor.
SELECT title
FROM movie
JOIN casting ON movie.id = casting.movieid
JOIN actor   ON casting.actorid = actor.id
WHERE name = 'Harrison Ford';

-- 9. Films where Harrison Ford appeared but NOT in the starring role.
SELECT title
FROM movie
JOIN casting ON movie.id = casting.movieid
JOIN actor   ON casting.actorid = actor.id
WHERE name = 'Harrison Ford'
  AND ord <> 1;

-- 10. Films and leading star for all 1962 films.
SELECT title, name
FROM movie
JOIN casting ON movie.id = casting.movieid
JOIN actor   ON casting.actorid = actor.id
WHERE yr = 1962
  AND ord = 1;

-- 11. Busiest years for 'Rock Hudson': years with more than 2 movies.
SELECT yr, COUNT(title) AS movies
FROM movie
JOIN casting ON movie.id = casting.movieid
JOIN actor   ON casting.actorid = actor.id
WHERE name = 'Rock Hudson'
GROUP BY yr
HAVING COUNT(title) > 2;

-- 12. Film title and leading actor for every film Julie Andrews played in.
-- Inner subquery: Julie's movie ids. Outer query: for those movies, the ord = 1 actor.
SELECT title, name
FROM movie
JOIN casting ON movie.id = casting.movieid AND ord = 1
JOIN actor   ON casting.actorid = actor.id
WHERE movie.id IN (
  SELECT movieid FROM casting
  WHERE actorid IN (SELECT id FROM actor WHERE name = 'Julie Andrews')
);

-- 13. Actors (alphabetical) who have had at least 15 starring roles.
SELECT name
FROM actor
JOIN casting ON actor.id = casting.actorid
WHERE ord = 1
GROUP BY name
HAVING COUNT(*) >= 15
ORDER BY name;

-- 14. 1978 films ordered by number of actors in the cast, then by title.
SELECT title, COUNT(actorid) AS cast_size
FROM movie
JOIN casting ON movie.id = casting.movieid
WHERE yr = 1978
GROUP BY title
ORDER BY cast_size DESC, title;

-- 15. Everyone who has worked with 'Art Garfunkel'.
SELECT DISTINCT name
FROM actor
JOIN casting ON actor.id = casting.actorid
WHERE movieid IN (
  SELECT movieid FROM casting
  JOIN actor ON actor.id = casting.actorid
  WHERE name = 'Art Garfunkel'
)
  AND name <> 'Art Garfunkel';
