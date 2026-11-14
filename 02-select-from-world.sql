-- SQL Zoo Tutorial 2: SELECT from World
-- https://sqlzoo.net/wiki/SELECT_from_WORLD_Tutorial
-- Table: world(name, continent, area, population, gdp, capital)

-- 1. Show the name, continent and population of all countries.
-- No WHERE = every row.
SELECT name, continent, population FROM world;

-- 2. Names of countries with a population of at least 200 million.
SELECT name FROM world WHERE population >= 200000000;

-- 3. Name and per capita GDP for countries with population of at least 200 million.
-- You can do math in the SELECT list. Per capita = gdp / population.
SELECT name, gdp / population AS per_capita_gdp
FROM world
WHERE population >= 200000000;

-- 4. Name and population in millions for countries in South America.
SELECT name, population / 1000000 AS population_millions
FROM world
WHERE continent = 'South America';

-- 5. Name and population for France, Germany, Italy.
SELECT name, population FROM world WHERE name IN ('France', 'Germany', 'Italy');

-- 6. Countries whose name includes the word "United".
SELECT name FROM world WHERE name LIKE '%United%';

-- 7. "Big" countries: area > 3 million sq km OR population > 250 million.
SELECT name, population, area
FROM world
WHERE area > 3000000 OR population > 250000000;

-- 8. Exclusive OR: big by area OR big by population, but not both.
-- XOR is true when exactly one side is true (MySQL supports XOR).
SELECT name, population, area
FROM world
WHERE area > 3000000 XOR population > 250000000;

-- 9. South America: population in millions and GDP in billions, 2 decimal places.
-- ROUND(x, 2) keeps two digits after the decimal point.
SELECT name,
       ROUND(population / 1000000, 2)  AS population_millions,
       ROUND(gdp / 1000000000, 2)      AS gdp_billions
FROM world
WHERE continent = 'South America';

-- 10. Per-capita GDP for "trillion dollar" economies, rounded to the nearest 1000.
-- A negative second argument rounds to the LEFT of the decimal point: -3 = nearest 1000.
SELECT name, ROUND(gdp / population, -3) AS per_capita_gdp
FROM world
WHERE gdp >= 1000000000000;

-- 11. Name and capital where the name and capital have the same number of characters.
SELECT name, capital FROM world WHERE LENGTH(name) = LENGTH(capital);

-- 12. Name and capital where the first letters match, but they aren't the same word.
-- LEFT(str, 1) takes the first character.
SELECT name, capital
FROM world
WHERE LEFT(name, 1) = LEFT(capital, 1)
  AND name <> capital;

-- 13. The country that has all the vowels and no spaces in its name.
SELECT name
FROM world
WHERE name LIKE '%a%'
  AND name LIKE '%e%'
  AND name LIKE '%i%'
  AND name LIKE '%o%'
  AND name LIKE '%u%'
  AND name NOT LIKE '% %';
