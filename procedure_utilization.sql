-- Identifying the most common procedures, their costs, and associated patient demographics
WITH procedure_data AS (
  SELECT
    po.procedure_concept_id,
    c.concept_name AS procedure_name,
    po.person_id,
    pc.cost,
    p.gender_concept_id,
    p.race_concept_id,
    p.ethnicity_concept_id,
    DATE_DIFF(CURRENT_DATE(), p.birth_date, YEAR) AS age
  FROM
    `bigquery-public-data.cms_synthetic_patient_data_omop.procedure_occurrence` AS po
  JOIN
    `bigquery-public-data.cms_synthetic_patient_data_omop.concept` AS c
  ON
    po.procedure_concept_id = c.concept_id
  JOIN
    `bigquery-public-data.cms_synthetic_patient_data_omop.procedure_cost` AS pc
  ON
    po.procedure_occurrence_id = pc.procedure_occurrence_id
  JOIN
    `bigquery-public-data.cms_synthetic_patient_data_omop.person` AS p
  ON
    po.person_id = p.person_id
)
SELECT
  procedure_concept_id,
  procedure_name,
  COUNT(procedure_concept_id) AS procedure_count,
  AVG(cost) AS avg_cost,
  gender_concept_id,
  race_concept_id,
  ethnicity_concept_id,
  COUNT(DISTINCT person_id) AS patient_count,
  AVG(age) AS avg_age
FROM
  procedure_data
GROUP BY
  procedure_concept_id, procedure_name, gender_concept_id, race_concept_id, ethnicity_concept_id
ORDER BY
  procedure_count DESC
LIMIT 100;
