-- SQL Zoo Tutorial 8: Using NULL
-- https://sqlzoo.net/wiki/Using_Null
-- Tables:
--   teacher(id, dept, name, phone, mobile)    teacher.dept -> dept.id (can be NULL)
--   dept(id, name)
-- NULL means "unknown / no value". You can't test it with = ; use IS NULL / IS NOT NULL.

-- 1. Teachers who have NULL for their department.
SELECT name FROM teacher WHERE dept IS NULL;

-- 2. INNER JOIN misses teachers with no department and departments with no teachers.
SELECT teacher.name, dept.name
FROM teacher
INNER JOIN dept ON teacher.dept = dept.id;

-- 3. LEFT JOIN: list ALL teachers, even those with no department.
SELECT teacher.name, dept.name
FROM teacher
LEFT JOIN dept ON teacher.dept = dept.id;

-- 4. RIGHT JOIN: list ALL departments, even those with no teachers.
SELECT teacher.name, dept.name
FROM teacher
RIGHT JOIN dept ON teacher.dept = dept.id;

-- 5. Teacher name and mobile, or '07986 444 2266' if no mobile.
-- COALESCE returns the first non-NULL argument.
SELECT name, COALESCE(mobile, '07986 444 2266') AS mobile
FROM teacher;

-- 6. Teacher name and department name, using 'None' where there is no department.
SELECT teacher.name, COALESCE(dept.name, 'None') AS dept
FROM teacher
LEFT JOIN dept ON teacher.dept = dept.id;

-- 7. Number of teachers and number of mobile phones.
-- COUNT(column) skips NULLs, so COUNT(mobile) only counts teachers that have one.
SELECT COUNT(name) AS teachers, COUNT(mobile) AS mobiles FROM teacher;

-- 8. Each department and the number of staff (include departments with 0 staff).
-- RIGHT JOIN keeps every department; COUNT(teacher.name) gives 0 for empty ones.
SELECT dept.name, COUNT(teacher.name) AS staff
FROM teacher
RIGHT JOIN dept ON teacher.dept = dept.id
GROUP BY dept.name;

-- 9. Teacher name followed by 'Sci' if dept is 1 or 2, otherwise 'Art'.
SELECT name,
       CASE WHEN dept IN (1, 2) THEN 'Sci' ELSE 'Art' END AS faculty
FROM teacher;

-- 10. 'Sci' for dept 1 or 2, 'Art' for dept 3, 'None' otherwise.
-- CASE checks each WHEN in order and stops at the first true one.
SELECT name,
       CASE
         WHEN dept IN (1, 2) THEN 'Sci'
         WHEN dept = 3 THEN 'Art'
         ELSE 'None'
       END AS faculty
FROM teacher;
