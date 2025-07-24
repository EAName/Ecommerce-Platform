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