-- Load DimDate (idempotent)
INSERT INTO DimDate (Date, Day, Month, Quarter, Year)
SELECT DISTINCT
    o.OrderDate::date AS Date,
    EXTRACT(DAY FROM o.OrderDate) AS Day,
    EXTRACT(MONTH FROM o.OrderDate) AS Month,
    EXTRACT(QUARTER FROM o.OrderDate) AS Quarter,
    EXTRACT(YEAR FROM o.OrderDate) AS Year
FROM Orders o
ON CONFLICT (Date) DO NOTHING; 