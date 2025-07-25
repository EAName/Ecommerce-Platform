-- Example Analytical Queries for E-commerce Data Warehouse and Data Marts

-- 1. Total Sales by Product Category (Data Mart)
SELECT
  cat.CategoryName,
  SUM(f.TotalAmount) AS TotalSales
FROM DM_ProductSales_Fact f
JOIN DM_Product_Dim p ON f.ProductKey = p.ProductKey
JOIN DM_Category_Dim cat ON p.CategoryKey = cat.CategoryKey
GROUP BY cat.CategoryName
ORDER BY TotalSales DESC;

-- 2. Monthly Sales Trend (Warehouse)
SELECT
  d.Year,
  d.Month,
  SUM(f.TotalAmount) AS MonthlySales
FROM FactSales f
JOIN DimDate d ON f.DateKey = d.DateKey
GROUP BY d.Year, d.Month
ORDER BY d.Year, d.Month;

-- 3. Top Customers by Sales (Data Mart)
SELECT
  c.FirstName || ' ' || c.LastName AS Customer,
  SUM(f.TotalAmount) AS TotalSpent
FROM DM_CustomerSales_Fact f
JOIN DM_Customer_Dim c ON f.CustomerKey = c.CustomerKey
GROUP BY Customer
ORDER BY TotalSpent DESC
LIMIT 10;

-- 4. Average Order Value by Payment Method
SELECT
  p.PaymentMethod,
  AVG(f.TotalAmount) AS AvgOrderValue
FROM FactSales f
JOIN DimPayment p ON f.PaymentKey = p.PaymentKey
GROUP BY p.PaymentMethod
ORDER BY AvgOrderValue DESC;

-- 5. Product Review Summary
SELECT
  p.ProductName,
  AVG(r.Rating) AS AvgRating,
  COUNT(r.ReviewKey) AS ReviewCount
FROM FactSales f
JOIN DimProduct p ON f.ProductKey = p.ProductKey
JOIN DimReview r ON f.ReviewKey = r.ReviewKey
GROUP BY p.ProductName
ORDER BY AvgRating DESC; 