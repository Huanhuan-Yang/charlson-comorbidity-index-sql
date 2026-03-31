# Charlson Comorbidity Index (CCI) and Age-Adjusted CCI (ACCI) Calculation

This repository contains SQL code for calculating the Charlson Comorbidity Index (CCI) and the Age-Adjusted Charlson Comorbidity Index (ACCI) using ICD-10 diagnosis codes from Epic Cosmos electronic health record (EHR) data.

## Overview

The Charlson Comorbidity Index is a widely used method to quantify comorbidity burden based on the presence of specific chronic conditions. Each condition is assigned a weight, and the total score reflects overall disease burden and risk of mortality.

The Age-Adjusted Charlson Comorbidity Index (ACCI) further incorporates age into the score to improve risk stratification.

This repository provides SQL code to:

- Identify Charlson comorbid conditions using ICD-10 diagnosis codes
- Assign standard Charlson weights for each condition
- Calculate the total Charlson Comorbidity Index (CCI)
- Apply age adjustment to generate the Age-Adjusted CCI (ACCI)

## Data Source

The SQL scripts are designed for use with structured EHR data from **Epic Cosmos**, using diagnosis records coded in **ICD-10**.

Only diagnosis codes occurring **prior to the index date** are used to define comorbidities.

## Required Input Variables

The code assumes a patient-level dataset containing at least the following variables:

- `PatientDurableKey` – unique patient identifier  
- `DiagnosisCode` – ICD-10 diagnosis code  
- `DiagnosisDate` – date of diagnosis  
- `IndexDate` – study index date  
- `IndexAge` – patient age at index date  

## Output Variables

The script generates patient-level comorbidity indicators and summary scores, including:

- `CCI_score`
- `ACCI_score`
- Individual Charlson comorbidity indicators (e.g., myocardial infarction, congestive heart failure, diabetes, malignancy, etc.)

## Methods

1. Identify Charlson comorbidity categories based on ICD-10 diagnosis codes.
2. Restrict diagnoses to those occurring prior to the index date.
3. Assign standard Charlson weights to each condition.
4. Sum weighted conditions to calculate the CCI score.
5. Add age-based points using age at the index date to obtain the ACCI score.

## Notes

- This repository contains **SQL code only** and does not include any patient-level data.
- Users may need to adapt diagnosis code lists or table structures depending on their database schema.
- The code can be adapted to other EHR or clinical data environments that use ICD-10 coding.

## Disclaimer

This repository contains only analytic SQL code. No patient-level data from Epic Cosmos or any other data source are included.
