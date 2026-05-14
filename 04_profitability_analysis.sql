USE retailco_financials;

-- ================================================
-- 04_PROFITABILITY_ANALYSIS.SQL
-- Purpose: Analyse gross profit and margins
-- ================================================

-- Q1: Monthly gross profit trend (actual vs budget)
SELECT
    month_num,
    month_name,
    ROUND(SUM(actual_amount), 2)                                        AS gp_actual,
    ROUND(SUM(budget_amount), 2)                                        AS gp_budget,
    ROUND(SUM(actual_amount) - SUM(budget_amount), 2)                   AS variance,
    ROUND((SUM(actual_amount) - SUM(budget_amount))
          / SUM(budget_amount) * 100, 1)                                AS variance_pct
FROM fact_financials
WHERE category = 'Gross Profit'
GROUP BY month_num, month_name
ORDER BY month_num;

-- Q2: Gross profit margin by store (full year)
SELECT
    r.store_name,
    s.region,
    s.store_type,
    ROUND(SUM(r.actual_amount), 2)                                          AS total_revenue,
    ROUND(SUM(gp.actual_amount), 2)                                         AS total_gross_profit,
    ROUND(SUM(gp.actual_amount) / NULLIF(SUM(r.actual_amount), 0) * 100, 1) AS gp_margin_pct
FROM fact_financials r
JOIN fact_financials gp
    ON  r.store_id   = gp.store_id
    AND r.month_date = gp.month_date
    AND gp.category  = 'Gross Profit'
JOIN dim_stores s ON r.store_id = s.store_id
WHERE r.category = 'Revenue'
GROUP BY r.store_name, s.region, s.store_type
ORDER BY gp_margin_pct DESC;

-- Q3: Rank stores by gross profit within each region
SELECT
    f.store_name,
    s.region,
    ROUND(SUM(f.actual_amount), 2) AS gross_profit,
    RANK() OVER (
        PARTITION BY s.region
        ORDER BY SUM(f.actual_amount) DESC
    ) AS rank_in_region
FROM fact_financials f
JOIN dim_stores s ON f.store_id = s.store_id
WHERE f.category = 'Gross Profit'
GROUP BY f.store_name, s.region
ORDER BY s.region, rank_in_region;

-- Q4: GP margin actual vs budget by region
SELECT
    s.region,
    ROUND(SUM(CASE WHEN f.category = 'Revenue'
                   THEN f.actual_amount END), 2)      AS revenue_actual,
    ROUND(SUM(CASE WHEN f.category = 'Gross Profit'
                   THEN f.actual_amount END), 2)      AS gp_actual,
    ROUND(SUM(CASE WHEN f.category = 'Gross Profit'
                   THEN f.actual_amount END) /
          NULLIF(SUM(CASE WHEN f.category = 'Revenue'
                          THEN f.actual_amount END), 0) * 100, 1) AS gp_margin_actual_pct,
    ROUND(SUM(CASE WHEN f.category = 'Gross Profit'
                   THEN f.budget_amount END) /
          NULLIF(SUM(CASE WHEN f.category = 'Revenue'
                          THEN f.budget_amount END), 0) * 100, 1) AS gp_margin_budget_pct
FROM fact_financials f
JOIN dim_stores s ON f.store_id = s.store_id
GROUP BY s.region
ORDER BY gp_margin_actual_pct DESC;