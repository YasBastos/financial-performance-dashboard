# Financial Performance Dashboard — RetailCo Australia FY2024

## Overview
This project presents an end-to-end financial performance analysis for a fictional Australian retail chain (RetailCo) with 15 stores across NSW, VIC, and QLD. The dashboard replicates the type of budget vs actual reporting commonly used in FP&A and management accounting teams.

The project was built using Excel, SQL, and Power BI, and demonstrates financial analysis, data modelling, and business storytelling skills relevant to Data Analyst and Reporting Analyst roles.

---

## Business Problem
The CFO of RetailCo required a consolidated view of financial performance across all stores to replace manual monthly spreadsheet reports. Leadership needed clarity on where the business was tracking against budget, which stores were underperforming, and where operating expenses were exceeding plan.

---

## Objectives
- Analyse revenue, expenses, and gross profit against budget across 15 stores and 12 months
- Identify stores and regions with the most significant adverse variances
- Uncover expense categories driving cost overruns
- Deliver executive-ready insights and actionable recommendations

---

## Tools Used
| Tool | Purpose |
|---|---|
| Microsoft Excel | Data cleaning, pivot tables, KPI calculations |
| SQL (SQLite) | Data exploration, aggregations, variance analysis, window functions |
| Power BI | Interactive 4-page dashboard with slicers and DAX measures |

---

## Dataset Summary
- **Source:** Fictional dataset created to reflect realistic retail FP&A data
- **Volume:** 1,260 rows across 15 stores, 12 months, 7 financial categories
- **Tables:** `fact_financials` (transactions) + `dim_stores` (store reference data)
- **Columns include:** store, region, month, category, actual amount, budget amount, prior year amount

---

## Project Workflow
1. Designed the dataset structure and generated realistic fictional data
2. Performed data cleaning and validation in Excel
3. Built pivot tables and KPI summary in Excel
4. Imported data into SQLite and wrote 5 SQL analysis scripts
5. Connected cleaned CSV to Power BI and built a 4-page dashboard
6. Wrote business insights and recommendations based on findings

---

## Key Insights
- **YTD revenue came in 3.8% below budget**, with Q3 showing the largest adverse variance driven by two NSW stores
- **Payroll exceeded budget by 6.2%** across 11 of 15 stores, linked to increased casual hours during a May promotion
- **Gross profit margin averaged 43.1%** vs a 44.5% budget, with QLD stores outperforming the portfolio average
- **Sydney CBD and Melbourne Chadstone** were the only stores to exceed both revenue and profit budgets for the full year
- **Brisbane Carindale** recorded adverse revenue variances in 9 of 12 months, flagging a structural performance issue

---

## Recommendations
1. Review rostering and casual hours management across the 6 highest payroll variance stores to recover approximately $290K annually
2. Adjust Q3 budget assumptions for NSW stores to reflect seasonal trading patterns
3. Benchmark top-margin QLD stores and assess whether their supplier terms or product mix can be replicated elsewhere
4. Introduce a monthly variance alert threshold (>-8% revenue) to enable earlier management intervention

---

## How to View the Project
- **Power BI Dashboard:** Download `powerbi/RetailCo_Financial_Dashboard.pbix` and open in Power BI Desktop (free)
- **SQL Queries:** Open any `.sql` file in the `sql/` folder in VS Code, DBeaver, or DB Browser for SQLite
- **Excel File:** Open `excel/RetailCo_Financial_Analysis.xlsx` in Microsoft Excel
- **Screenshots:** View dashboard previews in the `screenshots/` folder

---

## About
Built by Yasmin Bastos as part of a data analytics portfolio project.  
Background: 4+ years in FP&A and commercial analysis | Currently studying IT in Australia  
[https://www.linkedin.com/in/yasminaraujo1/] | [GitHub Profile]
