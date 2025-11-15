
# 📊 Churn Analysis & Prediction – GitHub Project

A complete end‑to‑end **Customer Churn Analysis & Prediction** system leveraging  
**SQL**, **Python (Machine Learning)**, and **Power BI** to understand churn drivers,  
predict churn probability, and deliver actionable business insights.

---

## 🚀 Features

- 🔹 Full ETL Pipeline using SQL  
- 🔹 Cleaned & Transformed Dataset for BI & ML  
- 🔹 Machine Learning Model for Churn Prediction  
- 🔹 Interactive Power BI Dashboard  
- 🔹 Professional Documentation + Workflow Summary

---

## 🧩 Project Structure

```
├── data/
│   ├── dashboard_summary.xlsx
│   └── (raw/clean data assets)
│
├── sql/
│   ├── Upload_file.sql
│   ├── Check_Null.sql
│   ├── Remove_Nulls.sql
│   └── View_Power_BI.sql
│
├── notebooks/
│   └── Churn Prediction.ipynb
│
├── reports/
│   ├── Unified_Presentation.pptx
│   └── README.pdf
│
└── README.md
```

---

## 🛠 SQL Workflow (ETL Pipeline)

### **1️⃣ Upload_file.sql – Initial Exploration**
- Loads data into staging table  
- Generates demographic, contract, and revenue insights  

### **2️⃣ Check_Null.sql – Data Quality Audit**
- Inspects NULL counts for all fields  

### **3️⃣ Remove_Nulls.sql – Cleaning & Standardization**
- Replaces missing values with defaults  
- Loads final dataset into `prod_Churn`  

### **4️⃣ View_Power_BI.sql – BI Layer**
Creates:
- `vw_ChurnData`
- `vw_JoinData`

Used directly in Power BI.

---

## 🤖 Machine Learning Workflow

### **✔ Data Preprocessing**
- One‑hot encoding  
- Scaling  
- Handling class imbalance  

### **✔ EDA**
- Churn distribution  
- Correlation matrix  
- Service usage patterns  

### **✔ Models Used**
- Logistic Regression  
- Random Forest  
- XGBoost  

### **✔ Evaluation Metrics**
- Accuracy  
- F1 Score  
- ROC–AUC  
- Confusion Matrix  

---

## 📈 Power BI Dashboard Insights

- Churn vs Retained customer overview  
- High-risk customer segments  
- State-wise churn heatmaps  
- Revenue loss breakdown  
- Contract-wise churn patterns  

---

## 📦 Installation & Setup

### **1. Clone this repository**
```
git clone https://github.com/yourusername/churn-analysis.git
cd churn-analysis
```

### **2. Install Python dependencies**
```
pip install -r requirements.txt
```

### **3. Run SQL scripts**
Execute scripts in the following order:
```
1. Upload_file.sql
2. Check_Null.sql
3. Remove_Nulls.sql
4. View_Power_BI.sql
```

### **4. Open ML Notebook**
```
notebooks/Churn Prediction.ipynb
```

### **5. Open Power BI Dashboard**
Located in `reports/`.

---

## 📬 Author

**Jaskar Jeyabalan**  
Churn Analytics | SQL | Power BI | Machine Learning  

---

## ⭐ Support the Project
If this project helped you, please ⭐ **star the repository**!
