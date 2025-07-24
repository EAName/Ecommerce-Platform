-- E-commerce ETL Script: OLTP → Data Warehouse (Star Schema) → Data Marts (Snowflake)
-- Batch (Periodic) Load Example

-- 1. Load Dimension Tables in Star Schema

-- Date Dimension
INSERT INTO DimDate (Date, Day, Month, Quarter, Year)
SELECT DISTINCT
    o.OrderDate::date AS Date,
    EXTRACT(DAY FROM o.OrderDate) AS Day,
    EXTRACT(MONTH FROM o.OrderDate) AS Month,
    EXTRACT(QUARTER FROM o.OrderDate) AS Quarter,
    EXTRACT(YEAR FROM o.OrderDate) AS Year
FROM Orders o
ON CONFLICT (Date) DO NOTHING;

-- Customer Dimension
INSERT INTO DimCustomer (UserID, FirstName, LastName, Email, PhoneNumber, RoleName, CreatedAt)
SELECT DISTINCT
    u.UserID, u.FirstName, u.LastName, u.Email, u.PhoneNumber, r.RoleName, u.CreatedAt
FROM Users u
LEFT JOIN Roles r ON u.RoleID = r.RoleID
ON CONFLICT (UserID) DO NOTHING;

-- Product Dimension
INSERT INTO DimProduct (ProductID, ProductName, Description, CategoryName, Price, CreatedAt)
SELECT DISTINCT
    p.ProductID, p.ProductName, p.Description, c.CategoryName, p.Price, p.CreatedAt
FROM Products p
LEFT JOIN Categories c ON p.CategoryID = c.CategoryID
ON CONFLICT (ProductID) DO NOTHING;

-- Address Dimension
INSERT INTO DimAddress (AddressID, StreetAddress, City, State, ZipCode, Country)
SELECT DISTINCT
    a.AddressID, a.StreetAddress, a.City, a.State, a.ZipCode, a.Country
FROM Addresses a
ON CONFLICT (AddressID) DO NOTHING;

-- Discount Dimension
INSERT INTO DimDiscount (DiscountID, Code, DiscountType, Value, StartDate, EndDate, MinOrderAmount, MaxUses)
SELECT DISTINCT
    d.DiscountID, d.Code, d.DiscountType::text, d.Value, d.StartDate, d.EndDate, d.MinOrderAmount, d.MaxUses
FROM Discounts d
ON CONFLICT (DiscountID) DO NOTHING;

-- Payment Dimension
INSERT INTO DimPayment (PaymentID, PaymentMethod, PaymentStatus)
SELECT DISTINCT
    p.PaymentID, p.PaymentMethod, p.PaymentStatus
FROM Payments p
ON CONFLICT (PaymentID) DO NOTHING;

-- Shipment Dimension
INSERT INTO DimShipment (ShipmentID, Carrier, ShipmentStatus)
SELECT DISTINCT
    s.ShipmentID, s.Carrier, s.ShipmentStatus
FROM Shipments s
ON CONFLICT (ShipmentID) DO NOTHING;

-- Review Dimension
INSERT INTO DimReview (ReviewID, Rating, Comment)
SELECT DISTINCT
    r.ReviewID, r.Rating, r.Comment
FROM Reviews r
ON CONFLICT (ReviewID) DO NOTHING;

-- Cart Dimension
INSERT INTO DimCart (CartID, CreatedAt)
SELECT DISTINCT
    c.CartID, c.CreatedAt
FROM Cart c
ON CONFLICT (CartID) DO NOTHING;

-- Wishlist Dimension
INSERT INTO DimWishlist (WishlistID, CreatedAt)
SELECT DISTINCT
    w.WishlistID, w.CreatedAt
FROM Wishlists w
ON CONFLICT (WishlistID) DO NOTHING;

-- AuditLog Dimension
INSERT INTO DimAuditLog (LogID, ActionType, Description)
SELECT DISTINCT
    a.LogID, a.ActionType, a.Description
FROM AuditLog a
ON CONFLICT (LogID) DO NOTHING;

-- 2. Load Fact Table in Star Schema
INSERT INTO FactSales (
    OrderID, DateKey, CustomerKey, ProductKey, AddressKey, DiscountKey, PaymentKey, ShipmentKey, ReviewKey, CartKey, WishlistKey, AuditLogKey, Quantity, PriceAtPurchase, TotalAmount, OrderStatus)
SELECT
    o.OrderID,
    dd.DateKey,
    dc.CustomerKey,
    dp.ProductKey,
    da.AddressKey,
    ddisc.DiscountKey,
    dpay.PaymentKey,
    dship.ShipmentKey,
    drev.ReviewKey,
    dcart.CartKey,
    dwish.WishlistKey,
    daudit.AuditLogKey,
    oi.Quantity,
    oi.PriceAtPurchase,
    (oi.Quantity * oi.PriceAtPurchase) AS TotalAmount,
    o.OrderStatus
FROM Orders o
JOIN OrderItems oi ON o.OrderID = oi.OrderID
LEFT JOIN DimDate dd ON dd.Date = o.OrderDate::date
LEFT JOIN DimCustomer dc ON dc.UserID = o.UserID
LEFT JOIN DimProduct dp ON dp.ProductID = oi.ProductID
LEFT JOIN DimAddress da ON da.AddressID = o.ShippingAddressID
LEFT JOIN DimDiscount ddisc ON ddisc.DiscountID = NULL -- Replace with actual discount logic if available
LEFT JOIN Payments pay ON pay.OrderID = o.OrderID
LEFT JOIN DimPayment dpay ON dpay.PaymentID = pay.PaymentID
LEFT JOIN Shipments ship ON ship.OrderID = o.OrderID
LEFT JOIN DimShipment dship ON dship.ShipmentID = ship.ShipmentID
LEFT JOIN Reviews rev ON rev.ProductID = oi.ProductID AND rev.UserID = o.UserID
LEFT JOIN DimReview drev ON drev.ReviewID = rev.ReviewID
LEFT JOIN Cart c ON c.UserID = o.UserID
LEFT JOIN DimCart dcart ON dcart.CartID = c.CartID
LEFT JOIN Wishlists w ON w.UserID = o.UserID AND w.ProductID = oi.ProductID
LEFT JOIN DimWishlist dwish ON dwish.WishlistID = w.WishlistID
LEFT JOIN AuditLog a ON a.UserID = o.UserID
LEFT JOIN DimAuditLog daudit ON daudit.LogID = a.LogID;

-- 3. Populate Data Marts (Snowflake)

-- Product Sales Data Mart
INSERT INTO DM_Product_Dim (ProductID, ProductName, Description, CategoryKey)
SELECT DISTINCT
    dp.ProductID, dp.ProductName, dp.Description, dc.CategoryKey
FROM DimProduct dp
LEFT JOIN DM_Category_Dim dc ON dc.CategoryName = dp.CategoryName
ON CONFLICT (ProductID) DO NOTHING;

INSERT INTO DM_Category_Dim (CategoryID, CategoryName)
SELECT DISTINCT
    c.CategoryID, c.CategoryName
FROM Categories c
ON CONFLICT (CategoryID) DO NOTHING;

INSERT INTO DM_ProductSales_Fact (DateKey, ProductKey, CustomerKey, DiscountKey, PaymentKey, ShipmentKey, Quantity, PriceAtPurchase, TotalAmount)
SELECT
    fs.DateKey, fs.ProductKey, fs.CustomerKey, fs.DiscountKey, fs.PaymentKey, fs.ShipmentKey, fs.Quantity, fs.PriceAtPurchase, fs.TotalAmount
FROM FactSales fs;

-- Customer Geography Data Mart
INSERT INTO DM_Address_Dim (AddressID, City, State, Country)
SELECT DISTINCT
    da.AddressID, da.City, da.State, da.Country
FROM DimAddress da
ON CONFLICT (AddressID) DO NOTHING;

INSERT INTO DM_Customer_Dim (UserID, FirstName, LastName, Email, AddressKey)
SELECT DISTINCT
    dc.UserID, dc.FirstName, dc.LastName, dc.Email, da.AddressKey
FROM DimCustomer dc
LEFT JOIN DimAddress da ON da.AddressID = dc.UserID -- Replace with actual address logic
ON CONFLICT (UserID) DO NOTHING;

INSERT INTO DM_CustomerSales_Fact (DateKey, CustomerKey, AddressKey, TotalAmount)
SELECT
    fs.DateKey, fs.CustomerKey, fs.AddressKey, fs.TotalAmount
FROM FactSales fs;

-- Time Data Mart
INSERT INTO DM_Date_Dim (Date, Day, Month, Quarter, Year)
SELECT DISTINCT
    dd.Date, dd.Day, dd.Month, dd.Quarter, dd.Year
FROM DimDate dd
ON CONFLICT (Date) DO NOTHING;

INSERT INTO DM_TimeSales_Fact (DateKey, TotalAmount)
SELECT
    fs.DateKey, SUM(fs.TotalAmount)
FROM FactSales fs
GROUP BY fs.DateKey; 