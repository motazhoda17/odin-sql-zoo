-- SQL Zoo Tutorial 6: JOIN (Euro 2012)
-- https://sqlzoo.net/wiki/The_JOIN_operation
-- Tables:
--   game(id, mdate, stadium, team1, team2)
--   goal(matchid, teamid, player, gtime)      goal.matchid -> game.id
--   eteam(id, teamname, coach)                goal.teamid  -> eteam.id
-- JOIN ... ON glues rows from two tables together where the ON condition is true.

-- 1. matchid and player for every goal scored by Germany.
SELECT matchid, player FROM goal WHERE teamid = 'GER';

-- 2. id, stadium, team1, team2 for game 1012.
SELECT id, stadium, team1, team2 FROM game WHERE id = 1012;

-- 3. player, teamid, stadium and mdate for every German goal.
-- Each goal row is paired with the game row whose id equals goal.matchid.
SELECT player, teamid, stadium, mdate
FROM game
JOIN goal ON game.id = goal.matchid
WHERE teamid = 'GER';

-- 4. team1, team2 and player for every goal scored by a player called Mario.
SELECT team1, team2, player
FROM game
JOIN goal ON game.id = goal.matchid
WHERE player LIKE 'Mario%';

-- 5. player, teamid, coach, gtime for goals scored in the first 10 minutes.
SELECT player, teamid, coach, gtime
FROM goal
JOIN eteam ON goal.teamid = eteam.id
WHERE gtime <= 10;

-- 6. Dates of matches and name of team in which 'Fernando Santos' was team1 coach.
SELECT mdate, teamname
FROM game
JOIN eteam ON game.team1 = eteam.id
WHERE coach = 'Fernando Santos';

-- 7. Players who scored in games at 'National Stadium, Warsaw'.
SELECT player
FROM game
JOIN goal ON game.id = goal.matchid
WHERE stadium = 'National Stadium, Warsaw';

-- 8. Every player who scored against Germany (each name once).
-- Germany played in the game (team1 or team2) but the scorer's team was not Germany.
SELECT DISTINCT player
FROM game
JOIN goal ON goal.matchid = game.id
WHERE (team1 = 'GER' OR team2 = 'GER')
  AND teamid <> 'GER';

-- 9. Team name and total number of goals scored.
SELECT teamname, COUNT(*) AS goals
FROM eteam
JOIN goal ON eteam.id = goal.teamid
GROUP BY teamname;

-- 10. Stadium and number of goals scored in each stadium.
SELECT stadium, COUNT(*) AS goals
FROM game
JOIN goal ON game.id = goal.matchid
GROUP BY stadium;

-- 11. For every match involving Poland: matchid, date and number of goals scored.
SELECT matchid, mdate, COUNT(*) AS goals
FROM game
JOIN goal ON goal.matchid = game.id
WHERE team1 = 'POL' OR team2 = 'POL'
GROUP BY matchid, mdate;

-- 12. For every match where Germany scored: matchid, date, number of German goals.
SELECT matchid, mdate, COUNT(*) AS german_goals
FROM game
JOIN goal ON goal.matchid = game.id
WHERE teamid = 'GER'
GROUP BY matchid, mdate;

-- 13. Every match with the goals scored by each team.
-- LEFT JOIN keeps 0-0 games (games with no goal rows at all).
-- CASE turns each goal into 1 or 0 depending on which team scored; SUM adds them up.
SELECT mdate,
       team1,
       SUM(CASE WHEN teamid = team1 THEN 1 ELSE 0 END) AS score1,
       team2,
       SUM(CASE WHEN teamid = team2 THEN 1 ELSE 0 END) AS score2
FROM game
LEFT JOIN goal ON goal.matchid = game.id
GROUP BY mdate, matchid, team1, team2
ORDER BY mdate, matchid, team1, team2;
