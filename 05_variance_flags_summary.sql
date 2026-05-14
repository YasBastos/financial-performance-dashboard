USE retailco_financials;

-- ================================================
-- 05_VARIANCE_FLAGS_SUMMARY.SQL
-- Purpose: Flag performance and summarise variances
-- ================================================

-- Q1: Flag every store-month as Adverse / Favourable / On Track
SELECT
    store_name,
    month_name,
    month_num,
    ROUND(actual_amount, 2)  AS actual,
    ROUND(budget_amount, 2)  AS budget,
    ROUND((actual_amount - budget_amount)
          / budget_amount * 100, 1) AS variance_pct,
    CASE
        WHEN (actual_amount - budget_amount) / budget_amount < -0.05
            THEN 'Adverse'
        WHEN (actual_amount - budget_amount) / budget_amount > 0.05
            THEN 'Favourable'
        ELSE 'On Track'
    END AS variance_flag
FROM fact_financials
WHERE category = 'Revenue'
ORDER BY month_num, store_name;

-- Q2: Count of Adverse / Favourable / On Track months per store
SELECT
    store_name,
    SUM(CASE WHEN (actual_amount - budget_amount)
                  / budget_amount < -0.05  THEN 1 ELSE 0 END) AS adverse_months,
    SUM(CASE WHEN (actual_amount - budget_amount)
                  / budget_amount > 0.05   THEN 1 ELSE 0 END) AS favourable_months,
    SUM(CASE WHEN ABS((actual_amount - budget_amount)
                  / budget_amount) <= 0.05 THEN 1 ELSE 0 END) AS on_track_months
FROM fact_financials
WHERE category = 'Revenue'
GROUP BY store_name
ORDER BY adverse_months DESC;

-- Q3: Worst single month per store (biggest adverse revenue variance)
SELECT
    store_name,
    month_name,
    ROUND(actual_amount, 2)                               AS actual,
    ROUND(budget_amount, 2)                               AS budget,
    ROUND(actual_amount - budget_amount, 2)               AS variance_amount,
    ROUND((actual_amount - budget_amount)
          / budget_amount * 100, 1)                       AS variance_pct
FROM fact_financials
WHERE category = 'Revenue'
  AND (actual_amount - budget_amount) / budget_amount < -0.05
ORDER BY variance_pct ASC
LIMIT 10;

-- Q4: Overall portfolio scorecard
SELECT
    ROUND(SUM(CASE WHEN category = 'Revenue'
                   THEN actual_amount END), 2)            AS total_revenue_actual,
    ROUND(SUM(CASE WHEN category = 'Revenue'
                   THEN budget_amount END), 2)            AS total_revenue_budget,
    ROUND(SUM(CASE WHEN category = 'Gross Profit'
                   THEN actual_amount END), 2)            AS total_gp_actual,
    ROUND(SUM(CASE WHEN category NOT IN ('Revenue','Gross Profit')
                   THEN actual_amount END), 2)            AS total_opex_actual,
    ROUND(SUM(CASE WHEN category = 'Gross Profit'
                   THEN actual_amount END) /
          NULLIF(SUM(CASE WHEN category = 'Revenue'
                          THEN actual_amount END), 0) * 100, 1) AS overall_gp_margin_pct
FROM fact_financials;