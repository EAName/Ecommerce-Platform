-- Sample Data for E-commerce Platform (PostgreSQL)

-- Roles
INSERT INTO Roles (RoleName) VALUES ('admin'), ('customer'), ('seller');

-- Users
INSERT INTO Users (FirstName, LastName, Email, PasswordHash, PhoneNumber, RoleID) VALUES
('Alice', 'Smith', 'alice@example.com', 'hash1', '123-456-7890', 2),
('Bob', 'Jones', 'bob@example.com', 'hash2', '234-567-8901', 2),
('Carol', 'Admin', 'carol@example.com', 'hash3', '345-678-9012', 1);

-- Categories
INSERT INTO Categories (CategoryName) VALUES ('Electronics'), ('Books');

-- Products
INSERT INTO Products (ProductName, Description, Price, CategoryID) VALUES
('Laptop', 'A powerful laptop', 1200.00, 1),
('Novel', 'A best-selling novel', 15.99, 2);

-- ProductInventory
INSERT INTO ProductInventory (ProductID, QuantityAvailable) VALUES (1, 10), (2, 100);

-- Addresses
INSERT INTO Addresses (UserID, StreetAddress, City, State, ZipCode, Country) VALUES
(1, '123 Main St', 'New York', 'NY', '10001', 'USA'),
(2, '456 Oak Ave', 'Los Angeles', 'CA', '90001', 'USA');

-- Orders
INSERT INTO Orders (UserID, OrderStatus, ShippingAddressID, BillingAddressID) VALUES
(1, 'Processing', 1, 1),
(2, 'Shipped', 2, 2);

-- OrderItems
INSERT INTO OrderItems (OrderID, ProductID, Quantity, PriceAtPurchase) VALUES
(1, 1, 1, 1200.00),
(2, 2, 2, 15.99);

-- Payments
INSERT INTO Payments (OrderID, PaymentDate, Amount, PaymentMethod, PaymentStatus) VALUES
(1, CURRENT_TIMESTAMP, 1200.00, 'Credit Card', 'Completed'),
(2, CURRENT_TIMESTAMP, 31.98, 'PayPal', 'Completed');

-- Shipments
INSERT INTO Shipments (OrderID, ShippedDate, EstimatedArrivalDate, Carrier, TrackingNumber, ShipmentStatus) VALUES
(2, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '5 days', 'UPS', '1Z999AA10123456784', 'In Transit');

-- Reviews
INSERT INTO Reviews (ProductID, UserID, Rating, Comment) VALUES
(1, 1, 5, 'Great laptop!'),
(2, 2, 4, 'Enjoyed the book.');

-- Discounts
INSERT INTO Discounts (Code, DiscountType, Value, StartDate, EndDate, MinOrderAmount, MaxUses) VALUES
('WELCOME10', 'percent', 10.00, CURRENT_DATE, CURRENT_DATE + INTERVAL '30 days', 50.00, 100);

-- Cart
INSERT INTO Cart (UserID) VALUES (1), (2);

-- CartItems
INSERT INTO CartItems (CartID, ProductID, Quantity) VALUES (1, 2, 1), (2, 1, 1);

-- Wishlists
INSERT INTO Wishlists (UserID, ProductID) VALUES (1, 2), (2, 1);

-- AuditLog
INSERT INTO AuditLog (UserID, ActionType, Description) VALUES
(1, 'LOGIN', 'User logged in'),
(2, 'ORDER_PLACED', 'User placed an order'); 