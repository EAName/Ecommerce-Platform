-- E-commerce Data Warehouse: Star Schema (PostgreSQL)

-- Dimension: Date
CREATE TABLE DimDate (
    DateKey SERIAL PRIMARY KEY,
    Date DATE UNIQUE,
    Day INT,
    Month INT,
    Quarter INT,
    Year INT
);

-- Dimension: Customer
CREATE TABLE DimCustomer (
    CustomerKey SERIAL PRIMARY KEY,
    UserID INT UNIQUE,
    FirstName VARCHAR(100),
    LastName VARCHAR(100),
    Email VARCHAR(255),
    PhoneNumber VARCHAR(20),
    RoleName VARCHAR(50),
    CreatedAt TIMESTAMP
);

-- Dimension: Product
CREATE TABLE DimProduct (
    ProductKey SERIAL PRIMARY KEY,
    ProductID INT UNIQUE,
    ProductName VARCHAR(255),
    Description TEXT,
    CategoryName VARCHAR(100),
    Price DECIMAL(10,2),
    CreatedAt TIMESTAMP
);

-- Dimension: Address
CREATE TABLE DimAddress (
    AddressKey SERIAL PRIMARY KEY,
    AddressID INT UNIQUE,
    StreetAddress VARCHAR(255),
    City VARCHAR(100),
    State VARCHAR(100),
    ZipCode VARCHAR(20),
    Country VARCHAR(100)
);

-- Dimension: Discount
CREATE TABLE DimDiscount (
    DiscountKey SERIAL PRIMARY KEY,
    DiscountID INT UNIQUE,
    Code VARCHAR(50),
    DiscountType VARCHAR(10),
    Value DECIMAL(10,2),
    StartDate DATE,
    EndDate DATE,
    MinOrderAmount DECIMAL(10,2),
    MaxUses INT
);

-- Dimension: Payment
CREATE TABLE DimPayment (
    PaymentKey SERIAL PRIMARY KEY,
    PaymentID INT UNIQUE,
    PaymentMethod VARCHAR(50),
    PaymentStatus VARCHAR(50)
);

-- Dimension: Shipment
CREATE TABLE DimShipment (
    ShipmentKey SERIAL PRIMARY KEY,
    ShipmentID INT UNIQUE,
    Carrier VARCHAR(100),
    ShipmentStatus VARCHAR(50)
);

-- Dimension: Review
CREATE TABLE DimReview (
    ReviewKey SERIAL PRIMARY KEY,
    ReviewID INT UNIQUE,
    Rating INT,
    Comment TEXT
);

-- Dimension: Cart
CREATE TABLE DimCart (
    CartKey SERIAL PRIMARY KEY,
    CartID INT UNIQUE,
    CreatedAt TIMESTAMP
);

-- Dimension: Wishlist
CREATE TABLE DimWishlist (
    WishlistKey SERIAL PRIMARY KEY,
    WishlistID INT UNIQUE,
    CreatedAt TIMESTAMP
);

-- Dimension: AuditLog
CREATE TABLE DimAuditLog (
    AuditLogKey SERIAL PRIMARY KEY,
    LogID INT UNIQUE,
    ActionType VARCHAR(100),
    Description TEXT
);

-- Fact Table: Sales (Orders)
CREATE TABLE FactSales (
    SalesKey SERIAL PRIMARY KEY,
    OrderID INT UNIQUE,
    DateKey INT REFERENCES DimDate(DateKey),
    CustomerKey INT REFERENCES DimCustomer(CustomerKey),
    ProductKey INT REFERENCES DimProduct(ProductKey),
    AddressKey INT REFERENCES DimAddress(AddressKey),
    DiscountKey INT REFERENCES DimDiscount(DiscountKey),
    PaymentKey INT REFERENCES DimPayment(PaymentKey),
    ShipmentKey INT REFERENCES DimShipment(ShipmentKey),
    ReviewKey INT REFERENCES DimReview(ReviewKey),
    CartKey INT REFERENCES DimCart(CartKey),
    WishlistKey INT REFERENCES DimWishlist(WishlistKey),
    AuditLogKey INT REFERENCES DimAuditLog(AuditLogKey),
    Quantity INT,
    PriceAtPurchase DECIMAL(10,2),
    TotalAmount DECIMAL(12,2),
    OrderStatus VARCHAR(50)
); 