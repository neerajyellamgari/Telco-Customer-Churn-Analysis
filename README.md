# Customer Churn Analysis – Telecom Sector (SQL + Power BI)

# Overview  
This project analyzes customer churn in the telecom industry to identify key factors influencing retention and revenue loss. Using **SQL Server** for data preparation and **Power BI** for visualization, the project delivers an interactive dashboard that helps stakeholders understand churn patterns and make data-driven decisions.  

---

# Dataset  
- Source: Telco Customer Churn Dataset (Kaggle / CSV file)  
- Records: ~7,000 customers  
- Key Columns:  
  - `customer_id`  
  - `tenure`  
  - `monthly_charge`  
  - `total_revenue`  
  - `churn_label`  
  - `contract`  
  - `internet_service`  
  - `payment_method`  
  - `satisfaction_score`  

---

# Process  

## Step 1: Data Preparation (SQL Server)  
- Imported CSV into SQL Server database.  
- Standardized column names (replaced spaces with underscores).  
- Converted data types (e.g., tenure → INT, charges → FLOAT).  
- Handled null/missing values.  
- Created **profiling queries**: churn %, revenue analysis, churn by contract/internet service.  

## Step 2: Data Visualization (Power BI)  
- Connected SQL Server table to Power BI.  
- Created **DAX measures**:  
  - `Customer Count`  
  - `Churners`  
  - `Churn %`  
  - `Total Revenue`  
  - `Avg Revenue per Customer`  
- Built an interactive dashboard with KPI cards, bar charts, pie charts, and slicers.  
- Applied consistent **color coding**:  
  - Churn Yes = Red, Churn No = Green  
  - Male = Blue, Female = Pink  

---

#  Dashboard Features  
- **KPI Cards**: Total Customers, Churners, Churn %, Total Revenue, Avg Revenue per Customer  
- **Visuals**:  
  - Churners by Contract Type (Bar Chart)  
  - Churners by Internet Service (Bar Chart)  
  - Churn % by Tenure Group (Stacked Column Chart)  
  - Revenue by Churn Label (Pie Chart)  
  - Avg Satisfaction by Churn Status (Bar Chart)  
  - Avg Monthly Charge by Churn Status (Bar Chart)  
  - Customer Count by Gender (Donut Chart)  
- **Slicers**: Contract, Internet Service, Payment Method, Offer, Churn Label  

---

# Key Insights  
- Customers on **month-to-month contracts** have the **highest churn rate**.  
- **Fiber optic internet users** churn more than DSL customers.  
- Customers with **low tenure (<1 year)** churn at a significantly higher rate.  
- Churners represent a **smaller customer base but a large revenue impact**.  

---

# Tools & Skills  
- **SQL Server**: Data ingestion, cleaning, transformation, queries  
- **Power BI**: Dashboard design, DAX measures, data modeling  
- **Data Analytics Skills**: ETL, KPI creation, churn analysis, storytelling  
