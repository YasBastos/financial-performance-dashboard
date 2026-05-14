USE retailco_financials;

-- ================================================
-- 02_REVENUE_ANALYSIS.SQL
-- Purpose: Analyse revenue performance vs budget
-- ================================================

-- Q1: Total revenue by month (actual vs budget)
SELECT
    month_num,
    month_name,
    ROUND(SUM(actual_amount), 2)                                        AS revenue_actual,
    ROUND(SUM(budget_amount), 2)                                        AS revenue_budget,
    ROUND(SUM(actual_amount) - SUM(budget_amount), 2)                   AS variance_amount,
    ROUND((SUM(actual_amount) - SUM(budget_amount))
          / SUM(budget_amount) * 100, 1)                                AS variance_pct
FROM fact_financials
WHERE category = 'Revenue'
GROUP BY month_num, month_name
ORDER BY month_num;

-- Q2: Total YTD revenue (full year)
SELECT
    ROUND(SUM(actual_amount), 2)  AS ytd_revenue_actual,
    ROUND(SUM(budget_amount), 2)  AS ytd_revenue_budget,
    ROUND(SUM(actual_amount) - SUM(budget_amount), 2) AS ytd_variance,
    ROUND((SUM(actual_amount) - SUM(budget_amount))
          / SUM(budget_amount) * 100, 1)              AS ytd_variance_pct
FROM fact_financials
WHERE category = 'Revenue';

-- Q3: Revenue by region
SELECT
    s.region,
    ROUND(SUM(f.actual_amount), 2)                    AS revenue_actual,
    ROUND(SUM(f.budget_amount), 2)                    AS revenue_budget,
    ROUND(SUM(f.actual_amount) - SUM(f.budget_amount), 2) AS variance_amount,
    ROUND((SUM(f.actual_amount) - SUM(f.budget_amount))
          / SUM(f.budget_amount) * 100, 1)            AS variance_pct
FROM fact_financials f
JOIN dim_stores s ON f.store_id = s.store_id
WHERE f.category = 'Revenue'
GROUP BY s.region
ORDER BY revenue_actual DESC;

-- Q4: Top 5 stores by YTD revenue
SELECT
    f.store_name,
    s.region,
    s.store_type,
    ROUND(SUM(f.actual_amount), 2)  AS ytd_revenue
FROM fact_financials f
JOIN dim_stores s ON f.store_id = s.store_id
WHERE f.category = 'Revenue'
GROUP BY f.store_name, s.region, s.store_type
ORDER BY ytd_revenue DESC
LIMIT 5;

-- Q5: Bottom 5 stores by revenue variance
SELECT
    f.store_name,
    s.region,
    ROUND(SUM(f.actual_amount), 2)                        AS revenue_actual,
    ROUND(SUM(f.budget_amount), 2)                        AS revenue_budget,
    ROUND(SUM(f.actual_amount) - SUM(f.budget_amount), 2) AS variance_amount,
    ROUND((SUM(f.actual_amount) - SUM(f.budget_amount))
          / SUM(f.budget_amount) * 100, 1)                AS variance_pct
FROM fact_financials f
JOIN dim_stores s ON f.store_id = s.store_id
WHERE f.category = 'Revenue'
GROUP BY f.store_name, s.region
ORDER BY variance_amount ASC
LIMIT 5;

-- Q6: Year-on-year revenue growth by month
SELECT
    month_num,
    month_name,
    ROUND(SUM(actual_amount), 2)                                          AS revenue_actual,
    ROUND(SUM(prior_year_amount), 2)                                      AS revenue_prior_year,
    ROUND(SUM(actual_amount) - SUM(prior_year_amount), 2)                 AS yoy_change,
    ROUND((SUM(actual_amount) - SUM(prior_year_amount))
          / SUM(prior_year_amount) * 100, 1)                              AS yoy_growth_pct
FROM fact_financials
WHERE category = 'Revenue'
GROUP BY month_num, month_name
ORDER BY month_num;