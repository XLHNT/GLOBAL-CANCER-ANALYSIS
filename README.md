# Global Cancer Patient Analysis (2015-2024)
### Advanced SQL Healthcare Analytics Portfolio Project

![SQL](https://img.shields.io/badge/SQL-Advanced-blue)
![Healthcare](https://img.shields.io/badge/Domain-Healthcare-green)
![Status](https://img.shields.io/badge/Status-Complete-success)

## Project Overview

This project demonstrates advanced SQL analytics applied to a comprehensive global cancer patient dataset spanning 2015-2024. Through 18 sophisticated queries, I analyze patient demographics, treatment outcomes, risk factors, geographic trends, and healthcare economics to deliver actionable insights for healthcare decision-makers.

**Key Focus Areas:**
- Patient population demographics and temporal trends
- Cancer type prevalence and stage distribution  
- Treatment cost analysis and resource allocation
- Survival rate analysis by multiple factors
- Risk factor impact assessment (smoking, alcohol, obesity, genetics)
- Geographic healthcare access and outcome disparities
- Data quality and anomaly detection

## Business Problem Statement

Healthcare organizations face critical challenges in:
1. **Resource Allocation** - Determining which cancer types require priority funding
2. **Prevention Programs** - Identifying high-ROI interventions based on modifiable risk factors
3. **Early Detection** - Understanding demographic patterns to optimize screening programs
4. **Treatment Optimization** - Analyzing cost-effectiveness and outcome predictors
5. **Health Equity** - Identifying geographic and demographic disparities

This analysis provides data-driven answers to guide strategic healthcare investments and improve patient outcomes.

## Key Findings

### 1. Critical Resource Allocation Insights
- **Lung Cancer** represents 22%+ of cases, requiring immediate facility expansion
- **Stage IV diagnoses** account for 35% of cases, indicating urgent need for earlier screening
- Treatment costs show 15% year-over-year increase, demanding cost optimization

### 2. Prevention Program ROI Analysis  
- **Heavy smokers** show 40% lower survival rates vs. non-smokers
- **Combined risk factors** (smoking + obesity + alcohol) reduce survival by up to 3.5 years
- Targeting smoking cessation could impact 30% of patient population

### 3. Demographic Screening Priorities
- **60-69 age cohort** represents peak cancer incidence (28% of cases)
- **Early middle age (30-49)** shows concerning trends requiring targeted screening
- Gender-specific patterns indicate need for differentiated protocols

### 4. Geographic Healthcare Disparities
- 25% variance in survival rates across countries/regions
- Treatment cost disparities correlate with delayed diagnosis
- Specific geographic clusters identified for intervention

### 5. Genetic vs. Lifestyle Risk Impact
- **High genetic risk** patients demonstrate 35% higher treatment costs
- **Modifiable risk factors** show greater survival impact than genetic factors alone
- Combination screening identifies highest-risk populations

## Business Value Delivered

| Business Question | SQL Technique | Key Insight |
|-------------------|---------------|-------------|
| Which cancers need priority funding? | Aggregation, stage analysis | Lung cancer facility expansion needed |
| What's our early detection rate? | Stage distribution, YoY trends | 35% late-stage requires intervention |
| Which prevention programs have highest ROI? | Risk factor correlation | Smoking cessation impacts 30% |
| Are treatment costs sustainable? | Trend analysis, LAG functions | 15% annual increase needs optimization |
| Where are healthcare access gaps? | Geographic clustering | 25% survival variance across regions |

## Technical Skills Demonstrated

### Advanced SQL Techniques
-  **Common Table Expressions (CTEs)** - Multi-level data transformation
-  **Window Functions** - LAG, LEAD, RANK, DENSE_RANK for trend analysis  
-  **Complex JOINs** - Multi-table analysis
-  **Subqueries** - Nested queries for sophisticated filtering
-  **Conditional Aggregation** - CASE statements within aggregate functions
-  **Year-over-Year Analysis** - Temporal trend identification
-  **Percentile Calculations** - Distribution analysis
-  **Data Quality Validation** - Null checks, anomaly detection
-  **Statistical Functions** - AVG, STDEV, correlation analysis
-  **String Manipulation** - Data categorization

### Healthcare Analytics Expertise
- Patient cohort analysis and segmentation
- Survival rate calculations  
- Treatment cost modeling and resource allocation
- Risk factor correlation and impact assessment
- Clinical outcome measurement (5-year survival rates)
- Geographic health disparity identification

### Business Intelligence Skills
- KPI dashboard design
- Executive summary creation
- ROI analysis for healthcare interventions
- Data-driven decision support
- Stakeholder communication

## Repository Structure
```

Global-Cancer-Analysis/
│
├── README.md                        # Project overview and key findings
│
├── sql/                             # SQL query files by category
│   ├── 01_data_quality.sql          # Data completeness and integrity    
│   ├── 02_temporal_analysis.sql     # Yea-over-year trends
│   ├── 03_cancer_distribution.sql   # Cancer type prevalence
│   ├── 04_demographics.sql          # Patient demographic profiles
│   ├── 05_risk_factors.sql          # Lifestyle and genetic risk analysis
│   └── 12_executive_dashboard.sql   # Comprehensive KPI dashboard
│
└── documentation/
    ├── Data_Dictionary.md           # Dataset schema and field definitions
    ├── Business_Insights.md         # Detailed findings and recommendations
    ├── Query_Index.md               # Business questions mapped to queries
    └── Methodology.md               # Analysis approach and assumptions
```

## How to Use This Repository

### For Recruiters & Hiring Managers
1. **Start with README.md** - Understand business context
2. **Review Query_Index.md** - See business questions answered
3. **Explore sql/ folder** - Examine query complexity
4. **Check Business_Insights.md** - Review analytical findings

### For Data Analysts
1. **Examine sql/ queries** - Review query optimization
2. **Check Data_Dictionary.md** - Understand data structure
3. **Review Methodology.md** - Learn analytical approach
4. **Adapt queries** for your own datasets

### Running the Queries
```sql
-- Update database references in each query:
-- FROM [Global Cancer Patients Analysis]..[global_cancer_patients_2015_202$]
-- Replace with: FROM your_database.schema.table

-- Execute in order:
-- 1. 01_data_quality.sql (always first)
-- 2. 02-05 analytical queries
-- 3. 12_executive_dashboard.sql (comprehensive summary)
```

## Sample Insights

**Cancer Type Distribution (Top 5)**
| Cancer Type | Cases | % Total | Avg Survival | Avg Cost |
|-------------|-------|---------|--------------|----------|
| Lung        | 15,234| 22.4%   | 4.2 years    | $125,000 |
| Breast      | 12,891| 18.9%   | 8.1 years    | $95,000  |
| Prostate    | 10,456| 15.3%   | 9.3 years    | $78,000  |
| Colorectal  | 8,723 | 12.8%   | 6.5 years    | $105,000 |
| Skin        | 7,234 | 10.6%   | 11.2 years   | $42,000  |

**Risk Factor Impact on Survival**
| Risk Factor     | Non-Exposed | Exposed   | Difference   |
|-----------------|-------------|-----------|--------------|
| Heavy Smoking   | 8.2 years   | 4.9 years | -3.3y (-40%) |
| Obesity Class II| 7.5 years   | 5.8 years | -1.7y (-23%) |
| Heavy Alcohol   | 7.8 years   | 6.1 years | -1.7y (-22%) |
| High Genetic    | 6.9 years   | 5.4 years | -1.5y (-22%) |

## Learning Outcomes

Through this project, I demonstrated:
- **Business Translation** - Converting complex data into executive insights
- **Technical Excellence** - Advanced SQL for sophisticated analytics
- **Healthcare Domain Knowledge** - Understanding clinical metrics
- **Data Quality Focus** - Comprehensive validation before analysis  
- **Storytelling** - Clear communication to non-technical stakeholders

## Connect With Me

**Isuekebho Excel**
- xcelisuekebho@gmail.com

---

*This project demonstrates advanced SQL analytics for healthcare decision support.*

