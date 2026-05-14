USE retailco_financials;

-- ================================================
-- 03_EXPENSE_ANALYSIS.SQL
-- Purpose: Analyse operating expenses vs budget
-- ================================================

-- Q1: Total expenses by category (actual vs budget)
SELECT
    category,
    ROUND(SUM(actual_amount), 2)                                        AS actual,
    ROUND(SUM(budget_amount), 2)                                        AS budget,
    ROUND(SUM(actual_amount) - SUM(budget_amount), 2)                   AS variance,
    ROUND((SUM(actual_amount) - SUM(budget_amount))
          / SUM(budget_amount) * 100, 1)                                AS variance_pct
FROM fact_financials
WHERE category NOT IN ('Revenue', 'Gross Profit')
GROUP BY category
ORDER BY actual DESC;

-- Q2: Monthly payroll trend (actual vs budget)
SELECT
    month_num,
    month_name,
    ROUND(SUM(actual_amount), 2)                      AS payroll_actual,
    ROUND(SUM(budget_amount), 2)                      AS payroll_budget,
    ROUND(SUM(actual_amount) - SUM(budget_amount), 2) AS variance
FROM fact_financials
WHERE category = 'Payroll'
GROUP BY month_num, month_name
ORDER BY month_num;

-- Q3: Top 5 stores with highest payroll overspend
SELECT
    f.store_name,
    s.region,
    s.store_type,
    ROUND(SUM(f.actual_amount), 2)                        AS payroll_actual,
    ROUND(SUM(f.budget_amount), 2)                        AS payroll_budget,
    ROUND(SUM(f.actual_amount) - SUM(f.budget_amount), 2) AS overspend
FROM fact_financials f
JOIN dim_stores s ON f.store_id = s.store_id
WHERE f.category = 'Payroll'
GROUP BY f.store_name, s.region, s.store_type
ORDER BY overspend DESC
LIMIT 5;

-- Q4: Total expense variance by store (all opex categories combined)
SELECT
    f.store_name,
    s.region,
    ROUND(SUM(f.actual_amount), 2)                        AS total_opex_actual,
    ROUND(SUM(f.budget_amount), 2)                        AS total_opex_budget,
    ROUND(SUM(f.actual_amount) - SUM(f.budget_amount), 2) AS variance
FROM fact_financials f
JOIN dim_stores s ON f.store_id = s.store_id
WHERE f.category NOT IN ('Revenue', 'Gross Profit')
GROUP BY f.store_name, s.region
ORDER BY variance DESC;

-- Q5: Expense category share of total opex (%)
SELECT
    category,
    ROUND(SUM(actual_amount), 2) AS actual,
    ROUND(SUM(actual_amount) /
        (SELECT SUM(actual_amount)
         FROM fact_financials
         WHERE category NOT IN ('Revenue','Gross Profit')
        ) * 100, 1)              AS pct_of_total_opex
FROM fact_financials
WHERE category NOT IN ('Revenue', 'Gross Profit')
GROUP BY category
ORDER BY actual DESC;