-- SQL Zoo Tutorial 0: SELECT basics
-- https://sqlzoo.net/wiki/SELECT_basics
-- Table: world(name, continent, area, population, gdp)

-- 1. Show the population of Germany.
-- WHERE filters rows; only the row whose name is exactly 'Germany' is kept.
SELECT population
FROM world
WHERE name = 'Germany';

-- 2. Show the name and population for Sweden, Norway and Denmark.
-- IN is a shorter way to write name = 'a' OR name = 'b' OR name = 'c'.
SELECT name, population
FROM world
WHERE name IN ('Sweden', 'Norway', 'Denmark');

-- 3. Which countries are not too small and not too big?
--    Show the country and area for countries with an area between 200,000 and 250,000.
-- BETWEEN is inclusive: it includes both 200000 and 250000.
SELECT name, area
FROM world
WHERE area BETWEEN 200000 AND 250000;
