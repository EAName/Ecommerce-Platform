-- GDPR-compliant view (mask PII)
CREATE OR REPLACE VIEW vw_fact_sales_no_pii AS
SELECT
  fs.SalesKey,
  fs.OrderID,
  d.Year,
  d.Month,
  p.ProductName,
  fs.Quantity,
  fs.TotalAmount,
  'MASKED' AS CustomerEmail
FROM FactSales fs
JOIN DimDate d ON fs.DateKey = d.DateKey
JOIN DimProduct p ON fs.ProductKey = p.ProductKey;

-- Analytical view: Monthly sales by product
CREATE OR REPLACE VIEW vw_monthly_sales_by_product AS
SELECT
  d.Year,
  d.Month,
  p.ProductName,
  SUM(fs.TotalAmount) AS MonthlySales
FROM FactSales fs
JOIN DimDate d ON fs.DateKey = d.DateKey
JOIN DimProduct p ON fs.ProductKey = p.ProductKey
GROUP BY d.Year, d.Month, p.ProductName; 