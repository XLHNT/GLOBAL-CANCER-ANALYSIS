-- CANCER TYPE DISTRIBUTION AND PREVALENCE
-- Business Question: What are the most prevalent cancer types?
-- Business Decision: Which cancers need priority funding?
-- Key Metrics: Case volume, stage distribution, survival rates

SELECT 
    Cancer_Type,
    COUNT(*) AS patient_count,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER(), 2) AS pct_of_total_cases,
    
    -- Clinical outcomes by type
    ROUND(AVG(Survival_Years), 2) AS avg_survival_years,
    ROUND(AVG(Treatment_Cost_USD), 0) AS avg_treatment_cost,
    ROUND(AVG(Target_Severity_Score), 2) AS avg_severity_score,
    
    -- Stage distribution
    SUM(CASE WHEN Cancer_Stage = 'Stage I' THEN 1 ELSE 0 END) AS stage_I_count,
    SUM(CASE WHEN Cancer_Stage = 'Stage II' THEN 1 ELSE 0 END) AS stage_II_count,
    SUM(CASE WHEN Cancer_Stage = 'Stage III' THEN 1 ELSE 0 END) AS stage_III_count,
    SUM(CASE WHEN Cancer_Stage = 'Stage IV' THEN 1 ELSE 0 END) AS stage_IV_count,
    
    ROUND(100.0 * SUM(CASE WHEN Cancer_Stage = 'Stage IV' THEN 1 ELSE 0 END) / COUNT(*), 2) AS pct_late_stage
FROM [Global Cancer Patients Analysis]..[global_cancer_patients_2015_202$]
GROUP BY Cancer_Type
ORDER BY patient_count DESC;
