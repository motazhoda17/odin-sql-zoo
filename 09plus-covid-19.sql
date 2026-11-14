-- SQL Zoo Tutorial 9+: COVID-19
-- https://sqlzoo.net/wiki/Window_LAG
-- Table: covid(name, whn, confirmed, deaths, recovered)   -- running totals per day
-- LAG(col, n) looks back n rows inside the window, handy for "change since yesterday".

-- 1. Spain, March 2020: day of month, confirmed, deaths, recovered.
SELECT name, DAY(whn), confirmed, deaths, recovered
FROM covid
WHERE name = 'Spain'
  AND MONTH(whn) = 3 AND YEAR(whn) = 2020
ORDER BY whn;

-- 2. Italy, March 2020: confirmed cases and the previous day's confirmed cases.
SELECT name, DAY(whn), confirmed,
       LAG(confirmed, 1) OVER (PARTITION BY name ORDER BY whn) AS dbf
FROM covid
WHERE name = 'Italy'
  AND MONTH(whn) = 3 AND YEAR(whn) = 2020
ORDER BY whn;

-- 3. Italy, March 2020: NEW cases per day (today's total - yesterday's total).
SELECT name, DAY(whn),
       confirmed - LAG(confirmed, 1) OVER (PARTITION BY name ORDER BY whn) AS new
FROM covid
WHERE name = 'Italy'
  AND MONTH(whn) = 3 AND YEAR(whn) = 2020
ORDER BY whn;

-- 4. Italy weekly figures: new cases in the last week, shown each Monday.
-- WEEKDAY(whn) = 0 means Monday. Because only Mondays are kept, LAG(…, 1) is last Monday.
SELECT name, DATE_FORMAT(whn, '%Y-%m-%d'),
       confirmed - LAG(confirmed, 1) OVER (PARTITION BY name ORDER BY whn) AS new_this_week
FROM covid
WHERE name = 'Italy'
  AND WEEKDAY(whn) = 0 AND YEAR(whn) = 2020
ORDER BY whn;

-- 5. Same weekly figures, but using a self join instead of LAG.
-- tw = "this week", lw = "last week": match rows that are exactly 1 week apart.
SELECT tw.name, DATE_FORMAT(tw.whn, '%Y-%m-%d'),
       tw.confirmed - lw.confirmed AS new_this_week
FROM covid tw
LEFT JOIN covid lw
  ON DATE_ADD(lw.whn, INTERVAL 1 WEEK) = tw.whn
 AND tw.name = lw.name
WHERE tw.name = 'Italy'
  AND WEEKDAY(tw.whn) = 0
ORDER BY tw.whn;

-- 6. Rank countries on 20 April 2020 by confirmed cases AND by deaths.
SELECT name, confirmed,
       RANK() OVER (ORDER BY confirmed DESC) AS rc,
       deaths,
       RANK() OVER (ORDER BY deaths DESC) AS rd
FROM covid
WHERE whn = '2020-04-20'
ORDER BY confirmed DESC;

-- 7. Infection rate (cases per 100,000 people) for big countries, ranked.
-- Needs the world table for population.
SELECT world.name,
       ROUND(100000 * confirmed / population, 2) AS infection_rate,
       RANK() OVER (ORDER BY confirmed / population) AS rank_
FROM covid
JOIN world ON covid.name = world.name
WHERE whn = '2020-04-20'
  AND population > 10000000
ORDER BY population DESC;

-- 8. For each country with at least 1000 new cases in a day, the date of its peak day.
-- Step 1 (innermost): new cases per day with LAG.
-- Step 2: rank each country's days by new cases.
-- Step 3: keep rank 1 with >= 1000 new cases.
-- (This is one approach; SQL Zoo's checker may want slightly different columns/order.)
SELECT name, DATE_FORMAT(whn, '%Y-%m-%d') AS peak_day, new_cases
FROM (
  SELECT name, whn, new_cases,
         RANK() OVER (PARTITION BY name ORDER BY new_cases DESC) AS rnk
  FROM (
    SELECT name, whn,
           confirmed - LAG(confirmed, 1) OVER (PARTITION BY name ORDER BY whn) AS new_cases
    FROM covid
  ) AS daily
) AS ranked
WHERE rnk = 1
  AND new_cases >= 1000
ORDER BY whn;
