-- LIFESTYLE RISK FACTOR IMPACT ON SURVIVAL
-- Business Question: How do modifiable risk factors impact survival?
-- Business Decision: Which prevention programs have highest ROI?
-- Key Metrics: Survival differences by risk category

WITH risk_categories AS (
    SELECT 
        Patient_ID,
        Age,
        Cancer_Type,
        Survival_Years,
        Treatment_Cost_USD,
        
        CASE 
            WHEN Smoking IS NULL THEN 'Unknown'
            WHEN Smoking = 0 THEN 'Non-Smoker'
            WHEN Smoking <= 2 THEN 'Light Smoker'
            WHEN Smoking <= 5 THEN 'Moderate Smoker'
            ELSE 'Heavy Smoker'
        END AS smoking_category,
        
        CASE 
            WHEN Alcohol_Use IS NULL THEN 'Unknown'
            WHEN Alcohol_Use = 0 THEN 'Non-Drinker'
            WHEN Alcohol_Use <= 2 THEN 'Light Drinker'
            WHEN Alcohol_Use <= 5 THEN 'Moderate Drinker'
            ELSE 'Heavy Drinker'
        END AS alcohol_category,
        
        CASE 
            WHEN Obesity_Level IS NULL THEN 'Unknown'
            WHEN Obesity_Level < 25 THEN 'Normal Weight'
            WHEN Obesity_Level < 30 THEN 'Overweight'
            WHEN Obesity_Level < 35 THEN 'Obese Class I'
            ELSE 'Obese Class II+'
        END AS obesity_category
    FROM [Global Cancer Patients Analysis]..[global_cancer_patients_2015_202$]
)

-- Smoking Impact Analysis
SELECT 
    'Smoking Impact' AS risk_factor,
    smoking_category AS category,
    COUNT(*) AS patient_count,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER(), 2) AS pct_of_population,
    ROUND(AVG(Survival_Years), 2) AS avg_survival_years,
    ROUND(AVG(Treatment_Cost_USD), 0) AS avg_treatment_cost,
    
    -- Calculate survival difference vs non-smokers
    ROUND(AVG(Survival_Years) - 
          (SELECT AVG(Survival_Years) 
           FROM risk_categories 
           WHERE smoking_category = 'Non-Smoker'), 2) AS survival_diff_vs_baseline
FROM risk_categories
WHERE smoking_category != 'Unknown'
GROUP BY smoking_category
ORDER BY 
    CASE smoking_category
        WHEN 'Non-Smoker' THEN 1
        WHEN 'Light Smoker' THEN 2
        WHEN 'Moderate Smoker' THEN 3
        WHEN 'Heavy Smoker' THEN 4
    END;
