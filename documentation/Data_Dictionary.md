#  Data Dictionary

## Dataset Overview
- **Source:** Global Cancer Patients Analysis Database
- **Period:** 2015-2024 (10 years)
- **Grain:** One record per patient diagnosis
- **Update:** Annual

## Schema

### Identifiers
| Field | Type | Description | Use |
|-------|------|-------------|-----|
| Patient_ID | VARCHAR | Unique identifier | Tracking, deduplication |
| Year | INT | Diagnosis year (2015-2024) | Temporal analysis |

### Demographics  
| Field | Type | Description | Valid Values |
|-------|------|-------------|--------------|
| Age | INT | Age at diagnosis | 0-120 |
| Gender | VARCHAR | Patient gender | Male, Female, Other |
| Country_Region | VARCHAR | Geographic location | Various |

### Clinical Information
| Field | Type | Description | Valid Values |
|-------|------|-------------|--------------|
| Cancer_Type | VARCHAR | Type diagnosed | Lung, Breast, Prostate, etc. |
| Cancer_Stage | VARCHAR | Stage at diagnosis | Stage I, II, III, IV |
| Target_Severity_Score | DECIMAL | Clinical severity | 0-10 (0=minimal, 10=critical) |

### Risk Factors
| Field | Type | Description | Range |
|-------|------|-------------|-------|
| Genetic_Risk | DECIMAL | Genetic predisposition | 0.0-1.0 |
| Smoking | INT | Smoking intensity | 0-10 (0=non-smoker) |
| Alcohol_Use | INT | Alcohol consumption | 0-10 (0=non-drinker) |
| Obesity_Level | DECIMAL | BMI-based measure | <18.5 to 40+ |

### Outcomes
| Field | Type | Description | Range |
|-------|------|-------------|-------|
| Survival_Years | DECIMAL | Years post-diagnosis | 0-20+ |
| Treatment_Cost_USD | DECIMAL | Total treatment cost | $0-$1M+ |

## Data Quality Notes

**Completeness:**
- High (>95%): Patient_ID, Year, Cancer_Type, Stage
- Medium (85-95%): Age, Gender, Treatment_Cost
- Variable (70-85%): Risk factors
- Low (<70%): Genetic_Risk (requires testing)

**Known Characteristics:**
- Patient_ID: Should be 100% unique
- Stage distribution: Expect 20-40% Stage I, 15-25% Stage IV
- Survival >20 years: Rare but valid
- Cost >$500K: Requires validation

## Business Rules
- Age <18: Flagged for review (pediatric)
- Survival should not exceed (2024 - Diagnosis_Year + 1)
- Stage I with Severity >8: Potential mismatch
- Treatment Cost ≤0: Data entry error

## Risk Categories Used

**Smoking:**
- Non-Smoker: 0
- Light: 1-2
- Moderate: 3-5
- Heavy: 6+

**Alcohol:**
- Non-Drinker: 0
- Light: 1-2
- Moderate: 3-5
- Heavy: 6+

**Obesity (BMI):**
- Normal: <25
- Overweight: 25-29.9
- Obese I: 30-34.9
- Obese II+: ≥35

**Age Cohorts:**
1. Under 30: Young Adults
2. 30-39: Early Middle Age
3. 40-49: Middle Age
4. 50-59: Late Middle Age
5. 60-69: Early Senior
6. 70+: Senior

## Usage Guidelines

**For Analysts:**
- Always run Q1 (data quality) first
- Document exclusions/transformations
- Check for temporal anomalies
- Verify patient_id uniqueness

**For Stakeholders:**
- Costs in USD (not inflation-adjusted)
- Survival measured from diagnosis
- Geographic regions may vary in data quality
- Missing risk data ≠ absence of risk
