-- Calculating average costs associated with procedures and drugs, and analyzing cost trends over time
WITH cost_data AS (
  SELECT
    po.procedure_concept_id,
    c1.concept_name AS procedure_name,
    po.procedure_date,
    pc.cost AS procedure_cost,
    d.drug_concept_id,
    c2.concept_name AS drug_name,
    dc.cost AS drug_cost
  FROM
    `bigquery-public-data.cms_synthetic_patient_data_omop.procedure_occurrence` AS po
  JOIN
    `bigquery-public-data.cms_synthetic_patient_data_omop.procedure_cost` AS pc
  ON
    po.procedure_occurrence_id = pc.procedure_occurrence_id
  JOIN
    `bigquery-public-data.cms_synthetic_patient_data_omop.concept` AS c1
  ON
    po.procedure_concept_id = c1.concept_id
  LEFT JOIN
    `bigquery-public-data.cms_synthetic_patient_data_omop.drug_exposure` AS d
  ON
    po.person_id = d.person_id
  LEFT JOIN
    `bigquery-public-data.cms_synthetic_patient_data_omop.drug_cost` AS dc
  ON
    d.drug_exposure_id = dc.drug_exposure_id
  LEFT JOIN
    `bigquery-public-data.cms_synthetic_patient_data_omop.concept` AS c2
  ON
    d.drug_concept_id = c2.concept_id
)
SELECT
  procedure_concept_id,
  procedure_name,
  drug_concept_id,
  drug_name,
  AVG(procedure_cost) AS avg_procedure_cost,
  AVG(drug_cost) AS avg_drug_cost,
  EXTRACT(YEAR FROM procedure_date) AS year
FROM
  cost_data
GROUP BY
  procedure_concept_id, procedure_name, drug_concept_id, drug_name, year
ORDER BY
  year DESC, avg_procedure_cost DESC, avg_drug_cost DESC
LIMIT 100;
