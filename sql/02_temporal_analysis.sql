-- TEMPORAL TRENDS IN CANCER DIAGNOSES
-- Business Question: How has cancer diagnosis volume evolved from 2015 to 2024?
-- Purpose: Identify growth trends and forecast resource needs
-- Key Metrics: YoY growth, patient volume trends, cost escalation


;WITH yearly_counts AS (
    SELECT 
        Year,
        COUNT(*) AS total_diagnoses,
        COUNT(DISTINCT Cancer_Type) AS cancer_types_diagnosed,
        ROUND(AVG(Age), 1) AS avg_patient_age,
        ROUND(AVG(Treatment_Cost_USD), 0) AS avg_treatment_cost
    FROM [Global Cancer Patients Analysis]..[global_cancer_patients_2015_202$]
    GROUP BY Year
)
SELECT 
    Year,
    total_diagnoses,
    cancer_types_diagnosed,
    avg_patient_age,
    avg_treatment_cost,
    
    -- Year-over-year change
    total_diagnoses - LAG(total_diagnoses) OVER (ORDER BY Year) AS yoy_change,
    ROUND(100.0 * (total_diagnoses - LAG(total_diagnoses) OVER (ORDER BY Year)) / 
          NULLIF(LAG(total_diagnoses) OVER (ORDER BY Year), 0), 2) AS yoy_growth_pct
FROM yearly_counts
ORDER BY Year;
