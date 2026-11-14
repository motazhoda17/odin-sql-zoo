-- SQL Zoo Tutorial 4: SELECT within SELECT
-- https://sqlzoo.net/wiki/SELECT_within_SELECT_Tutorial
-- Table: world(name, continent, area, population, gdp)
-- A subquery is a SELECT inside another SELECT. It runs first and its result
-- is used like a value (or a list of values) by the outer query.

-- 1. Countries with a population larger than Russia.
SELECT name
FROM world
WHERE population > (SELECT population FROM world WHERE name = 'Russia');

-- 2. European countries with a per capita GDP greater than the United Kingdom.
SELECT name
FROM world
WHERE continent = 'Europe'
  AND gdp / population > (SELECT gdp / population FROM world WHERE name = 'United Kingdom');

-- 3. Name and continent of countries in the same continents as Argentina or Australia.
-- The subquery returns a LIST of continents, so we use IN instead of =.
SELECT name, continent
FROM world
WHERE continent IN (SELECT continent FROM world WHERE name IN ('Argentina', 'Australia'))
ORDER BY name;

-- 4. Countries more populous than the UK but less populous than Germany.
SELECT name, population
FROM world
WHERE population > (SELECT population FROM world WHERE name = 'United Kingdom')
  AND population < (SELECT population FROM world WHERE name = 'Germany');

-- 5. Each European country's population as a percentage of Germany's (e.g. "3%").
-- ROUND gives a whole number; CONCAT adds the % sign.
SELECT name,
       CONCAT(ROUND(100 * population / (SELECT population FROM world WHERE name = 'Germany')), '%') AS percentage
FROM world
WHERE continent = 'Europe';

-- 6. Countries with a GDP greater than every country in Europe.
-- > ALL(list) means "bigger than every value in the list".
-- gdp > 0 removes NULLs, which would otherwise make ALL fail.
SELECT name
FROM world
WHERE gdp > ALL (SELECT gdp FROM world WHERE continent = 'Europe' AND gdp > 0);

-- 7. The largest country (by area) in each continent.
-- This is a CORRELATED subquery: the inner query refers to x (the outer row),
-- so it runs once per outer row, comparing it only to countries on the same continent.
SELECT continent, name, area
FROM world x
WHERE area >= ALL (SELECT area FROM world y WHERE y.continent = x.continent AND area > 0);

-- 8. Each continent and the country that comes first alphabetically.
SELECT continent, name
FROM world x
WHERE name <= ALL (SELECT name FROM world y WHERE y.continent = x.continent);

-- 9. Continents where ALL countries have a population <= 25,000,000.
--    Show name, continent and population of those countries.
SELECT name, continent, population
FROM world x
WHERE 25000000 >= ALL (SELECT population FROM world y WHERE y.continent = x.continent AND population > 0);

-- 10. Countries with more than three times the population of every neighbour
--     (every other country on the same continent).
-- y.name <> x.name stops a country being compared with itself.
SELECT name, continent
FROM world x
WHERE population > ALL (
  SELECT population * 3
  FROM world y
  WHERE y.continent = x.continent
    AND y.name <> x.name
);
