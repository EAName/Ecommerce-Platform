-- E-commerce Platform Schema (PostgreSQL 3NF)

-- Roles
CREATE TABLE Roles (
    RoleID SERIAL PRIMARY KEY,
    RoleName VARCHAR(50) UNIQUE
);

-- Users
CREATE TABLE Users (
    UserID SERIAL PRIMARY KEY,
    FirstName VARCHAR(100),
    LastName VARCHAR(100),
    Email VARCHAR(255) UNIQUE NOT NULL,
    PasswordHash TEXT NOT NULL,
    PhoneNumber VARCHAR(20),
    RoleID INT REFERENCES Roles(RoleID),
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Categories
CREATE TABLE Categories (
    CategoryID SERIAL PRIMARY KEY,
    CategoryName VARCHAR(100) UNIQUE
);

-- Products
CREATE TABLE Products (
    ProductID SERIAL PRIMARY KEY,
    ProductName VARCHAR(255),
    Description TEXT,
    Price DECIMAL(10, 2),
    CategoryID INT REFERENCES Categories(CategoryID),
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ProductInventory
CREATE TABLE ProductInventory (
    ProductID INT PRIMARY KEY REFERENCES Products(ProductID),
    QuantityAvailable INT
);

-- Addresses
CREATE TABLE Addresses (
    AddressID SERIAL PRIMARY KEY,
    UserID INT REFERENCES Users(UserID),
    StreetAddress VARCHAR(255),
    City VARCHAR(100),
    State VARCHAR(100),
    ZipCode VARCHAR(20),
    Country VARCHAR(100)
);

-- Orders
CREATE TABLE Orders (
    OrderID SERIAL PRIMARY KEY,
    UserID INT REFERENCES Users(UserID),
    OrderStatus VARCHAR(50),
    OrderDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ShippingAddressID INT REFERENCES Addresses(AddressID),
    BillingAddressID INT REFERENCES Addresses(AddressID)
);

-- OrderItems
CREATE TABLE OrderItems (
    OrderItemID SERIAL PRIMARY KEY,
    OrderID INT REFERENCES Orders(OrderID),
    ProductID INT REFERENCES Products(ProductID),
    Quantity INT,
    PriceAtPurchase DECIMAL(10, 2)
);

-- Payments
CREATE TABLE Payments (
    PaymentID SERIAL PRIMARY KEY,
    OrderID INT REFERENCES Orders(OrderID),
    PaymentDate TIMESTAMP,
    Amount DECIMAL(10, 2),
    PaymentMethod VARCHAR(50),
    PaymentStatus VARCHAR(50)
);

-- Shipments
CREATE TABLE Shipments (
    ShipmentID SERIAL PRIMARY KEY,
    OrderID INT REFERENCES Orders(OrderID),
    ShippedDate TIMESTAMP,
    EstimatedArrivalDate TIMESTAMP,
    Carrier VARCHAR(100),
    TrackingNumber VARCHAR(100),
    ShipmentStatus VARCHAR(50)
);

-- Reviews
CREATE TABLE Reviews (
    ReviewID SERIAL PRIMARY KEY,
    ProductID INT REFERENCES Products(ProductID),
    UserID INT REFERENCES Users(UserID),
    Rating INT CHECK (Rating >= 1 AND Rating <= 5),
    Comment TEXT,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Discounts
CREATE TYPE discount_type AS ENUM ('percent', 'fixed');
CREATE TABLE Discounts (
    DiscountID SERIAL PRIMARY KEY,
    Code VARCHAR(50) UNIQUE,
    DiscountType discount_type,
    Value DECIMAL(10, 2),
    StartDate DATE,
    EndDate DATE,
    MinOrderAmount DECIMAL(10,2),
    MaxUses INT
);

-- Cart
CREATE TABLE Cart (
    CartID SERIAL PRIMARY KEY,
    UserID INT UNIQUE REFERENCES Users(UserID),
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- CartItems
CREATE TABLE CartItems (
    CartItemID SERIAL PRIMARY KEY,
    CartID INT REFERENCES Cart(CartID),
    ProductID INT REFERENCES Products(ProductID),
    Quantity INT
);

-- Wishlists
CREATE TABLE Wishlists (
    WishlistID SERIAL PRIMARY KEY,
    UserID INT REFERENCES Users(UserID),
    ProductID INT REFERENCES Products(ProductID),
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(UserID, ProductID)
);

-- AuditLog
CREATE TABLE AuditLog (
    LogID SERIAL PRIMARY KEY,
    UserID INT REFERENCES Users(UserID),
    ActionType VARCHAR(100),
    Description TEXT,
    Timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP
); 