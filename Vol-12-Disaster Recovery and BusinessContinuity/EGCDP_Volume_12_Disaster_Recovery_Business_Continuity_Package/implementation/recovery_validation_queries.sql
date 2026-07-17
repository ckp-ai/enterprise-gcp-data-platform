-- Purpose: representative post-recovery validation queries.
-- Replace project, dataset and business rules through release configuration.
DECLARE recovery_cutover TIMESTAMP DEFAULT TIMESTAMP('2026-07-12 04:00:00+00');

-- Freshness and volume reconciliation.
SELECT
  MAX(event_timestamp) AS latest_event,
  TIMESTAMP_DIFF(CURRENT_TIMESTAMP(), MAX(event_timestamp), MINUTE) AS freshness_minutes,
  COUNTIF(event_timestamp >= recovery_cutover) AS post_cutover_rows
FROM `recovery-project.sales_curated.orders`;

-- Duplicate business keys after replay.
SELECT order_id, COUNT(*) AS copies
FROM `recovery-project.sales_curated.orders`
WHERE event_timestamp >= recovery_cutover
GROUP BY order_id
HAVING COUNT(*) > 1
ORDER BY copies DESC
LIMIT 1000;

-- Financial control total by day and currency.
SELECT order_date, currency_code, COUNT(*) AS orders, SUM(net_amount) AS net_amount
FROM `recovery-project.sales_curated.orders`
WHERE order_date >= DATE(recovery_cutover)
GROUP BY order_date, currency_code
ORDER BY order_date, currency_code;
