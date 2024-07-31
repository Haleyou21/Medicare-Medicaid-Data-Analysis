-- Analyzing drug exposure counts, average days supply by drug, and patient demographics
WITH drug_data AS (
  SELECT
    d.drug_concept_id,
    c.concept_name AS drug_name,
    d.person_id,
    d.days_supply,
    p.gender_concept_id,
    p.race_concept_id,
    p.ethnicity_concept_id,
    DATE_DIFF(CURRENT_DATE(), p.birth_date, YEAR) AS age
  FROM
    `bigquery-public-data.cms_synthetic_patient_data_omop.drug_exposure` AS d
  JOIN
    `bigquery-public-data.cms_synthetic_patient_data_omop.concept` AS c
  ON
    d.drug_concept_id = c.concept_id
  JOIN
    `bigquery-public-data.cms_synthetic_patient_data_omop.person` AS p
  ON
    d.person_id = p.person_id
)
SELECT
  drug_concept_id,
  drug_name,
  COUNT(drug_concept_id) AS exposure_count,
  AVG(days_supply) AS avg_days_supply,
  gender_concept_id,
  race_concept_id,
  ethnicity_concept_id,
  COUNT(DISTINCT person_id) AS patient_count,
  AVG(age) AS avg_age
FROM
  drug_data
GROUP BY
  drug_concept_id, drug_name, gender_concept_id, race_concept_id, ethnicity_concept_id
ORDER BY
  exposure_count DESC
LIMIT 100;
