-- PATIENT DEMOGRAPHICS AND AGE DISTRIBUTION
-- Business Question: What is the demographic profile of our patients?
-- Business Decision: How should we target screening programs?
-- Key Metrics: Age cohorts, gender distribution, outcomes by age

-- Part A: Overall age statistics by gender
SELECT 
    Gender,
    COUNT(*) AS patient_count,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER(), 2) AS pct_of_population,
    
    MIN(Age) AS youngest_patient,
    MAX(Age) AS oldest_patient,
    ROUND(AVG(Age), 1) AS avg_age,
    
    -- Age quartiles for targeted screening
    ROUND(AVG(CASE WHEN Age < 40 THEN Age END), 1) AS avg_age_under_40,
    ROUND(AVG(CASE WHEN Age BETWEEN 40 AND 64 THEN Age END), 1) AS avg_age_40_64,
    ROUND(AVG(CASE WHEN Age >= 65 THEN Age END), 1) AS avg_age_65_plus
FROM [Global Cancer Patients Analysis]..[global_cancer_patients_2015_202$]
WHERE Gender IS NOT NULL
GROUP BY Gender
ORDER BY patient_count DESC;

-- Part B: Age cohort analysis
SELECT 
    CASE 
        WHEN Age < 30 THEN '1. Under 30: Young Adults'
        WHEN Age < 40 THEN '2. 30-39: Early Middle Age'
        WHEN Age < 50 THEN '3. 40-49: Middle Age'
        WHEN Age < 60 THEN '4. 50-59: Late Middle Age'
        WHEN Age < 70 THEN '5. 60-69: Early Senior'
        ELSE '6. 70+: Senior'
    END AS age_cohort,
    
    COUNT(*) AS patients,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER(), 2) AS pct_of_total,
    
    ROUND(AVG(Survival_Years), 2) AS avg_survival,
    ROUND(AVG(Treatment_Cost_USD), 0) AS avg_cost,
    ROUND(AVG(Target_Severity_Score), 2) AS avg_severity
FROM [Global Cancer Patients Analysis]..[global_cancer_patients_2015_202$]
WHERE Age IS NOT NULL
GROUP BY 
    CASE 
        WHEN Age < 30 THEN '1. Under 30: Young Adults'
        WHEN Age < 40 THEN '2. 30-39: Early Middle Age'
        WHEN Age < 50 THEN '3. 40-49: Middle Age'
        WHEN Age < 60 THEN '4. 50-59: Late Middle Age'
        WHEN Age < 70 THEN '5. 60-69: Early Senior'
        ELSE '6. 70+: Senior'
    END
ORDER BY age_cohort;
