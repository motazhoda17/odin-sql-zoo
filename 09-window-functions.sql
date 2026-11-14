-- SQL Zoo Tutorial 9: Window functions (UK general elections)
-- https://sqlzoo.net/wiki/Window_functions
-- Table: ge(yr, firstName, lastName, constituency, party, votes)
-- A window function (RANK, LAG, ...) computes a value for each row using a
-- "window" of related rows, WITHOUT collapsing the rows like GROUP BY does.

-- 1. Results for Edinburgh East (S14000024) in 2017, most votes first.
SELECT lastName, party, votes
FROM ge
WHERE constituency = 'S14000024' AND yr = 2017
ORDER BY votes DESC;

-- 2. Same constituency/year, showing each party's position with RANK().
SELECT party, votes,
       RANK() OVER (ORDER BY votes DESC) AS posn
FROM ge
WHERE constituency = 'S14000024' AND yr = 2017
ORDER BY party;

-- 3. Edinburgh East (S14000021) ranked within each year.
-- PARTITION BY restarts the ranking for each yr.
SELECT yr, party, votes,
       RANK() OVER (PARTITION BY yr ORDER BY votes DESC) AS posn
FROM ge
WHERE constituency = 'S14000021'
ORDER BY party, yr;

-- 4. Edinburgh constituencies S14000021 to S14000026 in 2017, ranked per constituency.
SELECT constituency, party, votes,
       RANK() OVER (PARTITION BY constituency ORDER BY votes DESC) AS posn
FROM ge
WHERE constituency BETWEEN 'S14000021' AND 'S14000026'
  AND yr = 2017
ORDER BY posn, constituency;

-- 5. Winning party in each of those Edinburgh constituencies in 2017.
-- You can't use a window function in WHERE, so rank in a subquery first,
-- then filter on posn = 1 outside. (The subquery needs an alias, here "ranked".)
SELECT constituency, party
FROM (
  SELECT constituency, party,
         RANK() OVER (PARTITION BY constituency ORDER BY votes DESC) AS posn
  FROM ge
  WHERE constituency BETWEEN 'S14000021' AND 'S14000026'
    AND yr = 2017
) AS ranked
WHERE posn = 1
ORDER BY constituency;

-- 6. How many seats each party won in Scotland (constituency starts with S) in 2017.
SELECT party, COUNT(*) AS seats
FROM (
  SELECT constituency, party,
         RANK() OVER (PARTITION BY constituency ORDER BY votes DESC) AS posn
  FROM ge
  WHERE constituency LIKE 'S%'
    AND yr = 2017
) AS ranked
WHERE posn = 1
GROUP BY party;
