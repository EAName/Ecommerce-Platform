E-commerce Data Warehouse: ERD-Style Explanations

---

STAR SCHEMA (Central Data Warehouse)

Fact Table:
- FactSales: Central fact table capturing each sales transaction (order item). Linked to all dimensions by surrogate keys. Contains quantitative measures (Quantity, PriceAtPurchase, TotalAmount, OrderStatus).

Dimension Tables:
- DimDate: Describes the date of the transaction (day, month, quarter, year).
- DimCustomer: Describes the customer (user) who placed the order.
- DimProduct: Describes the product sold, including category and price.
- DimAddress: Describes the shipping/billing address.
- DimDiscount: Describes any discount/coupon applied.
- DimPayment: Describes payment method and status.
- DimShipment: Describes shipment carrier and status.
- DimReview: Describes any review left for the product/order.
- DimCart: Describes the cart associated with the order.
- DimWishlist: Describes wishlist context for the order/product.
- DimAuditLog: Describes audit actions related to the order/user.

Relationships:
- FactSales has a foreign key to each dimension table, forming a star pattern.

---

SNOWFLAKE SCHEMA DATA MARTS

1. Product Sales Data Mart
- Fact: DM_ProductSales_Fact (sales transactions by product)
- Dimension: DM_Product_Dim (product details, links to DM_Category_Dim)
- Dimension: DM_Category_Dim (category details)
- Other dimensions: Customer, Discount, Payment, Shipment
- Relationship: Product dimension is normalized into Product and Category tables (snowflake pattern)

2. Customer Geography Data Mart
- Fact: DM_CustomerSales_Fact (sales transactions by customer)
- Dimension: DM_Customer_Dim (customer details, links to DM_Address_Dim)
- Dimension: DM_Address_Dim (address details: city, state, country)
- Relationship: Customer dimension is normalized into Customer and Address tables (snowflake pattern)

3. Time Data Mart
- Fact: DM_TimeSales_Fact (sales aggregated by date)
- Dimension: DM_Date_Dim (date details)
- Relationship: Simple snowflake with time dimension normalized

---

In each data mart, the fact table is at the center, and dimensions are normalized as appropriate for the analytical focus (product, customer geography, time). All advanced/optional entities are included as necessary in the star schema, and relevant ones are included in the data marts. 