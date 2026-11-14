-- SQL Zoo Tutorial 8+: Numeric Examples (National Student Survey)
-- https://sqlzoo.net/wiki/NSS_Tutorial
-- Table: nss(ukprn, institution, subject, level, question,
--            A_STRONGLY_DISAGREE, A_DISAGREE, A_NEUTRAL, A_AGREE, A_STRONGLY_AGREE,
--            score, response, sample)
-- The A_* columns and score are PERCENTAGES; response is a head count.

-- 1. Percentage who STRONGLY AGREE for Q01 at Edinburgh Napier, Computer Science.
SELECT A_STRONGLY_AGREE
FROM nss
WHERE question = 'Q01'
  AND institution = 'Edinburgh Napier University'
  AND subject = '(8) Computer Science';

-- 2. Institution and subject where the Q15 score is at least 100.
SELECT institution, subject
FROM nss
WHERE question = 'Q15'
  AND score >= 100;

-- 3. Institution and score where the Q15 score for Computer Science is below 50.
SELECT institution, score
FROM nss
WHERE question = 'Q15'
  AND score < 50
  AND subject = '(8) Computer Science';

-- 4. Total responses to Q22 for Computer Science and Creative Arts and Design.
SELECT subject, SUM(response)
FROM nss
WHERE question = 'Q22'
  AND subject IN ('(8) Computer Science', '(H) Creative Arts and Design')
GROUP BY subject;

-- 5. Total number of students who STRONGLY AGREE with Q22 for those subjects.
-- Convert the percentage back to a head count: response * percent / 100.
SELECT subject, SUM(response * A_STRONGLY_AGREE / 100)
FROM nss
WHERE question = 'Q22'
  AND subject IN ('(8) Computer Science', '(H) Creative Arts and Design')
GROUP BY subject;

-- 6. Percentage of students who STRONGLY AGREE with Q22 for those subjects (whole number).
-- Weighted average: total "strongly agree" heads / total responses.
SELECT subject, ROUND(SUM(response * A_STRONGLY_AGREE) / SUM(response))
FROM nss
WHERE question = 'Q22'
  AND subject IN ('(8) Computer Science', '(H) Creative Arts and Design')
GROUP BY subject;

-- 7. Average Q22 score for each institution with Manchester in the name.
-- Weight each score by its response count so bigger courses count more.
SELECT institution, ROUND(SUM(score * response) / SUM(response))
FROM nss
WHERE question = 'Q22'
  AND institution LIKE '%Manchester%'
GROUP BY institution
ORDER BY institution;

-- 8. Manchester institutions: total sample size and Computer Science sample size (Q01).
-- A CASE inside SUM lets you count only some rows in the same query.
SELECT institution,
       SUM(sample),
       SUM(CASE WHEN subject = '(8) Computer Science' THEN sample ELSE 0 END) AS comp
FROM nss
WHERE question = 'Q01'
  AND institution LIKE '%Manchester%'
GROUP BY institution;
