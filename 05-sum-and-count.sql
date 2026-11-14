-- SQL Zoo Tutorial 5: SUM and COUNT
-- https://sqlzoo.net/wiki/SUM_and_COUNT
-- Table: world(name, continent, area, population, gdp)
-- Aggregate functions (SUM, COUNT, MAX, AVG...) squash many rows into one value.
-- GROUP BY makes one result row per group instead of one for the whole table.

-- 1. Total population of the world.
SELECT SUM(population) FROM world;

-- 2. List all the continents, just once each.
SELECT DISTINCT continent FROM world;

-- 3. Total GDP of Africa.
SELECT SUM(gdp) FROM world WHERE continent = 'Africa';

-- 4. How many countries have an area of at least 1,000,000?
SELECT COUNT(name) FROM world WHERE area >= 1000000;

-- 5. Total population of Estonia, Latvia and Lithuania.
SELECT SUM(population) FROM world WHERE name IN ('Estonia', 'Latvia', 'Lithuania');

-- 6. For each continent, the number of countries.
SELECT continent, COUNT(name)
FROM world
GROUP BY continent;

-- 7. For each continent, the number of countries with population of at least 10 million.
-- WHERE filters rows BEFORE grouping.
SELECT continent, COUNT(name)
FROM world
WHERE population >= 10000000
GROUP BY continent;

-- 8. Continents with a total population of at least 100 million.
-- HAVING filters GROUPS AFTER grouping (you can't use SUM() in a WHERE).
SELECT continent
FROM world
GROUP BY continent
HAVING SUM(population) >= 100000000;
