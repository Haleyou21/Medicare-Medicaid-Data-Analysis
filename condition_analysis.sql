-- Identifying the most common conditions
SELECT
  condition_concept_id,
  c.concept_name AS condition_name,
  COUNT(condition_occurrence_id) AS occurrence_count
FROM
  `bigquery-public-data.cms_synthetic_patient_data_omop.condition_occurrence` AS co
JOIN
  `bigquery-public-data.cms_synthetic_patient_data_omop.concept` AS c
ON
  co.condition_concept_id = c.concept_id
GROUP BY
  condition_concept_id, condition_name
ORDER BY
  occurrence_count DESC
LIMIT 100;
