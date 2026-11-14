-- SQL Zoo Tutorial 1 (+/-): SELECT names
-- https://sqlzoo.net/wiki/SELECT_names
-- Table: world(name, continent, capital, ...)
-- LIKE wildcards:  %  = any number of characters (even zero)
--                  _  = exactly one character

-- 1. Countries that start with Y.
SELECT name FROM world WHERE name LIKE 'Y%';

-- 2. Countries that end with y.
SELECT name FROM world WHERE name LIKE '%y';

-- 3. Countries that contain the letter x.
SELECT name FROM world WHERE name LIKE '%x%';

-- 4. Countries that end with "land".
SELECT name FROM world WHERE name LIKE '%land';

-- 5. Countries that start with C and end with ia.
SELECT name FROM world WHERE name LIKE 'C%ia';

-- 6. Countries that have "oo" in the name.
SELECT name FROM world WHERE name LIKE '%oo%';

-- 7. Countries that have three or more a's in the name.
-- Three separate 'a's with anything (or nothing) between them.
SELECT name FROM world WHERE name LIKE '%a%a%a%';

-- 8. Countries that have "t" as the second character, in order.
-- One _ means "exactly one character" before the t.
SELECT name FROM world WHERE name LIKE '_t%' ORDER BY name;

-- 9. Countries that have two "o" characters separated by two others.
SELECT name FROM world WHERE name LIKE '%o__o%';

-- 10. Countries that have exactly four characters.
SELECT name FROM world WHERE name LIKE '____';

-- 11. Countries where the capital is the same as the country name.
-- You can compare two columns of the same row directly.
SELECT name FROM world WHERE name = capital;

-- 12. Countries where the capital is the country name + " City".
-- CONCAT glues strings together, so we build 'Mexico City' from 'Mexico'.
SELECT name FROM world WHERE capital = CONCAT(name, ' City');

-- 13. Capital and name where the capital includes the name of the country.
SELECT capital, name FROM world WHERE capital LIKE CONCAT('%', name, '%');

-- 14. Capital and name where the capital is an *extension* of the country name.
-- Same as 13, but exclude rows where they are identical (Luxembourg/Luxembourg).
SELECT capital, name
FROM world
WHERE capital LIKE CONCAT('%', name, '%')
  AND capital <> name;

-- 15. Show the name and the extension where the capital is an extension of the name.
-- REPLACE(capital, name, '') removes the country name from the capital, leaving
-- only the extension. CONCAT(name, '_%') means "name followed by at least 1 char".
SELECT name, REPLACE(capital, name, '') AS extension
FROM world
WHERE capital LIKE CONCAT(name, '_%');
