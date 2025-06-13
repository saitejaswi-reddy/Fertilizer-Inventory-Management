create database if not exists fertilizer_shop;
use fertilizer_shop;
WITH purchase_sum AS (
    SELECT product_id, SUM(quantity) AS total_purchased
    FROM pesticides_purchase
    GROUP BY product_id
),
sales_sum AS (
    SELECT product_id, SUM(quantity) AS total_sold
    FROM pesticides_sales
    GROUP BY product_id
)


SELECT 
    m.product_id, 
    m.name,
    COALESCE(p.total_purchased, 0) AS total_purchased,
    COALESCE(s.total_sold, 0) AS total_sold,
    (COALESCE(p.total_purchased, 0) - COALESCE(s.total_sold, 0)) AS current_stock
FROM 
    pesticides m
LEFT JOIN purchase_sum p ON m.product_id = p.product_id
LEFT JOIN sales_sum s ON m.product_id = s.product_id;

CREATE OR REPLACE VIEW pesticide_stock AS
SELECT 
  m.product_id, 
  m.name,
  COALESCE(SUM(p.quantity),0) AS total_purchased,
  COALESCE(SUM(s.quantity),0) AS total_sold,
  (COALESCE(SUM(p.quantity),0) - COALESCE(SUM(s.quantity),0)) AS current_stock
FROM 
  pesticides m
LEFT JOIN pesticides_purchase p ON m.product_id = p.product_id
LEFT JOIN pesticides_sales s ON m.product_id = s.product_id
GROUP BY 
  m.product_id, m.name;
  