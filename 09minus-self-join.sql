-- SQL Zoo Tutorial 9-: Self join (Edinburgh buses)
-- https://sqlzoo.net/wiki/Self_join
-- Tables:
--   stops(id, name)
--   route(num, company, pos, stop)    a bus (company + num) visits stop at position pos
-- A SELF JOIN joins a table to itself using two aliases (a and b) so we can
-- compare two rows of the same table, e.g. two stops on the same bus route.

-- 1. How many stops are there?
SELECT COUNT(*) FROM stops;

-- 2. The id of the stop 'Craiglockhart'.
SELECT id FROM stops WHERE name = 'Craiglockhart';

-- 3. id and name of the stops on the '4' 'LRT' service, in route order.
SELECT id, name
FROM stops
JOIN route ON stops.id = route.stop
WHERE num = '4' AND company = 'LRT'
ORDER BY pos;

-- 4. Services that visit both stop 53 (London Road) and 149 (Craiglockhart).
-- Count how many of the two stops each service hits; keep those with both.
SELECT company, num, COUNT(*)
FROM route
WHERE stop = 149 OR stop = 53
GROUP BY company, num
HAVING COUNT(*) = 2;

-- 5. Self join: services from Craiglockhart (53) to London Road (149).
-- a and b are the SAME bus (same company + num) at two different stops.
SELECT a.company, a.num, a.stop, b.stop
FROM route a
JOIN route b ON a.company = b.company AND a.num = b.num
WHERE a.stop = 53
  AND b.stop = 149;

-- 6. Same as 5, but show stop NAMES instead of ids.
SELECT a.company, a.num, stopa.name, stopb.name
FROM route a
JOIN route b     ON a.company = b.company AND a.num = b.num
JOIN stops stopa ON a.stop = stopa.id
JOIN stops stopb ON b.stop = stopb.id
WHERE stopa.name = 'Craiglockhart'
  AND stopb.name = 'London Road';

-- 7. Services that connect stops 115 (Haymarket) and 137 (Leith).
SELECT DISTINCT a.company, a.num
FROM route a
JOIN route b ON a.company = b.company AND a.num = b.num
WHERE a.stop = 115
  AND b.stop = 137;

-- 8. Services that connect 'Craiglockhart' and 'Tollcross'.
SELECT DISTINCT a.company, a.num
FROM route a
JOIN route b     ON a.company = b.company AND a.num = b.num
JOIN stops stopa ON a.stop = stopa.id
JOIN stops stopb ON b.stop = stopb.id
WHERE stopa.name = 'Craiglockhart'
  AND stopb.name = 'Tollcross';

-- 9. Every stop reachable from Craiglockhart with ONE LRT bus (stop name, company, num).
SELECT DISTINCT stopb.name, a.company, a.num
FROM route a
JOIN route b     ON a.company = b.company AND a.num = b.num
JOIN stops stopa ON a.stop = stopa.id
JOIN stops stopb ON b.stop = stopb.id
WHERE stopa.name = 'Craiglockhart'
  AND a.company = 'LRT';

-- 10. Two-bus trips from Craiglockhart to Lochend.
-- bus1 = every stop you can reach from Craiglockhart on one bus.
-- bus2 = every stop from which one bus takes you to Lochend.
-- Where bus1's stop equals bus2's stop, you can change buses there ("transfer").
SELECT DISTINCT bus1.num, bus1.company, transfer.name, bus2.num, bus2.company
FROM (
  SELECT a.num, a.company, b.stop
  FROM route a
  JOIN route b ON a.num = b.num AND a.company = b.company
  WHERE a.stop = (SELECT id FROM stops WHERE name = 'Craiglockhart')
) AS bus1
JOIN (
  SELECT c.num, c.company, c.stop
  FROM route c
  JOIN route d ON c.num = d.num AND c.company = d.company
  WHERE d.stop = (SELECT id FROM stops WHERE name = 'Lochend')
) AS bus2 ON bus1.stop = bus2.stop
JOIN stops transfer ON transfer.id = bus1.stop
ORDER BY bus1.num, transfer.name, bus2.num;
