-- Advanced ETL SQL Patterns for E-commerce Data Warehouse

-- 1. SCD Type 2 for DimCustomer
ALTER TABLE DimCustomer
ADD COLUMN IF NOT EXISTS EffectiveFrom TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
ADD COLUMN IF NOT EXISTS EffectiveTo TIMESTAMP,
ADD COLUMN IF NOT EXISTS IsCurrent BOOLEAN DEFAULT TRUE;

-- Expire old records and insert new ones for changed customers
WITH changed AS (
  SELECT u.UserID, u.FirstName, u.LastName, u.Email, u.PhoneNumber, r.RoleName, u.CreatedAt
  FROM Users u
  LEFT JOIN Roles r ON u.RoleID = r.RoleID
  JOIN DimCustomer dc ON dc.UserID = u.UserID
  WHERE (u.FirstName, u.LastName, u.Email, u.PhoneNumber, r.RoleName) IS DISTINCT FROM
        (dc.FirstName, dc.LastName, dc.Email, dc.PhoneNumber, dc.RoleName)
    AND dc.IsCurrent = TRUE
)
UPDATE DimCustomer
SET EffectiveTo = CURRENT_TIMESTAMP, IsCurrent = FALSE
FROM changed
WHERE DimCustomer.UserID = changed.UserID AND DimCustomer.IsCurrent = TRUE;

INSERT INTO DimCustomer (UserID, FirstName, LastName, Email, PhoneNumber, RoleName, CreatedAt, EffectiveFrom, IsCurrent)
SELECT UserID, FirstName, LastName, Email, PhoneNumber, RoleName, CreatedAt, CURRENT_TIMESTAMP, TRUE
FROM changed;

-- 2. Surrogate Key Lookup for FactSales
-- (Example join for ETL, not a standalone statement)
-- SELECT o.OrderID, dc.CustomerKey, ... FROM Orders o JOIN DimCustomer dc ON dc.UserID = o.UserID AND dc.IsCurrent = TRUE;

-- 3. Soft Delete in FactSales
ALTER TABLE FactSales ADD COLUMN IF NOT EXISTS IsDeleted BOOLEAN DEFAULT FALSE;

-- Mark as deleted if order no longer exists in OLTP
UPDATE FactSales
SET IsDeleted = TRUE
WHERE OrderID NOT IN (SELECT OrderID FROM Orders);

-- 4. SCD Type 2 for DimProduct
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

-- 5. Incremental Fact Table Loads
INSERT INTO FactSales (...)
SELECT ...
FROM Orders o
JOIN OrderItems oi ON o.OrderID = oi.OrderID
WHERE o.OrderDate > (SELECT COALESCE(MAX(Date), '2000-01-01') FROM DimDate);
-- Replace ... with actual columns and joins as in your main ETL

-- 6. ETL Audit Trail
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

-- 7. Late Arriving Dimension Handling (Product Example)
INSERT INTO DimProduct (ProductID, ProductName, Description, CategoryName, Price, CreatedAt, EffectiveFrom, IsCurrent)
SELECT DISTINCT oi.ProductID, 'Unknown', NULL, NULL, NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, TRUE
FROM OrderItems oi
LEFT JOIN DimProduct dp ON oi.ProductID = dp.ProductID
WHERE dp.ProductID IS NULL; 