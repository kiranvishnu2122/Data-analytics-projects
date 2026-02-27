
-- project online_stores_inventory

-- create database

CREATE DATABASE online_stores_inventory;

-- use database

USE online_stores_inventory;

 -- create tables

 -- 1. user table

 CREATE TABLE user_table (
    user_id INT IDENTITY(1,1) PRIMARY KEY, -- indentity,it Start at 1 and Increase by 1 every new user id row
    username VARCHAR(50) UNIQUE,-- UNIQUE constraint ensures no duplicate username
    email VARCHAR(100),
    password  VARCHAR(255) not null -- cannot be empty values
);

-- 2.categories table

 CREATE TABLE categories (
    category_id INT IDENTITY(1,1) PRIMARY KEY, -- cannot be NULL and identifies each category uniquely
    category_name VARCHAR(100) UNIQUE,  -- EX: traditional were , kids were, womens were.
    description  VARCHAR(255),-- EX: traditional were - ethnic were matreial like banasari,kanchipuram.
    fabric_types VARCHAR(50) -- EX : silk, cotton ,wool
 );

 -- 3.suppliers table

 CREATE TABLE suppliers (
    supplier_id INT IDENTITY(1,1) PRIMARY KEY, -- or identity(1,1) if we didn't give (1,1) also it generates automatically
    supplier_name VARCHAR(100) NOT NULL UNIQUE, -- cannot be empty values
    email VARCHAR(150) UNIQUE,
    phone VARCHAR(20)not null,
    address VARCHAR(255)
 );

 -- 4.products table

 CREATE TABLE Products (
    product_id INT IDENTITY(1,1) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    category_id INT,-- Stores which category belongs to the product and Helps to group or filter products by category.
    supplier_id INT,-- Stores which supplier provides the product and Helps track inventory and supplier information.
    price DECIMAL(10,2), -- accurate money values, 10 total digits,2 digits after decimal
    stock_quantity INT ,-- how many pieces of the product are available in store
    description TEXT  
 );
 
 -- 5.inventory table

 CREATE TABLE Inventory (
    inventory_id INT IDENTITY(1,1) PRIMARY KEY,
    product_id INT NOT NULL,
    stock_level INT NOT NULL,-- How many units of that product are currently available in inventory.
    last_restocked DATE,-- The date when you last added stock for the product.
    restock_quantity INT,-- How many items were added during the last restock.
    supplier_id INT,-- Helps know which supplier delivered the stock.
    FOREIGN KEY (product_id) REFERENCES Products(product_id) ON DELETE CASCADE,-- If a product is deleted → its inventory records are also deleted automatically.
    FOREIGN KEY (supplier_id) REFERENCES Suppliers(supplier_id) ON DELETE SET NULL-- If a supplier is deleted, supplier_id becomes NULL.
 );

 -- 6.orders table 

 CREATE TABLE Orders (
    order_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT,
    order_date DATE,
    total_price DECIMAL(10,2) NOT NULL,
    status VARCHAR(20) DEFAULT 'pending'
    CHECK (status IN ('pending', 'shipped', 'delivered', 'canceled'))
); -- Defines the current state of the order,

 -- 7.orders table

 CREATE TABLE Order_Items (
    order_item_id INT PRIMARY KEY IDENTITY(1,1),-- One order can have many items, so each one needs its own unique ID.
    order_id INT,-- This connects the item to the Orders table.
    product_id INT,-- Identifies which product the customer bought.
    quantity INT NOT NULL,-- How many units of this product were purchased
    price DECIMAL(10,2) NOT NULL,-- The price of one unit of the product at the time of order.
    subtotal AS (quantity * price) PERSISTED,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id) ON DELETE CASCADE,
    -- If an order is deleted → all items inside the order also get deleted.
    FOREIGN KEY (product_id) REFERENCES Products(product_id) ON DELETE CASCADE
    -- If a product is deleted → all related order items also delete.
 );

select name from sys.tables;

 /* INSERTIONS */

 -- 1. user table

 INSERT INTO user_table (username, email, password) VALUES
 ('Toshika','toshika@mystore.com','toshi'),
 ('Raahithys','raahith@mystore.com','raahit'),
 ('Tanusri','tanusri@mystore.com','tanusri'),
 ('Yathvik','yathvik@mystore.com','yathvik'),
 ('Yogithsai','yogithsai@mystore.com','yogith');
 
 select * from user_table;

 -- 2.categories

 INSERT INTO categories (category_name, description, fabric_types) VALUES
 ('Mens T-shirts','crew-neck t-shirt in multiple colors','supima cotton'),
 ('Womens Jeans','high waisted skinny jeans','stretch fabric'),
 ('Hoodie Sweatshirt','hoodie with front pocket','fleece'),
 ('Formal Blazer','classic slim-fit blazer','linen'),
 ('Summer Dress','Lightweight floral dress','cotton');
 
 select * from categories;

 -- 3. suppliers

 INSERT INTO suppliers (supplier_name, email, phone, address) VALUES
 ('Go Green','gogreen@gmail.com',7949554777,'Bangalore'),
 ('Reka','reka@gmail.com',8924563409,'Delhi'),
 ('India','india@gmail.com',9828485868,'Surat'),
 ('Lakshmipathi','lakshmipathi@gmail.com',7362396514,'Hyderabad'),
 ('Rudraksh','rudraksh@gmail.com',8946578214,'Mangalgiri');

  SELECT * FROM suppliers;
 
 -- 4. products

INSERT INTO Products (name, category_id, supplier_id, price, stock_quantity, description) VALUES
('Men''s T-Shirt', 1, 1, 14.99, 100, 'Cotton crew-neck t-shirt in multiple colors'),
('Women''s Jeans', 2, 2, 39.99, 50, 'High-waisted skinny jeans'),
('Hoodie Sweatshirt', 3, 3, 29.99, 75, 'Warm fleece hoodie with front pocket'),
('Formal Blazer', 4, 4, 59.99, 40, 'Classic slim-fit blazer'),
('Summer Dress', 5, 5, 34.99, 60, 'Lightweight floral dress');

 SELECT * FROM Products;

 
 -- 5.inventory

INSERT INTO Inventory (product_id, stock_level, last_restocked, restock_quantity, supplier_id) 
VALUES 
(1, 100, '2025-01-15', 50, 1),
(2, 50, '2025-02-05', 30, 2),
(3, 75, '2025-01-25', 40, 3),
(4, 40, '2025-02-10', 20, 4),
(5, 60, '2025-02-12', 25, 5);
 
 SELECT * FROM Inventory;
 -- 6.orders

 INSERT INTO Orders (user_id, order_date, total_price, status) VALUES
 (1, '2025-02-01', 99.99, 'pending'),
 (2, '2025-02-05', 149.50, 'shipped'),
 (3, '2025-02-08', 79.99, 'delivered'),
 (4, '2025-02-10', 199.99, 'canceled'),
 (5, '2025-02-12', 120.00, 'pending');
  
  SELECT * FROM Orders;
 
 -- 7.orders_items

 INSERT INTO Order_Items (order_id, product_id, quantity, price) VALUES
 (1, 2, 3, 19.99),
 (2, 4, 1, 49.99),
 (3, 1, 2, 29.50),
 (4, 5, 4, 15.00);

 SELECT * FROM Order_Items;


-- Queries 

-- 1. Fetch all users

SELECT * FROM user_table;

-- 2.List all product names and prices

SELECT product_id, name, price FROM Products;

-- 3.Find products with price above 30

SELECT * FROM Products 
WHERE price > 30;

-- 4.Find all orders placed by a specific user

SELECT * FROM Orders
WHERE user_id = 2;

-- 5.Join products with their categories

SELECT p.name AS Product, c.category_name AS Category
FROM Products p
JOIN Categories c ON p.category_id = c.category_id;

-- 6️.Count how many products each supplier provides

SELECT s.supplier_name, COUNT(p.product_id) AS total_products
FROM Suppliers s
LEFT JOIN Products p ON s.supplier_id = p.supplier_id
GROUP BY s.supplier_name; 

-- 7️.Find current stock of each product

SELECT p.name, i.stock_level
FROM Products p
JOIN Inventory i ON p.product_id = i.product_id;

-- 8️. Get all orders with their total items

SELECT o.order_id, COUNT(oi.order_item_id) AS total_items
FROM Orders o
JOIN Order_Items oi ON o.order_id = oi.order_id
GROUP BY o.order_id;  

-- 9️. Show all orders with user details

SELECT o.order_id, u.username, o.total_price, o.status
FROM Orders o
JOIN user_table u ON o.user_id = u.user_id;

-- 10. Products low in stock (less than 50 qty)

SELECT * FROM Products
WHERE stock_quantity < 50;

-- 1️1️. Total revenue generated

SELECT SUM(total_price) AS total_revenue
FROM Orders;

-- 1️2️. Show each order’s subtotal items

SELECT order_id, product_id, quantity, price, (quantity * price) AS subtotal
FROM Order_Items;

-- 1️3️. Find users who placed orders 

SELECT DISTINCT u.username
FROM user_table u
JOIN Orders o ON u.user_id = o.user_id;

-- 1️4️. Show products supplied by 'Go Green'

SELECT p.name, p.price
FROM Products p
JOIN Suppliers s ON p.supplier_id = s.supplier_id
WHERE s.supplier_name = 'Go Green';

-- 1️5️. Count orders by status

SELECT status, COUNT(*) AS total_orders
FROM Orders
GROUP BY status;

-- 1️6️. Show latest restocked items

SELECT p.name, i.last_restocked
FROM Inventory i
JOIN Products p ON i.product_id = p.product_id
ORDER BY i.last_restocked DESC;

-- 1️7️. List all suppliers with their city in address

SELECT supplier_name, address
FROM Suppliers;

-- 1️8️. Show product with highest price

SELECT TOP 1 * FROM Products
ORDER BY price DESC;

-- 1️9️. Get total stock quantity of all products

SELECT SUM(stock_quantity) AS total_stock
FROM Products;

-- 2️0️. Show all orders with total price between 50 and 150

SELECT * FROM Orders
WHERE total_price BETWEEN 50 AND 150;

