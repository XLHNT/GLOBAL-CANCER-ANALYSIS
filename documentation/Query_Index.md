# Query Index - Business Questions Mapped to SQL

## Quick Reference

| Query | File | Business Question | 
|-------|------|-------------------|
| Q1 | 01_data_quality.sql | Is our dataset reliable? | 
| Q2 | 02_temporal_analysis.sql | How have diagnoses evolved? | 
| Q3 | 03_cancer_distribution.sql | Which cancers need funding? |
| Q4 | 04_demographics.sql | Who are our patients? | 
| Q5 | 05_risk_factors.sql | Which prevention programs work? |
| Q12 | 12_executive_dashboard.sql | What's our performance? | 

## Detailed Descriptions

### Q1: Data Quality Assessment
**Business Question:** Is our data reliable for decision-making?

**Answers:**
- Missing value percentages by field
- Duplicate patient detection
- Anomaly flags (invalid ages, extreme costs)
- Data integrity summary

**When to Use:**
- Before ANY analysis (run first always)
- Monthly data quality monitoring
- After data imports
- When results seem unexpected

**Stakeholders:** Data Engineers, Analysts, QA

---

### Q2: Temporal Trends Analysis  
**Business Question:** How has patient volume changed year-over-year?

**Answers:**
- Are diagnoses increasing/decreasing?
- Year-over-year growth rates
- Treatment cost evolution
- Patient age trends

**When to Use:**
- Annual strategic planning
- Budget forecasting
- Capacity planning
- Grant applications

**Stakeholders:** CFO, Operations, Strategic Planning

---

### Q3: Cancer Type Distribution
**Business Question:** Which cancers need priority for funding?

**Answers:**
- Most prevalent cancer types
- Survival rates by cancer
- Average treatment costs
- Late-stage diagnosis rates

**When to Use:**
- Allocating research funding
- Planning facility expansions
- Staffing decisions
- Equipment purchases

**Stakeholders:** CMO, Finance, Research Directors

---

### Q4: Patient Demographics
**Business Question:** Who should we target for screening?

**Answers:**
- Age distribution patterns
- Highest incidence age groups
- Most common cancers by age
- Outcomes by age cohort

**When to Use:**
- Designing screening programs
- Marketing preventive care
- Community outreach
- Patient education

**Stakeholders:** Public Health, Marketing, Program Managers

---

### Q5: Risk Factor Impact
**Business Question:** Which prevention programs have highest ROI?

**Answers:**
- Smoking impact on survival
- Obesity effect on outcomes
- Alcohol use correlation
- Population size per risk category

**When to Use:**
- Designing prevention programs
- ROI calculations for wellness
- Grant applications
- Patient education priorities

**Stakeholders:** Prevention Team, Wellness, Public Health

---

### Q12: Executive Dashboard
**Business Question:** How is our program performing overall?

**Answers:**
- Annual KPI summary (10+ metrics)
- Volume, cost, outcome trends
- Stage mix (early vs. late detection)
- Performance ratings vs. targets

**When to Use:**
- Monthly/quarterly board meetings
- Annual strategic reviews
- Investor/donor meetings
- Regulatory reporting

**Stakeholders:** CEO, CFO, Board, C-Suite

---

## Execution Recommendations

**Order:**
1. Q1: Data Quality (ALWAYS FIRST)
2. Q2: Temporal Trends (understand patterns)
3. Q3: Cancer Distribution (know portfolio)
4. Q4: Demographics (know patients)
5. Q5: Risk Factors (as needed)
6. Q12: Executive Dashboard (comprehensive view)

**Customization Required:**
```sql
-- Update this in EVERY query:
FROM [Global Cancer Patients Analysis]..[global_cancer_patients_2015_202$]

-- Replace with your structure:
FROM your_database.your_schema.your_table
```
