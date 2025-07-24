-- Automated Data Tests

-- Row count threshold
SELECT CASE WHEN COUNT(*) < 1000 THEN 'WARNING: Low row count' ELSE 'OK' END FROM FactSales;

-- Null checks
SELECT COUNT(*) FROM FactSales WHERE CustomerKey IS NULL OR ProductKey IS NULL;

-- Referential integrity
SELECT COUNT(*) FROM FactSales f LEFT JOIN DimCustomer c ON f.CustomerKey = c.CustomerKey WHERE c.CustomerKey IS NULL;

-- Duplicate check
SELECT OrderID, COUNT(*) FROM FactSales GROUP BY OrderID HAVING COUNT(*) > 1;

-- Sales amount anomaly (e.g., negative sales)
SELECT COUNT(*) FROM FactSales WHERE TotalAmount < 0; 