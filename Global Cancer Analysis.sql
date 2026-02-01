
-- Q1: DATA QUALITY AND COMPLETENESS ASSESSMENT
--What is the quality and completeness of the dataset
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
FROM [Global Cancer Patients Analysis]..[global_cancer_patients_2015_202$]





-- Q2: TEMPORAL TRENDS IN CANCER DIAGNOSES
-- How has cancer diagnosis volume evolved from 2015 to 2024? 
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



-- Q3: CANCER TYPE DISTRIBUTION AND PREVALENCE
-- What are the most prevalent cancer types in the patient population? Which cancers type should receive priority funding for research and treatment facility expansion?

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




-- Q4: PATIENT DEMOGRAPHICS AND AGE DISTRIBUTION
-- What is the demographic profile of our cancer patients? How does age distribution inform our screening program priorities and age-specific treatment protocols?

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

-- Part B: Age cohort distribution with clinical outcomes
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
    ROUND(AVG(Target_Severity_Score), 2) AS avg_severity,
    
    -- Most common cancer in each age group
    (SELECT TOP 1 Cancer_Type 
     FROM [Global Cancer Patients Analysis]..[global_cancer_patients_2015_202$] c2 
     WHERE CASE 
        WHEN c2.Age < 30 THEN '1. Under 30: Young Adults'
        WHEN c2.Age < 40 THEN '2. 30-39: Early Middle Age'
        WHEN c2.Age < 50 THEN '3. 40-49: Middle Age'
        WHEN c2.Age < 60 THEN '4. 50-59: Late Middle Age'
        WHEN c2.Age < 70 THEN '5. 60-69: Early Senior'
        ELSE '6. 70+: Senior'
    END = CASE 
        WHEN c1.Age < 30 THEN '1. Under 30: Young Adults'
        WHEN c1.Age < 40 THEN '2. 30-39: Early Middle Age'
        WHEN c1.Age < 50 THEN '3. 40-49: Middle Age'
        WHEN c1.Age < 60 THEN '4. 50-59: Late Middle Age'
        WHEN c1.Age < 70 THEN '5. 60-69: Early Senior'
        ELSE '6. 70+: Senior'
    END
     GROUP BY Cancer_Type 
     ORDER BY COUNT(*) DESC) AS most_common_cancer
FROM [Global Cancer Patients Analysis]..[global_cancer_patients_2015_202$] c1
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





-- Q5: LIFESTYLE RISK FACTOR IMPACT ON SURVIVAL
-- How do modifiable risk factors (smoking, alcohol, obesity) impact patient survival rates? Which prevention programs would have the highest ROI based on survival improvement potential?

WITH risk_categories AS (
    SELECT 
        Patient_ID,
        Age,
        Cancer_Type,
        Cancer_Stage,
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
SELECT 
    smoking_category,
    alcohol_category,
    obesity_category,
    
    COUNT(*) AS patient_count,
    ROUND(AVG(Survival_Years), 2) AS avg_survival_years,
    ROUND(AVG(Treatment_Cost_USD), 0) AS avg_treatment_cost,
    
    -- Patients with all three risk factors
    SUM(CASE WHEN smoking_category IN ('Moderate Smoker', 'Heavy Smoker')
              AND alcohol_category IN ('Moderate Drinker', 'Heavy Drinker')
              AND obesity_category LIKE 'Obese%' THEN 1 ELSE 0 END) AS high_risk_all_three
FROM risk_categories
GROUP BY smoking_category, alcohol_category, obesity_category
HAVING COUNT(*) >= 10
ORDER BY avg_survival_years ASC, avg_treatment_cost DESC;



-- Q6: TREATMENT COST ANALYSIS BY CANCER STAGE
-- How do treatment costs escalate across cancer stages? What are the financial implications of late-stage vs. early detection for healthcare budget planning?

WITH stage_costs AS (
    SELECT 
        Cancer_Stage,
        Cancer_Type,
        COUNT(*) AS patient_count,
        ROUND(AVG(Treatment_Cost_USD), 0) AS avg_cost,
        ROUND(MIN(Treatment_Cost_USD), 0) AS min_cost,
        ROUND(MAX(Treatment_Cost_USD), 0) AS max_cost,
        ROUND(STDEV(Treatment_Cost_USD), 0) AS std_dev_cost,
        ROUND(AVG(Survival_Years), 2) AS avg_survival
    FROM [Global Cancer Patients Analysis]..[global_cancer_patients_2015_202$]
    WHERE Cancer_Stage IS NOT NULL AND Treatment_Cost_USD > 0
    GROUP BY Cancer_Stage, Cancer_Type
)
SELECT 
    Cancer_Stage,
    Cancer_Type,
    patient_count,
    avg_cost,
    min_cost,
    max_cost,
    std_dev_cost,
    avg_survival,
    
    -- Cost per survival year (cost-effectiveness metric)
    ROUND(avg_cost / NULLIF(avg_survival, 0), 0) AS cost_per_survival_year,
    
    -- Comparison to Stage I costs
    avg_cost - (SELECT AVG(avg_cost) FROM stage_costs WHERE Cancer_Stage = 'Stage I' 
                AND Cancer_Type = sc.Cancer_Type) AS cost_premium_vs_stage_I
FROM stage_costs sc
WHERE patient_count >= 20
ORDER BY Cancer_Type, 
    CASE Cancer_Stage
        WHEN 'Stage I' THEN 1
        WHEN 'Stage II' THEN 2
        WHEN 'Stage III' THEN 3
        WHEN 'Stage IV' THEN 4
        ELSE 5
    END;



-- Q7: GEOGRAPHIC ANALYSIS - HIGH-BURDEN REGIONS
-- Which countries/regions face the highest cancer burden international health organizations prioritize resource allocation?


WITH country_metrics AS (
    SELECT 
        Country_Region,
        COUNT(*) AS total_patients,
        ROUND(AVG(Target_Severity_Score), 2) AS avg_severity,
        ROUND(AVG(Treatment_Cost_USD), 0) AS avg_cost,
        ROUND(AVG(Survival_Years), 2) AS avg_survival,
        ROUND(AVG(Age), 1) AS avg_age,
        
        -- Late-stage diagnosis rate
        ROUND(100.0 * SUM(CASE WHEN Cancer_Stage IN ('Stage III', 'Stage IV') THEN 1 ELSE 0 END) / 
              COUNT(*), 2) AS pct_late_stage,
        
        -- Risk factor prevalence
        ROUND(AVG(Genetic_Risk), 3) AS avg_genetic_risk,
        ROUND(AVG(Air_Pollution), 2) AS avg_air_pollution,
        ROUND(AVG(Smoking), 2) AS avg_smoking_level
    FROM [Global Cancer Patients Analysis]..[global_cancer_patients_2015_202$]
    WHERE Country_Region IS NOT NULL
    GROUP BY Country_Region
)
SELECT 
    Country_Region,
    total_patients,
    avg_severity,
    avg_cost,
    avg_survival,
    avg_age,
    pct_late_stage,
    avg_genetic_risk,
    avg_air_pollution,
    avg_smoking_level,
    
    -- Composite burden score (higher = more urgent intervention needed)
    ROUND((avg_severity * 0.3 + pct_late_stage * 0.3 + 
           (10 - avg_survival) * 0.2 + avg_air_pollution * 0.2), 2) AS burden_score,
    
    RANK() OVER (ORDER BY (avg_severity * 0.3 + pct_late_stage * 0.3 + 
                           (10 - avg_survival) * 0.2 + avg_air_pollution * 0.2) DESC) AS burden_rank
FROM country_metrics
WHERE total_patients >= 100
ORDER BY burden_score DESC;




-- Q8: GENDER DISPARITIES IN CANCER OUTCOMES
-- Are there gender-based disparities in cancer stage at diagnosis, treatment costs, or survival rates? Do we need gender-specific screening or treatment protocols?

SELECT 
    Cancer_Type,
    
    -- Male statistics
    SUM(CASE WHEN Gender = 'Male' THEN 1 ELSE 0 END) AS male_patients,
    ROUND(AVG(CASE WHEN Gender = 'Male' THEN Survival_Years END), 2) AS male_avg_survival,
    ROUND(AVG(CASE WHEN Gender = 'Male' THEN Treatment_Cost_USD END), 0) AS male_avg_cost,
    ROUND(100.0 * SUM(CASE WHEN Gender = 'Male' AND Cancer_Stage = 'Stage IV' THEN 1 ELSE 0 END) /
          NULLIF(SUM(CASE WHEN Gender = 'Male' THEN 1 ELSE 0 END), 0), 2) AS male_pct_stage_IV,
    
    -- Female statistics
    SUM(CASE WHEN Gender = 'Female' THEN 1 ELSE 0 END) AS female_patients,
    ROUND(AVG(CASE WHEN Gender = 'Female' THEN Survival_Years END), 2) AS female_avg_survival,
    ROUND(AVG(CASE WHEN Gender = 'Female' THEN Treatment_Cost_USD END), 0) AS female_avg_cost,
    ROUND(100.0 * SUM(CASE WHEN Gender = 'Female' AND Cancer_Stage = 'Stage IV' THEN 1 ELSE 0 END) /
          NULLIF(SUM(CASE WHEN Gender = 'Female' THEN 1 ELSE 0 END), 0), 2) AS female_pct_stage_IV,
    
    -- Disparity metrics
    ROUND(AVG(CASE WHEN Gender = 'Male' THEN Survival_Years END) - 
          AVG(CASE WHEN Gender = 'Female' THEN Survival_Years END), 2) AS survival_gap_male_minus_female,
    
    ROUND(AVG(CASE WHEN Gender = 'Male' THEN Treatment_Cost_USD END) - 
          AVG(CASE WHEN Gender = 'Female' THEN Treatment_Cost_USD END), 0) AS cost_gap_male_minus_female
FROM [Global Cancer Patients Analysis]..[global_cancer_patients_2015_202$]
WHERE Gender IN ('Male', 'Female') AND Cancer_Type IS NOT NULL
GROUP BY Cancer_Type
HAVING SUM(CASE WHEN Gender = 'Male' THEN 1 ELSE 0 END) >= 50 
   AND SUM(CASE WHEN Gender = 'Female' THEN 1 ELSE 0 END) >= 50
ORDER BY ABS(AVG(CASE WHEN Gender = 'Male' THEN Survival_Years END) - 
             AVG(CASE WHEN Gender = 'Female' THEN Survival_Years END)) DESC;




-- Q9: AGE-SPECIFIC CANCER PROFILES
-- How do cancer characteristics differ across age groups? What age-specific screening guidelines should be developed based on prevalence patterns and outcomes?


WITH age_cohorts AS (
    SELECT 
        Patient_ID,
        CASE 
            WHEN Age < 40 THEN '1. Under 40'
            WHEN Age < 55 THEN '2. 40-54'
            WHEN Age < 70 THEN '3. 55-69'
            ELSE '4. 70+'
        END AS age_group,
        Age,
        Gender,
        Cancer_Type,
        Cancer_Stage,
        Survival_Years,
        Treatment_Cost_USD,
        Target_Severity_Score,
        Genetic_Risk,
        Smoking,
        Alcohol_Use,
        Obesity_Level
    FROM [Global Cancer Patients Analysis]..[global_cancer_patients_2015_202$]
    WHERE Age IS NOT NULL
)
SELECT 
    age_group,
    COUNT(*) AS total_patients,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER(), 2) AS pct_of_population,
    
    -- Demographics
    ROUND(AVG(Age), 1) AS avg_age,
    ROUND(100.0 * SUM(CASE WHEN Gender = 'Male' THEN 1 ELSE 0 END) / COUNT(*), 2) AS pct_male,
    
    -- Clinical outcomes
    ROUND(AVG(Survival_Years), 2) AS avg_survival,
    ROUND(AVG(Treatment_Cost_USD), 0) AS avg_cost,
    ROUND(AVG(Target_Severity_Score), 2) AS avg_severity,
    
    -- Stage distribution
    ROUND(100.0 * SUM(CASE WHEN Cancer_Stage = 'Stage I' THEN 1 ELSE 0 END) / COUNT(*), 2) AS pct_stage_I,
    ROUND(100.0 * SUM(CASE WHEN Cancer_Stage = 'Stage IV' THEN 1 ELSE 0 END) / COUNT(*), 2) AS pct_stage_IV,
    
    -- Risk factors
    ROUND(AVG(Genetic_Risk), 3) AS avg_genetic_risk,
    ROUND(AVG(Smoking), 2) AS avg_smoking,
    ROUND(AVG(Alcohol_Use), 2) AS avg_alcohol,
    ROUND(AVG(Obesity_Level), 2) AS avg_obesity
FROM age_cohorts
GROUP BY age_group
ORDER BY age_group;





-- Q10: MULTI-FACTOR RISK SCORE CALCULATION
-- Can we create a comprehensive risk score combining genetic, environmental, and lifestyle factors to identify highest-risk patients for intensive screening programs?

WITH normalized_factors AS (
    SELECT 
        Patient_ID,
        Age,
        Gender,
        Country_Region,
        Cancer_Type,
        Year,
        
        -- Normalize all risk factors to 0-1 scale
        Genetic_Risk / NULLIF((SELECT MAX(Genetic_Risk) FROM [Global Cancer Patients Analysis]..[global_cancer_patients_2015_202$]), 0) AS norm_genetic,
        Air_Pollution / NULLIF((SELECT MAX(Air_Pollution) FROM [Global Cancer Patients Analysis]..[global_cancer_patients_2015_202$]), 0) AS norm_pollution,
        Alcohol_Use / NULLIF((SELECT MAX(Alcohol_Use) FROM [Global Cancer Patients Analysis]..[global_cancer_patients_2015_202$]), 0) AS norm_alcohol,
        Smoking / NULLIF((SELECT MAX(Smoking) FROM [Global Cancer Patients Analysis]..[global_cancer_patients_2015_202$]), 0) AS norm_smoking,
        Obesity_Level / NULLIF((SELECT MAX(Obesity_Level) FROM [Global Cancer Patients Analysis]..[global_cancer_patients_2015_202$]), 0) AS norm_obesity,
        
        Survival_Years,
        Target_Severity_Score
    FROM [Global Cancer Patients Analysis]..[global_cancer_patients_2015_202$]
),
risk_scores AS (
    SELECT 
        Patient_ID,
        Age,
        Gender,
        Country_Region,
        Cancer_Type,
        Year,
        
        -- Weighted composite risk score
        ROUND((norm_genetic * 0.35 +          -- Genetic risk highest weight
               norm_pollution * 0.20 +         -- Environmental factor
               norm_smoking * 0.20 +           -- Major lifestyle risk
               norm_alcohol * 0.15 +           -- Moderate lifestyle risk
               norm_obesity * 0.10), 4) AS composite_risk_score,
        
        Survival_Years,
        Target_Severity_Score
    FROM normalized_factors
)
SELECT 
    Patient_ID,
    Age,
    Gender,
    Country_Region,
    Cancer_Type,
    Year,
    composite_risk_score,
    Survival_Years,
    Target_Severity_Score,
    
    -- Risk percentile ranking
    NTILE(100) OVER (ORDER BY composite_risk_score DESC) AS risk_percentile,
    
    -- Risk category
    CASE 
        WHEN composite_risk_score >= 0.75 THEN 'Critical Risk'
        WHEN composite_risk_score >= 0.50 THEN 'High Risk'
        WHEN composite_risk_score >= 0.25 THEN 'Moderate Risk'
        ELSE 'Low Risk'
    END AS risk_category,
    
    RANK() OVER (ORDER BY composite_risk_score DESC) AS overall_risk_rank
FROM risk_scores
ORDER BY composite_risk_score DESC;





-- Q11: SURVIVAL RATE ANALYSIS WITH CONFIDENCE INTERVALS
-- What are the median survival rates by cancer type and stage, and how do they compare to benchmark survival expectations? Which cancers type shows improving trends?

WITH survival_stats AS (
    SELECT 
        Cancer_Type,
        Cancer_Stage,
        COUNT(*) AS patient_count,
        ROUND(AVG(Survival_Years), 2) AS mean_survival,
        ROUND(STDEV(Survival_Years), 2) AS std_dev_survival,
        ROUND(MIN(Survival_Years), 2) AS min_survival,
        ROUND(MAX(Survival_Years), 2) AS max_survival
    FROM [Global Cancer Patients Analysis]..[global_cancer_patients_2015_202$]
    WHERE Survival_Years IS NOT NULL
    GROUP BY Cancer_Type, Cancer_Stage
)
SELECT 
    Cancer_Type,
    Cancer_Stage,
    patient_count,
    mean_survival,
    std_dev_survival,
    min_survival,
    max_survival,
    
    -- Survival benchmarks
    ROUND(mean_survival - (1.96 * std_dev_survival / SQRT(patient_count)), 2) AS lower_95_ci,
    ROUND(mean_survival + (1.96 * std_dev_survival / SQRT(patient_count)), 2) AS upper_95_ci,
    
    -- 5-year survival indicator
    CASE 
        WHEN mean_survival >= 5 THEN 'Meets 5-Year Benchmark'
        ELSE 'Below 5-Year Benchmark'
    END AS benchmark_status
FROM survival_stats
WHERE patient_count >= 30
ORDER BY Cancer_Type, 
    CASE Cancer_Stage
        WHEN 'Stage I' THEN 1
        WHEN 'Stage II' THEN 2
        WHEN 'Stage III' THEN 3
        WHEN 'Stage IV' THEN 4
        ELSE 5
    END;




-- Q12: YEAR-OVER-YEAR SURVIVAL IMPROVEMENT TRENDS
-- Are treatment protocols improving over time? Which cancer type shows the most significant survival improvements from 2015 to 2024?

WITH yearly_survival AS (
    SELECT 
        Year,
        Cancer_Type,
        COUNT(*) AS patients,
        ROUND(AVG(Survival_Years), 2) AS avg_survival,
        ROUND(AVG(Treatment_Cost_USD), 0) AS avg_cost
    FROM [Global Cancer Patients Analysis]..[global_cancer_patients_2015_202$]
    WHERE Survival_Years IS NOT NULL
    GROUP BY Year, Cancer_Type
)
SELECT 
    Year,
    Cancer_Type,
    patients,
    avg_survival,
    avg_cost,
    
    -- Previous year comparison
    LAG(avg_survival) OVER (PARTITION BY Cancer_Type ORDER BY Year) AS prev_year_survival,
    ROUND(avg_survival - LAG(avg_survival) OVER (PARTITION BY Cancer_Type ORDER BY Year), 2) AS survival_change,
    
    CASE 
        WHEN LAG(avg_survival) OVER (PARTITION BY Cancer_Type ORDER BY Year) IS NULL THEN NULL
        ELSE ROUND(100.0 * (avg_survival - LAG(avg_survival) OVER (PARTITION BY Cancer_Type ORDER BY Year)) /
                   NULLIF(LAG(avg_survival) OVER (PARTITION BY Cancer_Type ORDER BY Year), 0), 2)
    END AS pct_change,
    
    -- Cost efficiency
    ROUND(avg_cost / NULLIF(avg_survival, 0), 0) AS cost_per_survival_year,
    
    -- Trend indicator
    CASE 
        WHEN avg_survival > LAG(avg_survival) OVER (PARTITION BY Cancer_Type ORDER BY Year) THEN 'IMPROVING'
        WHEN avg_survival < LAG(avg_survival) OVER (PARTITION BY Cancer_Type ORDER BY Year) THEN 'DECLINING'
        ELSE 'STABLE'
    END AS trend
FROM yearly_survival
ORDER BY Cancer_Type, Year;




-- Q13: DIAGNOSIS COHORT SURVIVAL COMPARISON
-- Do patients diagnosed in more recent years have better survival outcomes? How effective are the evolving treatment protocols?

WITH diagnosis_cohorts AS (
    SELECT 
        Patient_ID,
        Cancer_Type,
        Cancer_Stage,
        CASE 
            WHEN Year BETWEEN 2015 AND 2017 THEN '2015-2017: Early Period'
            WHEN Year BETWEEN 2018 AND 2020 THEN '2018-2020: Mid Period'
            ELSE '2021-2024: Recent Period'
        END AS diagnosis_cohort,
        Year,
        Age,
        Gender,
        Survival_Years,
        Treatment_Cost_USD,
        Target_Severity_Score
    FROM [Global Cancer Patients Analysis]..[global_cancer_patients_2015_202$]
)
SELECT 
    diagnosis_cohort,
    Cancer_Type,
    Cancer_Stage,
    
    COUNT(*) AS total_patients,
    ROUND(AVG(Age), 1) AS avg_age,
    ROUND(AVG(Survival_Years), 2) AS avg_survival,
    ROUND(AVG(Treatment_Cost_USD), 0) AS avg_cost,
    ROUND(AVG(Target_Severity_Score), 2) AS avg_severity,
    
    -- 5-year survival rate
    ROUND(100.0 * SUM(CASE WHEN Survival_Years >= 5 THEN 1 ELSE 0 END) / COUNT(*), 2) AS pct_5yr_survival,
    
    -- Cost per survival year
    ROUND(AVG(Treatment_Cost_USD) / NULLIF(AVG(Survival_Years), 0), 0) AS cost_per_survival_year
FROM diagnosis_cohorts
WHERE Cancer_Type IS NOT NULL
GROUP BY diagnosis_cohort, Cancer_Type, Cancer_Stage
HAVING COUNT(*) >= 20
ORDER BY Cancer_Type, Cancer_Stage, diagnosis_cohort;




-- Q14: TREATMENT COST FORECASTING BY CANCER TYPE
-- Based on historical trends, what are the projected treatment costs for 2025-2026?

;WITH yearly_costs AS (
    SELECT 
        Cancer_Type,
        Year,
        COUNT(*) AS patient_count,
        ROUND(AVG(Treatment_Cost_USD), 0) AS avg_cost
    FROM [Global Cancer Patients Analysis]..[global_cancer_patients_2015_202$]
    WHERE Treatment_Cost_USD > 0
    GROUP BY Cancer_Type, Year
),
yoy_calculation AS (
    -- Step 1: Calculate the YoY Growth % only
    SELECT 
        Cancer_Type,
        Year,
        avg_cost,
        patient_count,
        ROUND(100.0 * (avg_cost - LAG(avg_cost) OVER (PARTITION BY Cancer_Type ORDER BY Year)) /
              NULLIF(LAG(avg_cost) OVER (PARTITION BY Cancer_Type ORDER BY Year), 0), 2) AS yoy_growth_pct
    FROM yearly_costs
),
final_metrics AS (
    -- Step 2: Calculate the Average Growth Rate based on Step 1
    SELECT 
        *,
        AVG(yoy_growth_pct) OVER (PARTITION BY Cancer_Type) AS avg_growth_rate
    FROM yoy_calculation
)
SELECT 
    Cancer_Type,
    MAX(CASE WHEN Year = 2024 THEN avg_cost END) AS cost_2024,
    
    -- Simple projection using average growth rate
    ROUND(MAX(CASE WHEN Year = 2024 THEN avg_cost END) * (1 + MAX(avg_growth_rate) / 100), 0) AS projected_cost_2025,
    
    ROUND(MAX(CASE WHEN Year = 2024 THEN avg_cost END) * POWER((1 + MAX(avg_growth_rate) / 100), 2), 0) AS projected_cost_2026,
    
    MAX(avg_growth_rate) AS historical_avg_growth_pct,
    
    -- Budget impact
    ROUND((MAX(CASE WHEN Year = 2024 THEN avg_cost END) * (1 + MAX(avg_growth_rate) / 100)) - 
          MAX(CASE WHEN Year = 2024 THEN avg_cost END), 0) AS projected_increase_2025
FROM final_metrics
WHERE Cancer_Type IS NOT NULL
GROUP BY Cancer_Type
HAVING MAX(CASE WHEN Year = 2024 THEN avg_cost END) IS NOT NULL
ORDER BY projected_cost_2025 DESC;


-- Q15: HIGH-COST OUTLIER IDENTIFICATION
-- Which patients represent cost outliers that warrant case review for billing accuracy or treatment protocol optimization?

WITH cost_statistics AS (
    SELECT 
        Cancer_Type,
        Cancer_Stage,
        AVG(Treatment_Cost_USD) AS mean_cost,
        STDEV(Treatment_Cost_USD) AS std_cost,
        COUNT(*) AS total_patients
    FROM [Global Cancer Patients Analysis]..[global_cancer_patients_2015_202$]
    WHERE Treatment_Cost_USD > 0
    GROUP BY Cancer_Type, Cancer_Stage
)
SELECT 
    cp.Patient_ID,
    cp.Age,
    cp.Gender,
    cp.Country_Region,
    cp.Cancer_Type,
    cp.Cancer_Stage,
    cp.Year,
    cp.Treatment_Cost_USD,
    cp.Survival_Years,
    
    cs.mean_cost,
    cs.std_cost,
    
    -- Z-score calculation
    ROUND((cp.Treatment_Cost_USD - cs.mean_cost) / NULLIF(cs.std_cost, 0), 2) AS cost_z_score,
    
    -- Outlier classification
    CASE 
        WHEN (cp.Treatment_Cost_USD - cs.mean_cost) / NULLIF(cs.std_cost, 0) > 3 THEN 'Extreme High Cost'
        WHEN (cp.Treatment_Cost_USD - cs.mean_cost) / NULLIF(cs.std_cost, 0) > 2 THEN 'High Cost Outlier'
        WHEN (cp.Treatment_Cost_USD - cs.mean_cost) / NULLIF(cs.std_cost, 0) < -2 THEN 'Unusually Low Cost'
        ELSE 'Normal Range'
    END AS cost_outlier_status,
    
    -- Cost premium
    ROUND(cp.Treatment_Cost_USD - cs.mean_cost, 0) AS cost_vs_average
FROM [Global Cancer Patients Analysis]..[global_cancer_patients_2015_202$] cp
INNER JOIN cost_statistics cs 
    ON cp.Cancer_Type = cs.Cancer_Type 
    AND cp.Cancer_Stage = cs.Cancer_Stage
WHERE cp.Treatment_Cost_USD > 0 
    AND cs.std_cost > 0
    AND ABS((cp.Treatment_Cost_USD - cs.mean_cost) / cs.std_cost) > 1.5
ORDER BY ABS((cp.Treatment_Cost_USD - cs.mean_cost) / cs.std_cost) DESC;





-- Q16: FEATURE ENGINEERING FOR PREDICTIVE MODELS
-- What derived features and interaction terms would improve machine learning models for predicting cancer severity and patient outcomes?

WITH base_features AS (
    SELECT 
        Patient_ID,
        Age,
        Gender,
        Cancer_Type,
        Cancer_Stage,
        Year,
        
        -- Original risk factors
        Genetic_Risk,
        Air_Pollution,
        Alcohol_Use,
        Smoking,
        Obesity_Level,
        
        -- Target variables
        Target_Severity_Score,
        Survival_Years,
        Treatment_Cost_USD
    FROM [Global Cancer Patients Analysis]..[global_cancer_patients_2015_202$]
)
SELECT 
    Patient_ID,
    Age,
    Gender,
    Cancer_Type,
    Cancer_Stage,
    
    -- Age-based features
    CASE WHEN Age >= 65 THEN 1 ELSE 0 END AS is_senior,
    CASE WHEN Age < 40 THEN 1 ELSE 0 END AS is_young_adult,
    Age / 10 AS age_decade,
    
    -- Risk factor binary flags
    CASE WHEN Smoking > 3 THEN 1 ELSE 0 END AS heavy_smoker_flag,
    CASE WHEN Alcohol_Use > 3 THEN 1 ELSE 0 END AS heavy_drinker_flag,
    CASE WHEN Obesity_Level >= 30 THEN 1 ELSE 0 END AS obese_flag,
    CASE WHEN Air_Pollution > 5 THEN 1 ELSE 0 END AS high_pollution_flag,
    CASE WHEN Genetic_Risk > 0.7 THEN 1 ELSE 0 END AS high_genetic_risk_flag,
    
    -- Interaction features
    ROUND(Smoking * Alcohol_Use, 3) AS smoking_alcohol_interaction,
    ROUND(Genetic_Risk * Air_Pollution, 3) AS genetic_environment_interaction,
    ROUND(Age * Obesity_Level, 2) AS age_obesity_interaction,
    
    -- Multiple risk factor combinations
    CASE WHEN Smoking > 3 AND Alcohol_Use > 3 THEN 1 ELSE 0 END AS dual_substance_risk,
    CASE WHEN Smoking > 3 AND Obesity_Level >= 30 THEN 1 ELSE 0 END AS smoking_obesity_combo,
    CASE WHEN Genetic_Risk > 0.7 AND Smoking > 3 THEN 1 ELSE 0 END AS genetic_lifestyle_combo,
    
    -- Risk factor count
    (CASE WHEN Smoking > 3 THEN 1 ELSE 0 END +
     CASE WHEN Alcohol_Use > 3 THEN 1 ELSE 0 END +
     CASE WHEN Obesity_Level >= 30 THEN 1 ELSE 0 END +
     CASE WHEN Air_Pollution > 5 THEN 1 ELSE 0 END +
     CASE WHEN Genetic_Risk > 0.7 THEN 1 ELSE 0 END) AS total_high_risk_factors,
    
    -- Stage severity encoding
    CASE 
        WHEN Cancer_Stage = 'Stage I' THEN 1
        WHEN Cancer_Stage = 'Stage II' THEN 2
        WHEN Cancer_Stage = 'Stage III' THEN 3
        WHEN Cancer_Stage = 'Stage IV' THEN 4
        ELSE 0
    END AS stage_numeric,
    
    CASE WHEN Cancer_Stage IN ('Stage III', 'Stage IV') THEN 1 ELSE 0 END AS late_stage_flag,
    
    -- Temporal features
    2024 - Year AS years_since_diagnosis,
    CASE WHEN Year >= 2020 THEN 1 ELSE 0 END AS recent_diagnosis_flag,
    
    -- Target variables for modeling
    Target_Severity_Score AS severity_label,
    CASE WHEN Survival_Years >= 5 THEN 1 ELSE 0 END AS survived_5_years_label,
    CASE WHEN Treatment_Cost_USD > 50000 THEN 1 ELSE 0 END AS high_cost_label
FROM base_features;





-- Q17: COMPREHENSIVE ANOMALY DETECTION REPORT
-- Business Question: What data anomalies exist across clinical, demographic, and cost variables that require investigation before modeling or reporting?

WITH anomaly_checks AS (
    SELECT 
        Patient_ID,
        Age,
        Gender,
        Country_Region,
        Year,
        Cancer_Type,
        Cancer_Stage,
        Treatment_Cost_USD,
        Survival_Years,
        Target_Severity_Score,
        
        -- Age anomalies
        CASE WHEN Age < 0 OR Age > 120 THEN 1 ELSE 0 END AS age_invalid,
        CASE WHEN Age < 18 THEN 1 ELSE 0 END AS age_minor,
        
        -- Cost anomalies
        CASE WHEN Treatment_Cost_USD <= 0 OR Treatment_Cost_USD IS NULL THEN 1 ELSE 0 END AS cost_invalid,
        CASE WHEN Treatment_Cost_USD > 500000 THEN 1 ELSE 0 END AS cost_extreme,
        
        -- Survival anomalies
        CASE WHEN Survival_Years < 0 THEN 1 ELSE 0 END AS survival_negative,
        CASE WHEN Survival_Years > 20 THEN 1 ELSE 0 END AS survival_exceptional,
        
        -- Severity score anomalies
        CASE WHEN Target_Severity_Score < 0 OR Target_Severity_Score > 10 THEN 1 ELSE 0 END AS severity_out_of_range,
        
        -- Missing critical fields
        CASE WHEN Gender IS NULL OR Gender = '' THEN 1 ELSE 0 END AS gender_missing,
        CASE WHEN Cancer_Type IS NULL OR Cancer_Type = '' THEN 1 ELSE 0 END AS cancer_type_missing,
        CASE WHEN Cancer_Stage IS NULL OR Cancer_Stage = '' THEN 1 ELSE 0 END AS stage_missing,
        
        -- Logical inconsistencies
        CASE WHEN Cancer_Stage = 'Stage I' AND Target_Severity_Score > 8 THEN 1 ELSE 0 END AS stage_severity_mismatch,
        CASE WHEN Survival_Years > (2024 - Year + 1) THEN 1 ELSE 0 END AS survival_exceeds_diagnosis_period
    FROM [Global Cancer Patients Analysis]..[global_cancer_patients_2015_202$]
)
SELECT 
    Patient_ID,
    Age,
    Gender,
    Country_Region,
    Year,
    Cancer_Type,
    Cancer_Stage,
    Treatment_Cost_USD,
    Survival_Years,
    Target_Severity_Score,
    
    -- Total anomaly count
    (age_invalid + age_minor + cost_invalid + cost_extreme + 
     survival_negative + survival_exceptional + severity_out_of_range +
     gender_missing + cancer_type_missing + stage_missing +
     stage_severity_mismatch + survival_exceeds_diagnosis_period) AS total_anomalies,
    
    -- Specific anomaly flags
    CASE WHEN age_invalid = 1 THEN 'Age Invalid, ' ELSE '' END +
    CASE WHEN age_minor = 1 THEN 'Age Minor, ' ELSE '' END +
    CASE WHEN cost_invalid = 1 THEN 'Cost Invalid, ' ELSE '' END +
    CASE WHEN cost_extreme = 1 THEN 'Cost Extreme, ' ELSE '' END +
    CASE WHEN survival_negative = 1 THEN 'Survival Negative, ' ELSE '' END +
    CASE WHEN survival_exceptional = 1 THEN 'Survival >20yrs, ' ELSE '' END +
    CASE WHEN severity_out_of_range = 1 THEN 'Severity Out of Range, ' ELSE '' END +
    CASE WHEN gender_missing = 1 THEN 'Gender Missing, ' ELSE '' END +
    CASE WHEN cancer_type_missing = 1 THEN 'Cancer Type Missing, ' ELSE '' END +
    CASE WHEN stage_missing = 1 THEN 'Stage Missing, ' ELSE '' END +
    CASE WHEN stage_severity_mismatch = 1 THEN 'Stage-Severity Mismatch, ' ELSE '' END +
    CASE WHEN survival_exceeds_diagnosis_period = 1 THEN 'Survival Timeline Invalid, ' ELSE '' END AS anomaly_details
FROM anomaly_checks
WHERE (age_invalid + age_minor + cost_invalid + cost_extreme + 
       survival_negative + survival_exceptional + severity_out_of_range +
       gender_missing + cancer_type_missing + stage_missing +
       stage_severity_mismatch + survival_exceeds_diagnosis_period) > 0
ORDER BY total_anomalies DESC, Patient_ID;

-- Anomaly summary report
SELECT 
    'Age Invalid (<0 or >120)' AS anomaly_type,
    SUM(CASE WHEN Age < 0 OR Age > 120 THEN 1 ELSE 0 END) AS affected_records,
    ROUND(100.0 * SUM(CASE WHEN Age < 0 OR Age > 120 THEN 1 ELSE 0 END) / COUNT(*), 2) AS pct_of_dataset
FROM [Global Cancer Patients Analysis]..[global_cancer_patients_2015_202$]

UNION ALL

SELECT 
    'Treatment Cost Invalid (<=0 or NULL)',
    SUM(CASE WHEN Treatment_Cost_USD <= 0 OR Treatment_Cost_USD IS NULL THEN 1 ELSE 0 END),
    ROUND(100.0 * SUM(CASE WHEN Treatment_Cost_USD <= 0 OR Treatment_Cost_USD IS NULL THEN 1 ELSE 0 END) / COUNT(*), 2)
FROM [Global Cancer Patients Analysis]..[global_cancer_patients_2015_202$]

UNION ALL

SELECT 
    'Survival Years Negative',
    SUM(CASE WHEN Survival_Years < 0 THEN 1 ELSE 0 END),
    ROUND(100.0 * SUM(CASE WHEN Survival_Years < 0 THEN 1 ELSE 0 END) / COUNT(*), 2)
FROM [Global Cancer Patients Analysis]..[global_cancer_patients_2015_202$]

UNION ALL

SELECT 
    'Missing Cancer Type',
    SUM(CASE WHEN Cancer_Type IS NULL OR Cancer_Type = '' THEN 1 ELSE 0 END),
    ROUND(100.0 * SUM(CASE WHEN Cancer_Type IS NULL OR Cancer_Type = '' THEN 1 ELSE 0 END) / COUNT(*), 2)
FROM [Global Cancer Patients Analysis]..[global_cancer_patients_2015_202$]

UNION ALL

SELECT 
    'Missing Cancer Stage',
    SUM(CASE WHEN Cancer_Stage IS NULL OR Cancer_Stage = '' THEN 1 ELSE 0 END),
    ROUND(100.0 * SUM(CASE WHEN Cancer_Stage IS NULL OR Cancer_Stage = '' THEN 1 ELSE 0 END) / COUNT(*), 2)
FROM [Global Cancer Patients Analysis]..[global_cancer_patients_2015_202$];





-- Q18: EXECUTIVE HEALTHCARE DASHBOARD - COMPREHENSIVE KPIs
-- Provide leadership with a single-query dashboard showing all critical oncology program metrics for strategic decision-making.

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
