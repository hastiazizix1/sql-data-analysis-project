USE DataWarehouseAnalytics;
GO
WITH sales_profit AS(
SELECT
f.product_key,
p.product_name,
f.price,
p.cost,
f.sales_amount,
(cost * quantity) AS total_cost
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
ON p.product_key = f.product_key
),

profitability AS(
  SELECT
   product_key,
   product_name,
   price,
   cost,
   sales_amount,
   total_cost,
      CAST(
    (sales_amount - total_cost) * 100.0 
    / NULLIF(sales_amount, 0)
AS DECIMAL(10,2)) AS profit_margin_percent
FROM sales_profit
)

  SELECT
   product_key,
   product_name,
   price,
   cost,
   sales_amount,
   total_cost,
   profit_margin_percent,
   
   CASE WHEN profit_margin_percent < 30 THEN 'Low'
        WHEN profit_margin_percent between 30 AND 60 THEN 'Medium'
        ELSE 'High'
   END AS profitability

FROM profitability;