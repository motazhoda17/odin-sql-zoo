# odin-sql-zoo

My study notes for the [SQL Zoo project](https://www.theodinproject.com/lessons/node-path-databases-sql-zoo) in The Odin Project's Databases course.

> **Important:** this repo is a *study companion*, not a replacement for the exercises.
> Do every tutorial yourself on [sqlzoo.net](https://sqlzoo.net/wiki/SQL_Tutorial) first
> (with the **Engine** dropdown set to **MySQL**), and only then compare with these notes.
> Typing the queries yourself and seeing the result tables is how SQL actually sticks.
> SQL Zoo sometimes rewords or reorders questions, so a note here may not line up 1:1 with
> the live site. If a query here doesn't give the "correct" smiley, trust the site and fix the note.

## What's in here

One commented `.sql` file per tutorial. Every query has a short comment explaining *why* it works.

| File | SQL Zoo tutorial | Main ideas |
| --- | --- | --- |
| `00-select-basics.sql` | 0 SELECT basics | `SELECT`, `WHERE`, `IN`, `BETWEEN` |
| `01-select-names.sql` | 1 SELECT names (+/-) | `LIKE`, `%` and `_` wildcards, `CONCAT`, `REPLACE` |
| `02-select-from-world.sql` | 2 SELECT from World | arithmetic in columns, `OR` vs `XOR`, `ROUND`, `LENGTH`, `LEFT` |
| `03-select-from-nobel.sql` | 3 SELECT from Nobel | combining conditions, escaping quotes, `ORDER BY` tricks |
| `04-select-within-select.sql` | 4 SELECT within SELECT | subqueries, `ALL`, correlated subqueries |
| `05-sum-and-count.sql` | 5 SUM and COUNT | aggregates, `GROUP BY`, `HAVING` |
| `06-join.sql` | 6 JOIN | `JOIN ... ON`, `LEFT JOIN`, `CASE` inside `SUM` |
| `07-more-join.sql` | 7 More JOIN operations | joining 3 tables, nested subqueries |
| `08-using-null.sql` | 8 Using NULL | `IS NULL`, `LEFT/RIGHT JOIN`, `COALESCE`, `CASE` |
| `08plus-numeric-examples.sql` | 8+ Numeric Examples | weighted averages, conditional sums |
| `09-window-functions.sql` | 9 Window functions | `RANK() OVER (PARTITION BY ...)` |
| `09plus-covid-19.sql` | 9+ COVID-19 | `LAG()`, dates, self-join by date |
| `09minus-self-join.sql` | 9- Self join | joining a table to itself |

The Odin assignment also asks you to do the **quiz at the end of each tutorial**. Those are
multiple choice, so they aren't written here — do them on the site.

## How to use these notes

1. Open the tutorial on sqlzoo.net and try each question on your own.
2. Stuck for more than ~10 minutes? Read only the *comment* above the matching query here for a hint.
3. Still stuck? Read the query, then close this file and type it from memory on the site.
4. Make sure you can explain every keyword before moving on.

## What I practiced

- Reading a table schema and turning an English question into a query
- Filtering (`WHERE`, `LIKE`, `IN`, `BETWEEN`) and sorting (`ORDER BY`)
- Aggregates (`COUNT`, `SUM`, `GROUP BY`, `HAVING`)
- Subqueries, including correlated subqueries
- Every kind of `JOIN`, including self joins
- Handling `NULL` safely
- Window functions (`RANK`, `LAG`)

These are exactly the skills the later Node projects (Mini Message Board, Inventory App, Members Only) use with PostgreSQL.
