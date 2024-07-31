-- Identifying the most common conditions and their average duration
SELECT
  co.condition_concept_id,
  c.concept_name AS condition_name,
  COUNT(co.condition_occurrence_id) AS occurrence_count,
  AVG(DATE_DIFF(co.condition_end_date, co.condition_start_date)) AS avg_duration_days,
  COUNT(DISTINCT co.person_id) AS affected_patients,
  (COUNT(co.condition_occurrence_id) / COUNT(DISTINCT co.person_id)) AS avg_conditions_per_patient
FROM
  `bigquery-public-data.cms_synthetic_patient_data_omop.condition_occurrence` AS co
JOIN
  `bigquery-public-data.cms_synthetic_patient_data_omop.concept` AS c
ON
  co.condition_concept_id = c.concept_id
WHERE
  co.condition_end_date IS NOT NULL
GROUP BY
  co.condition_concept_id, condition_name
ORDER BY
  occurrence_count DESC
LIMIT 100;
