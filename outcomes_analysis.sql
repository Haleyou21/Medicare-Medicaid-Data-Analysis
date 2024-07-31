-- Analyzing mortality rates by condition and identifying high-risk conditions
WITH condition_patients AS (
  SELECT
    person_id,
    condition_concept_id,
    condition_start_date
  FROM
    `bigquery-public-data.cms_synthetic_patient_data_omop.condition_occurrence`
  WHERE
    condition_concept_id IN (319835, 201826, 312327)
),
death_patients AS (
  SELECT
    person_id,
    death_date
  FROM
    `bigquery-public-data.cms_synthetic_patient_data_omop.death`
)
SELECT
  cp.condition_concept_id,
  c.concept_name AS condition_name,
  COUNT(dp.person_id) AS death_count,
  COUNT(cp.person_id) AS patient_count,
  (COUNT(dp.person_id) / COUNT(cp.person_id)) * 100 AS mortality_rate,
  AVG(DATE_DIFF(dp.death_date, cp.condition_start_date)) AS avg_days_to_death
FROM
  condition_patients cp
LEFT JOIN
  death_patients dp
ON
  cp.person_id = dp.person_id
JOIN
  `bigquery-public-data.cms_synthetic_patient_data_omop.concept` AS c
ON
  cp.condition_concept_id = c.concept_id
GROUP BY
  cp.condition_concept_id, condition_name
ORDER BY
  mortality_rate DESC, avg_days_to_death ASC
LIMIT 100;
