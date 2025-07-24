-- Data Validation SQL Scripts

-- Row count validation
SELECT 'FactSales', COUNT(*) FROM FactSales;
SELECT 'DimCustomer', COUNT(*) FROM DimCustomer;
SELECT 'DimProduct', COUNT(*) FROM DimProduct;

-- Null checks for key columns
SELECT COUNT(*) FROM FactSales WHERE CustomerKey IS NULL OR ProductKey IS NULL;

-- Referential integrity check
SELECT COUNT(*) FROM FactSales f LEFT JOIN DimCustomer c ON f.CustomerKey = c.CustomerKey WHERE c.CustomerKey IS NULL;

-- Duplicate check
SELECT OrderID, COUNT(*) FROM FactSales GROUP BY OrderID HAVING COUNT(*) > 1; 