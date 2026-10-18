# 📊 Churn Analysis & Prediction

End-to-end **customer churn analysis and prediction** using **SQL Server**, **Power BI** and **Python (scikit-learn)**:
clean the data in SQL, analyse churn in a Power BI dashboard, and score newly joined customers for churn risk.

---

## 🧩 Project structure

```
Churn_Prediction/
├── data/
│   ├── raw/Customer_Data.csv              raw source data (6,418 customers)
│   └── clean/
│       ├── Prediction_Data.xlsx           vw_ChurnData + vw_JoinData (cleaned, = SQL views)
│       ├── Predictions.csv                joiners flagged as likely churners (loaded in Power BI)
│       └── Predictions_All_Joiners.csv    all 411 joiners with probability + risk band
├── sql/
│   ├── Upload_file.sql                    staging load + data profiling
│   ├── Check_Null.sql                     NULL audit
│   ├── Remove_Nulls.sql                   cleaning: stg_Churn -> prod_Churn
│   └── View_Power_BI.sql                  vw_ChurnData / vw_JoinData
├── power BI/
│   ├── Churn Analysis.pbix                dashboard (see CHANGES.md for the manual refresh steps)
│   ├── Power Query.docx                   Power Query steps and DAX measures
│   ├── Background/  Images/
├── notebook/
│   ├── Churn Prediction.ipynb             EDA, modelling, scoring
│   └── churn_model.joblib                 trained model + threshold
├── reports/  Presentation.pptx, README.pdf, model_outputs/
├── CHANGES.md                             what was corrected and why
└── requirements.txt
```

## 🛠 SQL workflow

Run in this order: `Upload_file.sql` -> `Check_Null.sql` -> `Remove_Nulls.sql` -> `View_Power_BI.sql`.

Cleaning rules in `Remove_Nulls.sql` (every NULL has a real meaning in this data):

| Column(s) | NULL means | Replaced with |
|---|---|---|
| Online_Security, Online_Backup, Device_Protection_Plan, Premium_Support, Streaming_TV/Movies/Music, Unlimited_Data | customer has no internet (1,390) | `No Internet` |
| Multiple_Lines | customer has no phone service (622) | `No Phone Service` |
| Internet_Type, Value_Deal | no internet / no deal | `None` |
| Churn_Category, Churn_Reason | customer did not churn (4,686) | `Not Applicable` |
| Monthly_Charge < 0 | invalid value (107 rows) | median valid charge of the same Internet_Type |

## 📈 Power BI dashboard

Two main pages: **Summary** (executive KPIs, demographics, account, geography, churn reasons, services) and **Churn Prediction** (profile of customers at risk, with probability and risk band).

**KPI definitions**

* Total Customers = 6,418 (all customers) - New Joiners = 411 - Total Churn = 1,732
* **Churn Rate = Churned / (Churned + Stayed) = 1,732 / 6,007 = 28.8%.** Joiners are excluded from the denominator because their outcome is not known yet.

## 🔎 Key findings (Churned vs Stayed, 6,007 customers, 28.8% churn)

* **Contract is the strongest driver:** Month-to-Month 52% churn vs 11% One Year and 3% Two Year.
* **High-risk groups:** Deal 5 (69%), Fiber Optic (42%), Mailed-Check payers (43%), customers aged 65+ (42%).
* **Tenure alone barely separates churners** (27-30% in every tenure group), and the top competitor-related reasons are better devices and better offers.

## 🤖 Machine learning

* **Target:** Churned (1) vs Stayed (0) on the 6,007 customers with a known outcome. Joiners are scored, never trained on.
* **Removed features:** `Customer_ID`, `Churn_Category`/`Churn_Reason` (only exist after churning = leakage) and the five **cumulative-charge columns** (`Total_Charges`, `Total_Revenue`, `Total_Refunds`, `Total_Extra_Data_Charges`, `Total_Long_Distance_Charges`). For joiners these are only ~11% of what tenure x monthly charge implies (labelled customers: ~195%), so keeping them made the model call 92% of joiners churners.
* **Method:** one-hot encoding, stratified 80/20 split, 5-fold cross-validation, threshold chosen on out-of-fold training predictions (not the test set).

**Test-set results (1,202 customers)**

| Model | CV AUC | Test AUC | Precision | Recall | F1 |
|---|---|---|---|---|---|
| Logistic Regression (selected) | 0.880 | 0.873 | 0.631 | 0.772 | 0.694 |
| Random Forest | 0.880 | 0.872 | 0.673 | 0.741 | 0.705 |
| Gradient Boosting | 0.874 | 0.868 | 0.675 | 0.689 | 0.682 |

Logistic Regression is selected because it ties Random Forest on cross-validated AUC and is simpler to explain. Contract type and monthly charge are the dominant drivers.

**Scoring the 411 joiners:** 215 flagged (156 High, 59 Medium, 196 Low). This is high because joiners are 89% Month-to-Month (labelled customers: 49%) and 39% are on Deal 5 (69% historic churn). Use `Churn_Probability` / `Risk_Band` to prioritise the High group rather than treating all 215 equally. The joiner mix differs from the training mix (Deals 1-4 never appear among joiners), so treat the scores as a prioritisation aid, not a guarantee.

**Business impact:** savings = historic churners in segment x retention rate x annual revenue per customer (monthly charge x 12). At a 10% retention rate: about INR 1.54 lakh per year (Month-to-Month contributes most).

## ▶ How to run

```
pip install -r requirements.txt
# 1. SQL Server: run the four scripts in /sql (import Customer_Data.csv into stg_Churn first)
# 2. Export vw_ChurnData and vw_JoinData to data/clean/Prediction_Data.xlsx (or use the supplied file)
# 3. Run notebook/Churn Prediction.ipynb  -> writes Predictions.csv, model outputs, charts
# 4. Open power BI/Churn Analysis.pbix and refresh (see CHANGES.md)
```

## 📬 Author
Jaskar Jeyabalan
