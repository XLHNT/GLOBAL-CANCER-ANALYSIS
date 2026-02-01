#  Analysis Methodology

## Approach Overview

This project uses a **multi-layered SQL analytics framework**:

DATA QUALITY FOUNDATION
↓
EXPLORATORY ANALYSIS
↓
TEMPORAL TRENDS
↓
RISK FACTOR CORRELATION
↓
MULTI-DIMENSIONAL SYNTHESIS
↓
EXECUTIVE DECISION SUPPORT

## Key Techniques

### 1. Data Quality Validation
**Purpose:** Ensure analytical reliability

**Methods:**
- Completeness assessment (% missing values)
- Uniqueness validation (no duplicates)
- Range validation (logical bounds)
- Consistency checks (logical conflicts)

**SQL Techniques:**
```sql
-- Completeness
COUNT(*) - COUNT(field) AS missing_values

-- Uniqueness  
COUNT(DISTINCT Patient_ID) vs COUNT(*)

-- Multi-rule anomaly detection
WITH anomaly_checks AS (
    SELECT CASE WHEN Age < 0 THEN 1 ELSE 0 END AS flag
    ...
)
```

### 2. Temporal Trend Analysis
**Purpose:** Identify year-over-year changes

**Methods:**
- Window functions (LAG) for YoY comparison
- Growth rate calculations
- CTEs for multi-step aggregation

**SQL Techniques:**
```sql
-- LAG for YoY
LAG(total) OVER (ORDER BY Year) AS prev_year

-- Growth percentage
100.0 * (current - prev) / NULLIF(prev, 0)
```

### 3. Distribution Analysis
**Purpose:** Understand prevalence patterns

**Methods:**
- GROUP BY aggregation
- Conditional aggregation (CASE in SUM)
- Percentage of total with window functions

**SQL Techniques:**
```sql
-- % of total
COUNT(*) / SUM(COUNT(*)) OVER() AS pct

-- Conditional counts
SUM(CASE WHEN Stage = 'IV' THEN 1 ELSE 0 END)
```

### 4. Risk Factor Correlation
**Purpose:** Quantify modifiable risk impact

**Methods:**
- Categorical risk levels
- Baseline comparison
- Impact quantification

**SQL Techniques:**
```sql
-- Risk categorization
CASE 
    WHEN Smoking = 0 THEN 'Non-Smoker'
    WHEN Smoking <= 2 THEN 'Light'
    ...
END

-- Baseline comparison
AVG(Survival) - (SELECT AVG(Survival) WHERE category = 'baseline')
```

## Assumptions

**Data:**
- All patient data anonymized/HIPAA-compliant
- Costs in USD (not inflation-adjusted)
- Survival measured from diagnosis date
- Geographic regions at country/region level

**Analytical:**
- Correlation ≠ causation
- Age, cancer type, stage are confounding variables
- Missing risk factors 30-50% incomplete
- Recent diagnoses have censored survival data

**Statistical:**
- Large N reduces random variation
- Multiple testing increases false discovery risk
- Treatment costs >$500K and survival >20yrs are valid but rare

## Quality Assurance

**Validation Steps:**
1.  Run Q1 (data quality) first
2.  Verify percentages sum to 100%
3.  Ensure results align with medical knowledge
4.  Cross-check metrics across queries
5.  Stakeholder review by domain experts

## Ethical Considerations

**Privacy:**
- All analyses use anonymized data (no PII)
- Aggregate statistics only
- HIPAA compliant

**Bias Awareness:**
- Geographic disparities analyzed to IMPROVE equity
- Risk factor analysis for PREVENTION not blame
- Age/gender segmentation for TARGETED CARE

**Responsible Use:**
- Findings improve patient outcomes
- Recommendations prioritize patient welfare
- Transparency in methodology and limitations

## Technical Environment

**SQL Dialect:** Microsoft SQL Server T-SQL  
**Key Features:** LAG/LEAD, CTEs, CASE expressions

**Optimization:**
- Index Patient_ID, Year, Cancer_Type
- CTEs for readability
- Filter early (WHERE before GROUP BY)

## Future Enhancements

**Analytical:**
- Predictive modeling for survival
- Time-series forecasting for volumes
- Patient clustering analysis
- QALY calculations

**Technical:**
- Automated monthly KPI updates
- Power BI/Tableau dashboards
- Anomaly alerting
- Real-time data integration
