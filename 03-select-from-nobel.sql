-- SQL Zoo Tutorial 3: SELECT from Nobel
-- https://sqlzoo.net/wiki/SELECT_from_Nobel_Tutorial
-- Table: nobel(yr, subject, winner)

-- 1. Nobel prizes for 1950.
SELECT yr, subject, winner FROM nobel WHERE yr = 1950;

-- 2. Who won the 1962 prize for literature?
SELECT winner FROM nobel WHERE yr = 1962 AND subject = 'literature';

-- 3. Year and subject that won 'Albert Einstein' his prize.
SELECT yr, subject FROM nobel WHERE winner = 'Albert Einstein';

-- 4. Names of peace prize winners since the year 2000, including 2000.
SELECT winner FROM nobel WHERE subject = 'peace' AND yr >= 2000;

-- 5. All details of literature prize winners for 1980 to 1989 inclusive.
SELECT * FROM nobel WHERE subject = 'literature' AND yr BETWEEN 1980 AND 1989;

-- 6. All details of these presidential winners.
SELECT *
FROM nobel
WHERE winner IN ('Theodore Roosevelt', 'Woodrow Wilson', 'Jimmy Carter', 'Barack Obama');

-- 7. Winners with first name John.
SELECT winner FROM nobel WHERE winner LIKE 'John%';

-- 8. Physics winners for 1980 together with chemistry winners for 1984.
-- Parentheses group each (subject AND year) pair, then OR combines the two pairs.
SELECT yr, subject, winner
FROM nobel
WHERE (subject = 'physics' AND yr = 1980)
   OR (subject = 'chemistry' AND yr = 1984);

-- 9. Winners for 1980 excluding chemistry and medicine.
SELECT yr, subject, winner
FROM nobel
WHERE yr = 1980 AND subject NOT IN ('chemistry', 'medicine');

-- 10. Early medicine (before 1910) together with late literature (2004 onwards).
SELECT yr, subject, winner
FROM nobel
WHERE (subject = 'medicine' AND yr < 1910)
   OR (subject = 'literature' AND yr >= 2004);

-- 11. All details of the prize won by PETER GRÜNBERG (non-ASCII character).
-- Just type the Ü; string comparison in MySQL is case-insensitive by default.
SELECT * FROM nobel WHERE winner = 'PETER GRÜNBERG';

-- 12. All details of the prize won by EUGENE O'NEILL.
-- A single quote inside a string is escaped by doubling it: ''
SELECT * FROM nobel WHERE winner = 'EUGENE O''NEILL';

-- 13. Winners whose name starts with Sir, most recent first, then by name.
SELECT winner, yr, subject
FROM nobel
WHERE winner LIKE 'Sir%'
ORDER BY yr DESC, winner;

-- 14. 1984 winners ordered by subject and winner, but chemistry and physics last.
-- `subject IN (...)` evaluates to 0 (false) or 1 (true). Sorting by it puts the
-- 0s first, so chemistry/physics (the 1s) end up last.
SELECT winner, subject
FROM nobel
WHERE yr = 1984
ORDER BY subject IN ('physics', 'chemistry'), subject, winner;
