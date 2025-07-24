-- E-commerce Data Warehouse: Snowflake Schema Data Marts (PostgreSQL)

-- Product Sales Data Mart (Snowflake)
CREATE TABLE DM_ProductSales_Fact (
    SalesKey SERIAL PRIMARY KEY,
    DateKey INT,
    ProductKey INT,
    CustomerKey INT,
    DiscountKey INT,
    PaymentKey INT,
    ShipmentKey INT,
    Quantity INT,
    PriceAtPurchase DECIMAL(10,2),
    TotalAmount DECIMAL(12,2)
);

CREATE TABLE DM_Product_Dim (
    ProductKey SERIAL PRIMARY KEY,
    ProductID INT UNIQUE,
    ProductName VARCHAR(255),
    Description TEXT,
    CategoryKey INT
);

CREATE TABLE DM_Category_Dim (
    CategoryKey SERIAL PRIMARY KEY,
    CategoryID INT UNIQUE,
    CategoryName VARCHAR(100)
);

-- Customer Geography Data Mart (Snowflake)
CREATE TABLE DM_CustomerSales_Fact (
    SalesKey SERIAL PRIMARY KEY,
    DateKey INT,
    CustomerKey INT,
    AddressKey INT,
    TotalAmount DECIMAL(12,2)
);

CREATE TABLE DM_Customer_Dim (
    CustomerKey SERIAL PRIMARY KEY,
    UserID INT UNIQUE,
    FirstName VARCHAR(100),
    LastName VARCHAR(100),
    Email VARCHAR(255),
    AddressKey INT
);

CREATE TABLE DM_Address_Dim (
    AddressKey SERIAL PRIMARY KEY,
    AddressID INT UNIQUE,
    City VARCHAR(100),
    State VARCHAR(100),
    Country VARCHAR(100)
);

-- Time Data Mart (Snowflake)
CREATE TABLE DM_TimeSales_Fact (
    SalesKey SERIAL PRIMARY KEY,
    DateKey INT,
    TotalAmount DECIMAL(12,2)
);

CREATE TABLE DM_Date_Dim (
    DateKey SERIAL PRIMARY KEY,
    Date DATE UNIQUE,
    Day INT,
    Month INT,
    Quarter INT,
    Year INT
); 