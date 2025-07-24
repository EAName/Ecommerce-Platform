-- Load FactSales (idempotent)
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