-- Additional Business Queries for E-commerce Data Warehouse and Data Marts

-- 1. Repeat Customer Rate
SELECT
  COUNT(DISTINCT CustomerKey) FILTER (WHERE OrderCount > 1) * 100.0 / COUNT(DISTINCT CustomerKey) AS RepeatCustomerRate
FROM (
  SELECT CustomerKey, COUNT(*) AS OrderCount
  FROM FactSales
  GROUP BY CustomerKey
) t;

-- 2. Sales by Country and Month
SELECT
  a.Country,
  d.Year,
  d.Month,
  SUM(f.TotalAmount) AS Sales
FROM FactSales f
JOIN DimAddress a ON f.AddressKey = a.AddressKey
JOIN DimDate d ON f.DateKey = d.DateKey
GROUP BY a.Country, d.Year, d.Month
ORDER BY a.Country, d.Year, d.Month;

-- 3. Conversion Rate (Cart to Order)
SELECT
  COUNT(DISTINCT CartKey) AS Carts,
  COUNT(DISTINCT OrderID) AS Orders,
  (COUNT(DISTINCT OrderID)::float / NULLIF(COUNT(DISTINCT CartKey), 0)) * 100 AS ConversionRate
FROM FactSales;

-- 4. Average Discount Used per Order
SELECT
  AVG(d.Value) AS AvgDiscount
FROM FactSales f
JOIN DimDiscount d ON f.DiscountKey = d.DiscountKey
WHERE d.Value IS NOT NULL;

-- 5. Top Reviewed Products
SELECT
  p.ProductName,
  COUNT(r.ReviewKey) AS ReviewCount,
  AVG(r.Rating) AS AvgRating
FROM FactSales f
JOIN DimProduct p ON f.ProductKey = p.ProductKey
JOIN DimReview r ON f.ReviewKey = r.ReviewKey
GROUP BY p.ProductName
ORDER BY ReviewCount DESC
LIMIT 10; 