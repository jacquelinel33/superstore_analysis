
CREATE TABLE orders (
    Row_ID INT PRIMARY KEY,
    Order_ID VARCHAR(20),
    Order_Date DATE,
    Ship_Date DATE,
    Ship_Mode VARCHAR(50),
    Customer_ID VARCHAR(20),
    Customer_Name VARCHAR(100),
    Segment VARCHAR(50),
    Country VARCHAR(50),
    City VARCHAR(100),
    State VARCHAR(50),
    Postal_Code VARCHAR(20),
    Region VARCHAR(50),
    Product_ID VARCHAR(20),
    Category VARCHAR(50),
    Sub_Category VARCHAR(50),
    Product_Name VARCHAR(255),
    Sales DECIMAL(10, 2),
    Quantity INT,
    Discount DECIMAL(4, 2),
    Profit DECIMAL(10, 4)
);

copy orders FROM '/Users/jacquelinelee/Desktop/Data-Projects/Superstore Project/Sample - Superstore 2.csv' WITH (FORMAT csv, HEADER true, ENCODING 'WIN1252');

SELECT * FROM orders LIMIT 5

-- 1. Check for nulls in key columns
SELECT 
    COUNT(*) - COUNT(sales) as null_sales,
    COUNT(*) - COUNT(profit) as null_profit,
    COUNT(*) - COUNT(quantity) as null_quantity
FROM orders;

SELECT COUNT(*) as total_orders
FROM orders;
--9994 total orders

SELECT
    DISTINCT(Category)
FROM orders

SELECT 
    DISTINCT(Sub_Category) 
FROM orders
-- There is a total of 3 categories and 17 subcategories

SELECT order_id,
    COUNT()
FROM orders 
GROUP by 1 
HAVING COUNT(*) > 1

-- Which category is the most profitable?
-- Technology most profitable based on total profit
-- Furniture least profitable based on total profit
SELECT 
    orders.category,
    ROUND(SUM(orders.sales), 2) as total_sales,
    ROUND(SUM(orders.profit), 2) as total_profit
FROM orders
GROUP BY orders.category
ORDER BY total_sales DESC

-- What category sold the most units?
-- 1. Office supplies 2. Furniture 3. Technology
SELECT 
    orders.category,
    SUM(orders.quantity) as total_units
FROM orders
GROUP BY orders.category
ORDER BY total_units DESC

-- Most profitable sub-cat?
-- phones, chairs, storage most sales $
SELECT 
    orders.category,
    orders.sub_category,
    ROUND(SUM(orders.sales), 2) as total_sales,
    ROUND(SUM(orders.profit), 2) as total_profit
FROM orders
GROUP BY orders.category, orders.sub_category
ORDER BY total_sales DESC

-- copiers, phone and accessories most profit $
SELECT 
    orders.category,
    orders.sub_category,
    ROUND(SUM(orders.sales), 2) as total_sales,
    ROUND(SUM(orders.profit), 2) as total_profit
FROM orders
GROUP BY orders.category, orders.sub_category
ORDER BY total_profit DESC

-- binders, papers, furnishings most units
SELECT 
    orders.category,
    orders.sub_category,
    SUM(orders.quantity) as total_units
FROM orders
GROUP BY orders.category, orders.sub_category
ORDER BY total_units DESC

-- Calculate profit margin
-- Furniture very low margin
SELECT 
    orders.category,
    ROUND(SUM(orders.sales), 2) AS total_sales,
    ROUND(SUM(orders.profit), 2) AS total_profit,
    ROUND((SUM(orders.profit) / SUM(orders.sales)) * 100, 2) AS margin_percent
FROM orders
GROUP BY orders.category
ORDER BY total_sales DESC

-- Book cases and tables negative margins within furniture category
-- Higher margins in office supplies category
-- Sub-cat Labels, Paper, Envelops and Copiers have highest margins
SELECT 
    orders.category,
    orders.sub_category,
    ROUND(SUM(orders.sales), 2) AS total_sales,
    ROUND(SUM(orders.profit), 2) AS total_profit,
    ROUND((SUM(orders.profit) / SUM(orders.sales)) * 100, 2) AS margin_percent
FROM orders
GROUP BY orders.category, orders.sub_category
ORDER BY orders.category, margin_percent DESC

-- Best sellers by profit $
SELECT
    orders.product_name,
    SUM(orders.sales) as total_sales,
    SUM(orders.profit) as total_profit,
    ROUND((SUM(orders.profit) / SUM(orders.sales)) * 100, 2) AS margin_percent
FROM orders
GROUP BY orders.product_name
ORDER by total_profit DESC