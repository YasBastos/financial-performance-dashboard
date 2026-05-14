USE retailco_financials;

-- ================================================
-- 01_DATA_EXPLORATION.SQL
-- Purpose: Validate dataset and understand structure
-- ================================================

-- Q1: Row count and date range
SELECT
    COUNT(*)              AS total_rows,
    MIN(month_date)       AS earliest_month,
    MAX(month_date)       AS latest_month
FROM fact_financials;
-- Expected: 1260 rows, 2024-01-01 to 2024-12-01

-- Q2: Distinct categories
SELECT DISTINCT category
FROM fact_financials
ORDER BY category;
-- Expected: 7 categories

-- Q3: Distinct stores per region
SELECT
    s.region,
    COUNT(DISTINCT s.store_id)  AS number_of_stores,
    GROUP_CONCAT(s.store_name ORDER BY s.store_name SEPARATOR ', ') AS stores
FROM dim_stores s
GROUP BY s.region
ORDER BY s.region;
-- Expected: NSW=5, VIC=5, QLD=5

-- Q4: Row count per store (should be 84 each = 12 months x 7 categories)
SELECT
    store_name,
    COUNT(*) AS row_count
FROM fact_financials
GROUP BY store_name
ORDER BY store_name;
-- Expected: every store = 84 rows

-- Q5: Check for nulls in key columns
SELECT
    SUM(CASE WHEN actual_amount    IS NULL THEN 1 ELSE 0 END) AS null_actuals,
    SUM(CASE WHEN budget_amount    IS NULL THEN 1 ELSE 0 END) AS null_budgets,
    SUM(CASE WHEN prior_year_amount IS NULL THEN 1 ELSE 0 END) AS null_prior_year,
    SUM(CASE WHEN store_id         IS NULL THEN 1 ELSE 0 END) AS null_store_ids,
    SUM(CASE WHEN category         IS NULL THEN 1 ELSE 0 END) AS null_categories
FROM fact_financials;
-- Expected: all zeros