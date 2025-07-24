-- Load DimProduct (idempotent)
INSERT INTO DimProduct (ProductID, ProductName, Description, CategoryName, Price, CreatedAt)
SELECT DISTINCT
    p.ProductID, p.ProductName, p.Description, c.CategoryName, p.Price, p.CreatedAt
FROM Products p
LEFT JOIN Categories c ON p.CategoryID = c.CategoryID
ON CONFLICT (ProductID) DO NOTHING; 