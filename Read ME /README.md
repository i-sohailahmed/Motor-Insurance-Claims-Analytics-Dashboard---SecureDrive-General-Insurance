# Motor Insurance Claims Analytics Dashboard

## SecureDrive General Insurance

##  Project Overview

This project is an end-to-end Data Analytics solution developed for a fictional insurance company, **SecureDrive General Insurance**.

The objective of this project is to analyze customer policies, insurance claims, premium collection, and claim performance using SQL and Power BI. The project demonstrates how raw business data can be transformed into meaningful insights that help management make data-driven decisions.

---

# Business Problem

Insurance companies handle thousands of customer policies and claims every year. Business leaders require quick insights into company performance, customer behavior, premium revenue, and claim trends.

This project answers key business questions such as:

- How much premium has been collected?
- What is the company's claim ratio?
- Which policy type generates the highest revenue?
- Which vehicle models generate the highest claim payouts?
- Which claim types occur most frequently?
- Which states contribute the highest premium?
- Who are the top premium-paying customers?
- How efficiently are claims being settled?

---

# Tech Stack

- PostgreSQL
- SQL
- Power BI
- Google Sheets
- GitHub

---

#  Project Structure

```
Motor Insurance Claims Analytics

│── SQL_Project.sql
│── Customer.csv
│── Policies.csv
│── Claim.csv
│── PowerBI_Dashboard.pbix
│── Dashboard.png
│── Database_Schema.png
│── README.md
```

---

# 🗄 Database Schema

The database consists of three related tables.

### Customer

Stores customer demographic information.

- Customer ID
- Age
- Gender
- City
- State
- Occupation
- Annual Income
- Customer Since

---

### Policies

Stores insurance policy details.

- Policy ID
- Customer ID
- Policy Type
- Vehicle Model
- Vehicle Make
- Vehicle Type
- Fuel Type
- Vehicle Year
- IDV
- Premium Amount

---

### Claims

Stores insurance claim details.

- Claim ID
- Policy ID
- Claim Date
- Claim Type
- Claim Amount
- Approved Amount
- Claim Status
- Settlement Days
- Garage Type

---

#  SQL Analysis

The project includes **17 business-oriented SQL queries** covering:

- Aggregate Functions
- INNER JOIN
- GROUP BY
- ORDER BY
- HAVING
- LIMIT
- CASE Statements
- Common Table Expressions (CTEs)
- Window Functions
- RANK()
- Views

Some of the business questions solved include:

- Total customers, policies and claims
- Total premium collected
- Total claim amount requested and approved
- Average customer income by occupation
- Top 10 highest claim amounts
- Cities generating the highest claim amount
- Policy type with the highest premium revenue
- Average premium by vehicle type
- Most frequent claim types
- Highest approved claim amount by fuel type
- Top premium-paying customers
- Occupation-wise claim ratio
- Customers with multiple policies
- Vehicle-wise claim ratio
- State-wise customer ranking
- Customer segmentation using CASE statements
- Executive business report

---

#  SQL Views

Four SQL views were created for reusable reporting.

- Customer Summary
- Policy Performance
- Claim Analysis
- Vehicle Analysis

---

# 📉 Power BI Dashboard

The interactive dashboard provides management with a quick overview of company performance.

### KPI Cards

- Total Customers
- Total Policies
- Total Premium
- Total Approved Amount
- Claim Ratio

### Visualizations

- Premium Amount by State
- Claim Amount Approved by Month
- Claim Amount by Claim Type
- Claim Amount by Vehicle Model
- Fuel Type Distribution
- Claim Status Distribution
- Executive Detail Table

### Interactive Filters

- Claim Status
- Policy Type

---

#  Key Business Insights

The dashboard helps business users:

- Monitor premium revenue
- Track claim trends
- Compare policy performance
- Analyze customer behavior
- Evaluate claim approval performance
- Identify top-performing states
- Monitor operational efficiency

---

#  Skills Demonstrated

- SQL
- PostgreSQL
- Database Design
- Data Cleaning
- Data Modeling
- Window Functions
- CASE Statements
- CTEs
- SQL Views
- Business Analysis
- Power BI
- DAX
- Dashboard Design
- Data Visualization
- KPI Reporting

---

#  Dashboard Preview



---

#  Project Outcome

This project demonstrates an end-to-end Data Analytics workflow, starting from database design and SQL analysis to interactive dashboard development in Power BI.

The project was built to showcase practical Business Intelligence and Data Analytics skills for portfolio and interview purposes.

---

##  Author

**Sohail**

MBA (Business Analytics & Finance)

Aspiring Business / Data Analyst
