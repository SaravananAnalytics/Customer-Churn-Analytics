# Customer Churn Analysis

### Telecom Customer Churn Analysis using Python, SQL & Power BI

A complete data analytics project analyzing customer churn for a telecom subscription business using **Python, SQL, and Power BI**.

The project uses descriptive analytics to identify customer segments associated with high churn, quantify recurring revenue at risk, understand when customers leave, and translate the findings into actionable business recommendations.

---

## 📌 Table of Contents

- [Project Overview](#-project-overview)
- [Business Objectives](#-business-objectives)
- [Tools & Technologies](#-tools--technologies)
- [Repository Structure](#-repository-structure)
- [Dataset](#-dataset)
- [Data Cleaning](#-data-cleaning)
- [SQL Analysis](#-sql-analysis)
- [Power BI Dashboard](#-power-bi-dashboard)
- [Key Findings](#-key-findings)
- [High-Risk Customer Segment](#-high-risk-customer-segment)
- [Business Recommendations](#-business-recommendations)
- [Illustrative Revenue Opportunity](#-illustrative-revenue-opportunity)
- [Project Workflow](#-project-workflow)
- [Limitations](#-limitations)
- [Future Improvements](#-future-improvements)
- [Skills Demonstrated](#-skills-demonstrated)
- [Author](#-author)

---

# 📊 Project Overview

Customer churn is an important business problem for subscription-based companies.

When a customer cancels their subscription, the company loses recurring revenue and potentially incurs additional costs to acquire a replacement customer.

This project analyzes telecom customer data to understand:

- **Who is churning**
- **When customers are most likely to leave**
- **Which services and contracts are associated with higher churn**
- **How much recurring revenue is being lost**
- **Which customer segment represents a major concentration of churn**

The analysis follows a complete analytics workflow:

```text
Raw Dataset
     ↓
Python / Pandas
     ↓
Data Cleaning & Preparation
     ↓
SQL Analysis
     ↓
Business Insights
     ↓
Power BI Dashboard
     ↓
Retention Recommendations

The project is intentionally focused on descriptive analytics, using data cleaning, SQL aggregations, and dashboarding rather than predictive modeling.

🎯 Business Objectives

The analysis was designed to answer the following business questions:

What is the overall customer churn rate?
How much monthly recurring revenue (MRR) is being lost?
Which contract types have the highest churn?
At what point in the customer lifecycle do customers leave?
Does internet service type affect churn?
Is technical support associated with customer retention?
Which payment methods have higher churn?
Which customer segment represents a major concentration of churn?
What retention actions could the business consider?

These questions are addressed through Python, SQL, and Power BI.

🛠️ Tools & Technologies
Tool / Technology	Purpose
🐍 Python	Data cleaning and preparation
🐼 Pandas	Data manipulation and transformation
🛢️ SQL	Business analysis and aggregations
📊 Power BI	Interactive dashboard and visualization
📁 GitHub	Version control and project documentation
📂 Repository Structure
Customer Churn Analysis/
│
├── data/
│
├── deliverables/
│
├── notebooks/
│
├── queries/
│
└── README.md
data/

Contains the raw and processed datasets used throughout the project.

notebooks/

Contains the Python/Pandas analysis used for:

Data inspection
Data cleaning
Data transformation
Feature creation
Data validation
Exporting the cleaned dataset
queries/

Contains the SQL queries used to answer the business questions.

deliverables/

Contains the final project outputs, including:

Power BI dashboard
Dashboard screenshots
Supporting reports
📁 Dataset
Telco Customer Churn Dataset

The project uses the Telco Customer Churn IBM sample dataset.

Attribute	Details
Customers	7,043
Original columns	21
Observation	One row per customer
Target variable	Churn
Customer lifecycle	tenure in months

The dataset contains customer demographic, service, contract, billing, and churn information.

Important Columns
customerID
gender
SeniorCitizen
Partner
Dependents
tenure
PhoneService
MultipleLines
InternetService
OnlineSecurity
OnlineBackup
DeviceProtection
TechSupport
StreamingTV
StreamingMovies
Contract
PaperlessBilling
PaymentMethod
MonthlyCharges
TotalCharges
Churn
Dataset Sources

IBM Sample Dataset

https://raw.githubusercontent.com/IBM/telco-customer-churn-on-icp4d/master/data/Telco-Customer-Churn.csv

Kaggle

https://www.kaggle.com/datasets/blastchar/telco-customer-churn

🧹 Data Cleaning

Python and Pandas were used to prepare the dataset before performing SQL analysis and creating the Power BI dashboard.

Cleaning Process
Step 1 — Load and Inspect

The dataset was loaded using Pandas and checked for its dimensions and data types.

import pandas as pd

df = pd.read_csv("Telco-Customer-Churn.csv")

print(df.shape)
print(df.dtypes)

The dataset contains 7,043 rows and 21 columns.

TotalCharges was identified as a text column rather than a numeric column.

Step 2 — Handle TotalCharges

Although the initial null check returned zero missing values, some TotalCharges cells contained blank strings.

They were converted to numeric values:

df["TotalCharges"] = pd.to_numeric(
    df["TotalCharges"],
    errors="coerce"
)

This resulted in 11 missing values.

Step 3 — Resolve Missing Values

All 11 affected customers had:

tenure = 0

These customers had signed up during the current month and had not yet been billed.

Therefore, their TotalCharges value was treated as zero:

df["TotalCharges"] = df["TotalCharges"].fillna(0)
Step 4 — Check Duplicates

Customer IDs were checked for duplicates:

df["customerID"].duplicated().sum()

Result:

0 duplicates

Therefore, the dataset contains one row per customer.

Step 5 — Rename Columns

Column names were standardized to snake_case.

Examples:

customerID       → customer_id
SeniorCitizen    → senior_citizen
PhoneService     → phone_service
InternetService  → internet_service
TechSupport      → tech_support
PaymentMethod    → payment_method
MonthlyCharges   → monthly_charges
TotalCharges     → total_charges

The column names were then converted to lowercase.

Step 6 — Simplify Categorical Labels

Service-related columns contained values such as:

Yes
No
No internet service
No phone service

The No internet service and No phone service values were consolidated into No.

SeniorCitizen was also converted from:

0 → No
1 → Yes

Payment method labels were simplified by removing (automatic).

Step 7 — Create Analysis Columns

A binary churn flag was created:

df["churn_flag"] = (df["churn"] == "Yes").astype(int)

Tenure groups were also created:

0–12 months
13–24 months
25–48 months
49–72 months

A tenure_order column was created so Power BI could display these groups chronologically rather than alphabetically.

Step 8 — Export Cleaned Dataset

The final dataset was validated and exported:

print(df.isnull().sum().sum())

df.to_csv("telco_clean.csv", index=False)

Final result:

Rows:              7,043
Columns:              24
Missing values:        0
🛢️ SQL Analysis

The cleaned dataset can be loaded into a database table named:

telco_churn

The SQL analysis uses aggregations to answer the project's main business questions.

1. Overall Churn
Result
Metric	Value
Total Customers	7,043
Churned Customers	1,869
Churn Rate	26.5%
Total MRR	456,117
MRR Lost	139,131
MRR Lost %	30.5%

The dataset shows a 26.5% churn rate, with churned customers accounting for approximately 139K in lost monthly recurring revenue.

2. Churn by Contract
Contract Type	Churn Rate
Month-to-month	42.7%
One year	11.3%
Two year	2.8%

Month-to-month customers account for 88.6% of all churners in this dataset.

3. Churn by Customer Tenure
Tenure Group	Churn Rate
0–12 months	47.4%
13–24 months	28.7%
25–48 months	20.4%
49–72 months	9.5%

The first 12 months represent the highest observed churn period in the dataset.

4. Internet Service & Technical Support
Internet Service	Tech Support	Churn Rate
Fiber	No	49.4%
DSL	No	27.8%
Fiber	Yes	22.6%
DSL	Yes	9.7%

The combination of fiber service and no technical support shows the highest churn rate among these service combinations.

5. Churn by Payment Method
Payment Method	Churn Rate
Electronic check	45.3%
Mailed check	19.1%
Bank transfer	16.7%
Credit card	15.2%

Electronic check customers show the highest churn rate among the payment methods analyzed.

🎯 High-Risk Customer Segment

The analysis examines the following customer segment:

Contract:
Month-to-month

Internet Service:
Fiber optic

Tech Support:
No
Segment Results
Metric	Result
Customers	1,796
Churned Customers	1,033
Churn Rate	57.5%
MRR Lost	88,166

This segment represents approximately 25.5% of the total customer base, while accounting for approximately 55% of all churners and 63% of lost MRR.

📊 Power BI Dashboard

Power BI was used to convert the analytical findings into an interactive dashboard.

Dashboard KPIs

The dashboard includes four headline KPIs:

Total Customers
Churn Rate %
MRR Lost
MRR Lost %
Dashboard Visuals
Visual	Purpose
KPI Cards	Show headline business metrics
Contract Bar Chart	Compare churn across contract types
Tenure Column Chart	Show lifecycle churn
Internet + Tech Support Chart	Analyze service mix
Payment Method Chart	Identify payment-related churn patterns
Donut Chart	Compare churned vs retained customers
Contract × Internet Matrix	Identify high-churn combinations
Slicers	Filter customer attributes
📸 Dashboard Preview

Add your Power BI dashboard screenshot here:

![Customer Churn Dashboard](deliverables/screenshots/dashboard.png)
📐 Power BI Measures

The dashboard uses DAX measures including:

Total Customers =
COUNTROWS(telco)
Churned Customers =
CALCULATE(
    COUNTROWS(telco),
    telco[churn] = "Yes"
)
Churn Rate % =
DIVIDE(
    [Churned Customers],
    [Total Customers]
)
Total MRR =
SUM(telco[monthly_charges])
MRR Lost =
CALCULATE(
    SUM(telco[monthly_charges]),
    telco[churn] = "Yes"
)
MRR Lost % =
DIVIDE(
    [MRR Lost],
    [Total MRR]
)

Additional measures include:

Share of All Churn
Churn Rate vs Average
Avg Tenure Churned
Avg Monthly Bill Churned
🔥 Key Findings
1. Churn is a significant revenue issue

26.5% of customers have churned.

The resulting MRR loss is approximately 139K, representing 30.5% of total MRR.

2. Month-to-month customers show substantially higher churn

Observed churn rates:

Month-to-month   → 42.7%
One year         → 11.3%
Two year         →  2.8%

Month-to-month customers account for 88.6% of all churners in the dataset.

3. The first year is the highest-risk period

Observed churn:

0–12 months      → 47.4%
13–24 months     → 28.7%
25–48 months     → 20.4%
49–72 months     →  9.5%

Approximately 55% of all churners left within their first year.

Churned customers averaged approximately 18 months of tenure, compared with 37.6 months for retained customers.

4. Fiber customers show higher churn

Observed churn by internet service:

Fiber             → 41.9%
DSL               → 19.0%
No internet       →  7.4%

Fiber customers account for approximately 69% of all churners in this dataset.

5. Technical support is associated with lower churn

Observed churn:

Without Tech Support → 41.6%
With Tech Support    → 15.2%

Online security shows a similar pattern:

Without Online Security → 41.8%
With Online Security    → 14.6%

These are observed associations in the dataset, not proof that the services independently cause lower churn.

6. Electronic check customers show higher churn

Electronic check customers have a 45.3% churn rate, compared with 15.2%–19.1% for the other payment methods analyzed.

7. Churned customers have higher average monthly charges
Churned Customers     → 74.44 / month
Retained Customers    → 61.27 / month

The average monthly charge among churned customers is higher than among retained customers.

8. Senior citizens show higher observed churn
Senior citizens       → 41.7%
Other customers       → 23.6%

This is an observed difference in the dataset and should not be interpreted as a causal relationship.

💼 Business Recommendations

Based on the observed patterns, the analysis proposes the following retention actions.

1. Encourage Longer-Term Contracts

Consider incentives that encourage month-to-month customers to move to annual plans.

Contract type shows a strong association with observed churn in this dataset.

2. Bundle Support Services

Consider offering technical support and online security as part of introductory packages for new fiber customers.

The effectiveness of this approach should be measured after implementation.

3. Improve First-90-Day Onboarding

A structured onboarding program could include:

Setup assistance
First-bill explanation
Customer check-ins
Early service support

This recommendation is based on the high observed churn during the first year.

4. Encourage Automatic Payment Methods

Consider incentives for customers currently using electronic checks to move toward bank transfer or card payments.

5. Investigate Fiber Service

Further analysis should examine:

Fiber pricing
Competitor pricing
Service quality
Customer complaints
Outage data

The current dataset cannot determine why fiber customers have higher churn.

6. Focus Retention Analysis on the Identified Segment

The month-to-month + fiber + no-tech-support segment represents a substantial concentration of churn and lost MRR in this dataset.

💰 Illustrative Revenue Opportunity

The project includes an illustrative scenario.

If retention actions were able to save 10% of the churners in the identified high-risk segment, approximately:

103 customers
≈ 8.8K monthly revenue
≈ 106K annualized revenue

This calculation is intended to size the potential opportunity only.

It is not a forecast or prediction.

🔄 Project Workflow
                RAW DATA
                    │
                    ▼
          ┌──────────────────┐
          │ Python / Pandas  │
          │                  │
          │ • Inspect data   │
          │ • Clean data     │
          │ • Transform data │
          │ • Validate data  │
          └────────┬─────────┘
                   │
                   ▼
             CLEAN DATASET
                   │
                   ▼
          ┌──────────────────┐
          │       SQL        │
          │                  │
          │ • KPIs           │
          │ • Segmentation   │
          │ • Churn analysis │
          │ • Revenue impact │
          └────────┬─────────┘
                   │
                   ▼
            BUSINESS INSIGHTS
                   │
                   ▼
          ┌──────────────────┐
          │     Power BI     │
          │                  │
          │ • KPIs           │
          │ • Charts         │
          │ • Matrix         │
          │ • Slicers        │
          └────────┬─────────┘
                   │
                   ▼
         RETENTION RECOMMENDATIONS
⚠️ Limitations

The results should be interpreted within the limitations of the dataset and methodology.

Descriptive Analysis Only

The project identifies associations, not causation.

For example, the higher churn observed among fiber customers does not by itself establish that fiber service causes customers to leave.

Variables May Overlap

Contract type, payment method, paperless billing, and other characteristics can be related to one another.

Therefore, the observed relationship between one variable and churn may not represent an independent effect.

Single Snapshot

The dataset represents a single snapshot, so the project cannot measure:

Monthly churn trends
Year-over-year changes
Cohort changes over time
Retention trends
No Prediction

No machine learning model or churn prediction score is included.

The project intentionally focuses on descriptive analytics.

🚀 Future Improvements

Future versions of this project could extend the analysis with:

Data
Historical customer records
Customer complaint data
Service outage information
Competitor pricing
Customer support interactions
Analytics
Cohort analysis
Customer Lifetime Value
Statistical hypothesis testing
Correlation analysis
Customer segmentation
Machine Learning

A future version could introduce:

Logistic Regression
Decision Trees
Random Forest
Gradient Boosting
Churn probability scoring
Power BI

The dashboard could also be expanded with:

Drill-through pages
Tooltip pages
Customer-level detail
Trend analysis
More advanced DAX measures
Automated refresh
📈 Skills Demonstrated
Python
Pandas
Data cleaning
Data transformation
Missing-value handling
Data validation
Feature engineering
SQL
SELECT
WHERE
GROUP BY
ORDER BY
Aggregations
CASE WHEN
Common Table Expressions
Percentage calculations
Segment analysis
Power BI
Data loading
Data modeling
DAX measures
KPI cards
Bar charts
Column charts
Donut charts
Matrix / heatmap
Slicers
Conditional formatting
Dashboard design
Business Analytics
KPI analysis
Customer segmentation
Revenue-at-risk analysis
Churn analysis
Business question formulation
Insight generation
Retention recommendations
Data storytelling
📁 Project Deliverables
Customer Churn Analysis/
│
├── data/
│
├── notebooks/
│   └── customer_churn_analysis.ipynb
│
├── queries/
│   └── churn_analysis.sql
│
├── deliverables/
│   ├── dashboard/
│   │   └── churn_dashboard.pbix
│   │
│   ├── screenshots/
│   │   └── dashboard.png
│   │
│   └── reports/
│
└── README.md

Update the filenames above if your actual repository uses different filenames.

📌 Portfolio Summary
Category	Result
Total Customers	7,043
Churned Customers	1,869
Overall Churn Rate	26.5%
Total MRR	456,117
MRR Lost	139,131
MRR Lost %	30.5%
Highest Contract Churn	42.7% — Month-to-month
Highest Tenure Churn	47.4% — 0–12 months
High-Risk Segment Churn	57.5%
High-Risk Segment MRR Lost	88,166
👤 Author
Saravanan V

Data Analytics Portfolio Project

Skills

Python · SQL · Power BI · Pandas · Data Analytics · Business Intelligence

⭐ Project

If you found this project useful, feel free to explore the repository and ⭐ the project.

Python → Clean → SQL → Analyze → Power BI → Insights

Thank you for visiting the project!
