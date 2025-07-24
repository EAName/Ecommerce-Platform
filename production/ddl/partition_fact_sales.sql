-- Partition FactSales by month
ALTER TABLE FactSales PARTITION BY RANGE (EXTRACT(YEAR FROM (SELECT Date FROM DimDate WHERE DimDate.DateKey = FactSales.DateKey)), EXTRACT(MONTH FROM (SELECT Date FROM DimDate WHERE DimDate.DateKey = FactSales.DateKey)));
-- For each month, create a partition (example for Jan 2024):
CREATE TABLE FactSales_2024_01 PARTITION OF FactSales
  FOR VALUES FROM (2024, 1) TO (2024, 2);
-- Repeat for each month as needed 