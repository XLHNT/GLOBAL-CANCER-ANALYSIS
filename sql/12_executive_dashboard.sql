-- EXECUTIVE HEALTHCARE DASHBOARD - COMPREHENSIVE KPIs
-- Business Purpose: Single-query dashboard with all critical metrics
-- Use Case: Monthly board presentations, strategic planning
-- Key Metrics: Volume, costs, survival rates, stage distribution

WITH yearly_kpis AS (
    SELECT 
        Year,
        COUNT(*) AS total_patients,
        COUNT(DISTINCT Cancer_Type) AS cancer_types_treated,
        ROUND(AVG(Age), 1) AS avg_patient_age,
        ROUND(100.0 * SUM(CASE WHEN Gender = 'Male' THEN 1 ELSE 0 END) / COUNT(*), 2) AS pct_male,
        
        -- Stage distribution
        ROUND(100.0 * SUM(CASE WHEN Cancer_Stage = 'Stage I' THEN 1 ELSE 0 END) / COUNT(*), 2) AS pct_stage_I,
        ROUND(100.0 * SUM(CASE WHEN Cancer_Stage = 'Stage IV' THEN 1 ELSE 0 END) / COUNT(*), 2) AS pct_stage_IV,
        
        -- Financial metrics
        ROUND(AVG(Treatment_Cost_USD), 0) AS avg_treatment_cost,
        ROUND(SUM(Treatment_Cost_USD), 0) AS total_treatment_cost,
        
        -- Clinical outcomes
        ROUND(AVG(Survival_Years), 2) AS avg_survival_years,
        ROUND(100.0 * SUM(CASE WHEN Survival_Years >= 5 THEN 1 ELSE 0 END) / COUNT(*), 2) AS pct_5yr_survival,
        ROUND(AVG(Target_Severity_Score), 2) AS avg_severity_score,
        
        -- Risk factors
        ROUND(AVG(Genetic_Risk), 3) AS avg_genetic_risk,
        ROUND(AVG(Smoking), 2) AS avg_smoking_level,
        ROUND(AVG(Obesity_Level), 2) AS avg_obesity_level
    FROM [Global Cancer Patients Analysis]..[global_cancer_patients_2015_202$]
    GROUP BY Year
),
portfolio_summary AS (
    SELECT 
        Year,
        total_patients,
        cancer_types_treated,
        avg_patient_age,
        pct_male,
        pct_stage_I,
        pct_stage_IV,
        avg_treatment_cost,
        total_treatment_cost,
        avg_survival_years,
        pct_5yr_survival,
        avg_severity_score,
        avg_genetic_risk,
        avg_smoking_level,
        avg_obesity_level,
        
        -- Year-over-year changes
        total_patients - LAG(total_patients) OVER (ORDER BY Year) AS yoy_patient_change,
        ROUND(avg_treatment_cost - LAG(avg_treatment_cost) OVER (ORDER BY Year), 0) AS yoy_cost_change,
        ROUND(avg_survival_years - LAG(avg_survival_years) OVER (ORDER BY Year), 2) AS yoy_survival_change,
        
        -- Growth rates
        CASE 
            WHEN LAG(total_patients) OVER (ORDER BY Year) IS NULL THEN NULL
            ELSE ROUND(100.0 * (total_patients - LAG(total_patients) OVER (ORDER BY Year)) /
                       LAG(total_patients) OVER (ORDER BY Year), 2)
        END AS yoy_patient_growth_pct
    FROM yearly_kpis
)
SELECT 
    Year,
    
    -- Volume metrics
    total_patients,
    yoy_patient_change,
    yoy_patient_growth_pct,
    cancer_types_treated,
    
    -- Demographics
    avg_patient_age,
    pct_male,
    
    -- Stage mix
    pct_stage_I,
    pct_stage_IV,
    
    -- Financial performance
    avg_treatment_cost,
    yoy_cost_change,
    total_treatment_cost,
    
    -- Clinical outcomes
    avg_survival_years,
    yoy_survival_change,
    pct_5yr_survival,
    avg_severity_score,
    
    -- Risk profile
    avg_genetic_risk,
    avg_smoking_level,
    avg_obesity_level,
    
    -- Performance indicators
    CASE 
        WHEN pct_5yr_survival >= 60 THEN 'Exceeds Target'
        WHEN pct_5yr_survival >= 50 THEN 'Meets Target'
        ELSE 'Below Target'
    END AS survival_performance,
    
    CASE 
        WHEN pct_stage_I + pct_stage_IV > 0 AND pct_stage_I >= pct_stage_IV THEN 'Good Early Detection'
        ELSE 'Need Screening Improvement'
    END AS early_detection_assessment
FROM portfolio_summary
ORDER BY Year;
