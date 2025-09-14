create database telcodb;

use telcodb;

select * from dbo.telco;

select count(*) from dbo.telco;

select top 10* from dbo.telco;

select Churn_Label, count(*) as cnt 
from dbo.telco
group by Churn_Label;

select count(distinct customer_id) as unique_customers
from telco;

select count(customer_id) as cnt
from telco
group by customer_id
having count(*)>1;

-- checking count of nulls in numeric columns
select 
	sum(case when Age is null then 1 else 0 end) as null_age,
	sum(case when Monthly_Charge is null then 1 else 0 end) as null_monthly_charge,
	sum(case when Total_Charges is null then 1 else 0 end) as null_total_charges,
	sum(case when Total_revenue is null then 1 else 0 end) as null_total_revenue,
	sum(case when Churn_Label is null then 1 else 0 end) as null_churn_label
from telco;

-- gender wise count
select gender, count(*) as cnt
from telco
group by gender;

-- count by churn_label
select churn_Label, count(*) as cnt
from telco 
group by churn_label;

-- count by contract distributuion
select Contract, count(*) as cnt
from telco
group by Contract;

-- understanding ages
select 
	min(age) as min_age,
	max(age) as max_age,
	avg(age*1.0) as avg_age
from telco;

-- tenure stats
select 
	min(tenure_in_months) as min_tenure,
	max(tenure_in_months) as max_tenure,
	avg(tenure_in_months) as avg_tenure
from telco;

-- charges and revenue
select 
	round(avg(monthly_charge),2) as avg_monthly_charge,
	round(sum(total_revenue),2) as total_revenue,
	round(avg(satisfaction_score)*1.0,2) as avg_satisfaction
from telco;

-- churn by state
select 
	State, 
	count(*) as customers, sum(case when churn_label='yes' then 1 else 0 end) as churners, 
	round(100.0*sum(case when churn_label='yes' then 1 else 0 end)/nullif(count(*),0),2) as churn_pct
from telco
group by [state]
order by churn_pct desc;

-- churn by contract type
select
	contract, 
	count(*) as customers, 
	sum(case when churn_label='yes' then 1 else 0 end) as churners,
	round(100*sum(case when churn_label='yes' then 1 else 0 end)/nullif(count(*),0),2) as churn_pct
from telco
group by Contract
order by churn_pct desc;

-- checking records
SELECT TOP 20 * 
FROM Telco;

-- Checking data types
EXEC sp_help 'Telco';

-- Look for blanks or nulls in key columns
SELECT 
    SUM(CASE WHEN Total_Charges is null or Total_Charges = '' THEN 1 ELSE 0 END) AS null_total_charges,
    SUM(CASE WHEN Monthly_Charge is null or Monthly_Charge = '' THEN 1 ELSE 0 END) AS null_monthly_charge
FROM Telco;

-- Fix data types
ALTER TABLE Telco
ALTER COLUMN Monthly_Charge FLOAT;

ALTER TABLE Telco
ALTER COLUMN Total_Charges FLOAT;

ALTER TABLE Telco
ALTER COLUMN Total_Revenue FLOAT;

ALTER TABLE Telco
ALTER COLUMN Tenure_in_Months INT;

-- Handle nulls / blanks
UPDATE Telco
SET Total_Charges = NULL
WHERE LTRIM(RTRIM(Total_Charges)) = '';


-- profiling once again

-- 1. Basic row/column overview
SELECT COUNT(*) AS total_customers
FROM Telco;


-- 2. Null values check (top 10 columns)
SELECT 
    SUM(CASE WHEN customer_id IS NULL THEN 1 ELSE 0 END) AS null_customer_id,
    SUM(CASE WHEN age IS NULL THEN 1 ELSE 0 END) AS null_age,
    SUM(CASE WHEN tenure_in_months IS NULL THEN 1 ELSE 0 END) AS null_tenure,
    SUM(CASE WHEN monthly_charge IS NULL THEN 1 ELSE 0 END) AS null_monthly_charge,
    SUM(CASE WHEN total_charges IS NULL THEN 1 ELSE 0 END) AS null_total_charges,
    SUM(CASE WHEN total_revenue IS NULL THEN 1 ELSE 0 END) AS null_total_revenue,
    SUM(CASE WHEN satisfaction_score IS NULL THEN 1 ELSE 0 END) AS null_satisfaction_score,
    SUM(CASE WHEN churn_label IS NULL THEN 1 ELSE 0 END) AS null_churn_label
FROM Telco;


-- 3. Churn overview
SELECT 
    churn_label,
    COUNT(*) AS num_customers,
    ROUND(100.0 * COUNT(*) / NULLIF((SELECT COUNT(*) FROM Telco), 0), 2) AS pct_customers
FROM Telco
GROUP BY churn_label;


-- 4. Average tenure, monthly charges, satisfaction
SELECT 
    ROUND(AVG(tenure_in_months * 1.0),2) AS avg_tenure_months,
    ROUND(AVG(monthly_charge * 1.0),2)   AS avg_monthly_charge,
    ROUND(AVG(satisfaction_score * 1.0),2) AS avg_satisfaction
FROM Telco;


-- 5. Revenue overview
SELECT 
    SUM(total_revenue) AS total_revenue,
    ROUND(AVG(total_revenue * 1.0),2) AS avg_revenue_per_customer,
    ROUND(AVG(monthly_charge * 1.0),2) AS avg_monthly_charge
FROM Telco;


-- 6. Churn % by Contract Type
SELECT 
    contract,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN churn_label = 'Yes' THEN 1 ELSE 0 END) AS churners,
    ROUND(100.0 * SUM(CASE WHEN churn_label = 'Yes' THEN 1 ELSE 0 END) / NULLIF(COUNT(*),0),2) AS churn_pct
FROM Telco
GROUP BY contract
ORDER BY churn_pct DESC;


-- 7. Churn % by Internet Service
SELECT 
    internet_service,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN churn_label = 'Yes' THEN 1 ELSE 0 END) AS churners,
    ROUND(100.0 * SUM(CASE WHEN churn_label = 'Yes' THEN 1 ELSE 0 END) / NULLIF(COUNT(*),0),2) AS churn_pct
FROM Telco
GROUP BY internet_service
ORDER BY churn_pct DESC;


-- 8. Average satisfaction score by Churn Label
SELECT 
    churn_label,
    ROUND(AVG(satisfaction_score * 1.0),2) AS avg_satisfaction
FROM Telco
GROUP BY churn_label;


-- Analytic queries/Aggregations
--1. Customer counts & churn overview
-- Total customers & churn breakdown
SELECT 
    COUNT(*) AS total_customers,
    SUM(CASE WHEN churn_label = 'Yes' THEN 1 ELSE 0 END) AS churners,
    SUM(CASE WHEN churn_label = 'No' THEN 1 ELSE 0 END) AS non_churners,
    ROUND(100.0 * SUM(CASE WHEN churn_label = 'Yes' THEN 1 ELSE 0 END) / NULLIF(COUNT(*),0), 2) AS churn_pct
FROM Telco;


--2. Revenue analysis
-- Revenue metrics
SELECT 
    SUM(total_revenue) AS total_revenue,
    ROUND(AVG(total_revenue),2) AS avg_revenue_per_customer,
    ROUND(AVG(monthly_charge),2) AS avg_monthly_charge
FROM Telco;

-- Revenue by churn status
SELECT 
    churn_label,
    SUM(total_revenue) AS revenue,
    ROUND(AVG(total_revenue),2) AS avg_revenue
FROM Telco
GROUP BY churn_label;


--3. Churn % by contract type
SELECT 
    contract,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN churn_label = 'Yes' THEN 1 ELSE 0 END) AS churners,
    ROUND(100.0 * SUM(CASE WHEN churn_label = 'Yes' THEN 1 ELSE 0 END) / NULLIF(COUNT(*),0), 2) AS churn_pct
FROM Telco
GROUP BY contract
ORDER BY churn_pct DESC;


--4. Churn % by internet service
SELECT 
    internet_service,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN churn_label = 'Yes' THEN 1 ELSE 0 END) AS churners,
    ROUND(100.0 * SUM(CASE WHEN churn_label = 'Yes' THEN 1 ELSE 0 END) / NULLIF(COUNT(*),0), 2) AS churn_pct
FROM Telco
GROUP BY internet_service
ORDER BY churn_pct DESC;


--5. Customer satisfaction
-- Average satisfaction overall
SELECT ROUND(AVG(satisfaction_score),2) AS avg_satisfaction
FROM Telco;

-- Satisfaction by churn status
SELECT 
    churn_label,
    ROUND(AVG(satisfaction_score),2) AS avg_satisfaction
FROM Telco
GROUP BY churn_label;


--6. Customer demographics
-- Age distribution by churn
SELECT 
    churn_label,
    ROUND(AVG(age),1) AS avg_age,
    MIN(age) AS youngest,
    MAX(age) AS oldest
FROM Telco
GROUP BY churn_label;

-- Gender vs churn
SELECT 
    gender,
    churn_label,
    COUNT(*) AS num_customers
FROM Telco
GROUP BY gender, churn_label
ORDER BY gender, churn_label;


--7. Tenure analysis
-- Avg tenure of churners vs non-churners
SELECT 
    churn_label,
    ROUND(AVG(tenure_in_months),1) AS avg_tenure_months
FROM Telco
GROUP BY churn_label;

-- Churn % by tenure buckets
SELECT 
    CASE 
        WHEN tenure_in_months < 12 THEN '< 1 year'
        WHEN tenure_in_months BETWEEN 12 AND 24 THEN '1-2 years'
        WHEN tenure_in_months BETWEEN 25 AND 60 THEN '2-5 years'
        ELSE '5+ years'
    END AS tenure_group,
    COUNT(*) AS total_customers,
    SUM(CASE WHEN churn_label = 'Yes' THEN 1 ELSE 0 END) AS churners,
    ROUND(100.0 * SUM(CASE WHEN churn_label = 'Yes' THEN 1 ELSE 0 END) / NULLIF(COUNT(*),0),2) AS churn_pct
FROM Telco
GROUP BY 
    CASE 
        WHEN tenure_in_months < 12 THEN '< 1 year'
        WHEN tenure_in_months BETWEEN 12 AND 24 THEN '1-2 years'
        WHEN tenure_in_months BETWEEN 25 AND 60 THEN '2-5 years'
        ELSE '5+ years'
    END
ORDER BY churn_pct DESC;
