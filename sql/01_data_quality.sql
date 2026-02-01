-- DATA QUALITY AND COMPLETENESS ASSESSMENT
-- Business Question: What is the quality and completeness of our dataset?
-- Purpose: Validate data integrity before analysis
-- Key Metrics: Record counts, missing values, duplicate detection

SELECT 
    COUNT(*) AS total_records,
    COUNT(DISTINCT Patient_ID) AS unique_patients,
    
    -- Completeness checks
    COUNT(*) - COUNT(Age) AS missing_age,
    ROUND(100.0 * (COUNT(*) - COUNT(Age)) / COUNT(*), 2) AS pct_missing_age,
    
    COUNT(*) - COUNT(Gender) AS missing_gender,
    ROUND(100.0 * (COUNT(*) - COUNT(Gender)) / COUNT(*), 2) AS pct_missing_gender,
    
    COUNT(*) - COUNT(Country_Region) AS missing_country,
    ROUND(100.0 * (COUNT(*) - COUNT(Country_Region)) / COUNT(*), 2) AS pct_missing_country,
    
    COUNT(*) - COUNT(Genetic_Risk) AS missing_genetic_risk,
    ROUND(100.0 * (COUNT(*) - COUNT(Genetic_Risk)) / COUNT(*), 2) AS pct_missing_genetic_risk,
    
    COUNT(*) - COUNT(Treatment_Cost_USD) AS missing_cost,
    ROUND(100.0 * (COUNT(*) - COUNT(Treatment_Cost_USD)) / COUNT(*), 2) AS pct_missing_cost,
    
    COUNT(*) - COUNT(Survival_Years) AS missing_survival,
    ROUND(100.0 * (COUNT(*) - COUNT(Survival_Years)) / COUNT(*), 2) AS pct_missing_survival,
    
    -- Data integrity checks
    CASE 
        WHEN COUNT(*) = COUNT(DISTINCT Patient_ID) THEN 'PASS: No Duplicates'
        ELSE 'FAIL: Duplicate Patient IDs Found'
    END AS patient_id_uniqueness
FROM [Global Cancer Patients Analysis]..[global_cancer_patients_2015_202$];
