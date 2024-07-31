-- Analyzing patient demographics by age group, gender, and race
SELECT
  CASE
    WHEN DATE_DIFF(CURRENT_DATE(), birth_date, YEAR) < 18 THEN 'Under 18'
    WHEN DATE_DIFF(CURRENT_DATE(), birth_date, YEAR) BETWEEN 18 AND 34 THEN '18-34'
    WHEN DATE_DIFF(CURRENT_DATE(), birth_date, YEAR) BETWEEN 35 AND 49 THEN '35-49'
    WHEN DATE_DIFF(CURRENT_DATE(), birth_date, YEAR) BETWEEN 50 AND 64 THEN '50-64'
    ELSE '65+'
  END AS age_group,
  gender_concept_id,
  race_concept_id,
  COUNT(person_id) AS patient_count
FROM
  `bigquery-public-data.cms_synthetic_patient_data_omop.person`
GROUP BY
  age_group, gender_concept_id, race_concept_id
ORDER BY
  patient_count DESC;

