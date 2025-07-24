-- Advanced ETL SQL Patterns for E-commerce Data Warehouse

-- 1. SCD Type 2 for DimProduct
ALTER TABLE DimProduct
ADD COLUMN IF NOT EXISTS EffectiveFrom TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN IF NOT EXISTS EffectiveTo TIMESTAMP,
ADD COLUMN IF NOT EXISTS IsCurrent BOOLEAN DEFAULT TRUE;

-- Expire old records and insert new ones for changed products
WITH changed AS (
  SELECT p.ProductID, p.ProductName, p.Description, c.CategoryName, p.Price, p.CreatedAt
  FROM Products p
  LEFT JOIN Categories c ON p.CategoryID = c.CategoryID
  JOIN DimProduct dp ON dp.ProductID = p.ProductID
  WHERE (p.ProductName, p.Description, c.CategoryName, p.Price) IS DISTINCT FROM
        (dp.ProductName, dp.Description, dp.CategoryName, dp.Price)
    AND dp.IsCurrent = TRUE
)
UPDATE DimProduct
SET EffectiveTo = CURRENT_TIMESTAMP, IsCurrent = FALSE
FROM changed
WHERE DimProduct.ProductID = changed.ProductID AND DimProduct.IsCurrent = TRUE;

INSERT INTO DimProduct (ProductID, ProductName, Description, CategoryName, Price, CreatedAt, EffectiveFrom, IsCurrent)
SELECT ProductID, ProductName, Description, CategoryName, Price, CreatedAt, CURRENT_TIMESTAMP, TRUE
FROM changed;

-- 2. Incremental Fact Table Loads
INSERT INTO FactSales (...)
SELECT ...
FROM Orders o
JOIN OrderItems oi ON o.OrderID = oi.OrderID
WHERE o.OrderDate > (SELECT COALESCE(MAX(Date), '2000-01-01') FROM DimDate);
-- Replace ... with actual columns and joins as in your main ETL

-- 3. ETL Audit Trail
CREATE TABLE IF NOT EXISTS ETL_Audit (
    ETLRunID SERIAL PRIMARY KEY,
    StartTime TIMESTAMP,
    EndTime TIMESTAMP,
    Status VARCHAR(20),
    RecordsInserted INT,
    RecordsUpdated INT
);
-- At the start of ETL
INSERT INTO ETL_Audit (StartTime, Status) VALUES (CURRENT_TIMESTAMP, 'STARTED') RETURNING ETLRunID;
-- At the end, update with EndTime, Status, and record counts

-- 4. Late Arriving Dimension Handling (Product Example)
INSERT INTO DimProduct (ProductID, ProductName, Description, CategoryName, Price, CreatedAt, EffectiveFrom, IsCurrent)
SELECT DISTINCT oi.ProductID, 'Unknown', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, TRUE
FROM OrderItems oi
LEFT JOIN DimProduct dp ON oi.ProductID = dp.ProductID
WHERE dp.ProductID IS NULL; 