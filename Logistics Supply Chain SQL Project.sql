CREATE DATABASE logistics;
USE logistics;
DROP TABLE IF EXISTS Shipments;
DROP TABLE IF EXISTS Inventory;
DROP TABLE IF EXISTS Products;
DROP TABLE IF EXISTS Suppliers;
DROP TABLE IF EXISTS Warehouses;

CREATE TABLE Warehouses (
    warehouse_id INTEGER PRIMARY KEY,
    warehouse_name VARCHAR(100) NOT NULL,
    city VARCHAR(50) NOT NULL,
    capacity_sqft INTEGER, -- Capacity in Square Feet
    manager_name VARCHAR(100)
);

CREATE TABLE Suppliers (
    supplier_id INTEGER PRIMARY KEY,
    supplier_name VARCHAR(100) NOT NULL,
    contact_person VARCHAR(100),
    registration_city VARCHAR(50)
);

CREATE TABLE Products (
    product_id INTEGER PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL,
    category VARCHAR(50),
    unit_cost DECIMAL(10, 2) NOT NULL,
    hs_code VARCHAR(20) UNIQUE -- Harmonized System Code
);
CREATE TABLE Inventory (
    inventory_id INTEGER PRIMARY KEY,
    warehouse_id INTEGER NOT NULL,
    product_id INTEGER NOT NULL,
    stock_quantity INTEGER,
    reorder_level INTEGER,
    FOREIGN KEY (warehouse_id) REFERENCES Warehouses(warehouse_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);
CREATE TABLE Shipments (
    shipment_id INTEGER PRIMARY KEY,
    product_id INTEGER NOT NULL,
    supplier_id INTEGER,
    origin_warehouse_id INTEGER NOT NULL,
    destination_city VARCHAR(50) NOT NULL,
    shipment_date DATE NOT NULL,
    expected_delivery_date DATE,
    actual_delivery_date DATE,
    shipping_cost DECIMAL(10, 2) NOT NULL,
    status VARCHAR(20), -- 'In Transit', 'Delivered', 'Delayed'
    FOREIGN KEY (product_id) REFERENCES Products(product_id),
    FOREIGN KEY (supplier_id) REFERENCES Suppliers(supplier_id),
    FOREIGN KEY (origin_warehouse_id) REFERENCES Warehouses(warehouse_id)
);

INSERT INTO Warehouses (warehouse_id, warehouse_name, city, capacity_sqft, manager_name)
VALUES
(1, 'Reliance Logistics Hub', 'Mumbai', 50000, 'Vivek Kulkarni'),
(2, 'Gati Cargo Depot', 'Delhi', 75000, 'Sneha Tandon'),
(3, 'TVS Supply Chain Point', 'Chennai', 40000, 'Gopal Iyer'),
(4, 'Amazon Fulfillment Center', 'Bangalore', 100000, 'Prabha Shetty');

SELECT * FROM warehouses;

INSERT INTO Suppliers (supplier_id, supplier_name, contact_person, registration_city)
VALUES
(10, 'Lakshmi Textiles', 'Ramesh Kumar', 'Coimbatore'),
(20, 'Bharat Pharma Corp', 'Dr. Shanti Rao', 'Hyderabad'),
(30, 'Tata Motors Ancillaries', 'Pankaj Varma', 'Pune'),
(40, 'Amul Dairy Goods', 'Kiran Patel', 'Ahmedabad');

SELECT * FROM suppliers;

INSERT INTO Products (product_id, product_name, category, unit_cost, hs_code)
VALUES
(100, 'Basmati Rice (50kg)', 'Food Grain', 3500.00, '1006.30'),
(101, 'Auto Gearbox Unit', 'Automotive', 45000.00, '8708.40'),
(102, 'Cotton Fabric Roll', 'Textile', 8500.00, '5209.11'),
(103, 'Tablet Salt (Bulk)', 'Pharma Raw', 15000.00, '2501.00'),
(104, 'E-commerce Box (L)', 'Packaging', 50.00, '4819.10');

SELECT * FROM products;

INSERT INTO Inventory (inventory_id, warehouse_id, product_id, stock_quantity, reorder_level)
VALUES
(1000, 1, 100, 500, 100),
(1001, 1, 104, 15000, 5000),
(1002, 2, 101, 250, 50),
(1003, 3, 102, 300, 75),
(1004, 4, 100, 1000, 200),
(1005, 4, 103, 150, 100);

SELECT * FROM inventory;

INSERT INTO Shipments (
    shipment_id, product_id, supplier_id, origin_warehouse_id,
    destination_city, shipment_date, expected_delivery_date,
    actual_delivery_date, shipping_cost, status
)
VALUES
(5001, 101, 30, 2, 'Chennai', '2024-06-01', '2024-06-07', '2024-06-08', 12500.00, 'Delayed'),
(5002, 104, NULL, 1, 'Pune', '2024-06-05', '2024-06-07', '2024-06-07', 3500.00, 'Delivered'),
(5003, 102, 10, 3, 'Mumbai', '2024-06-10', '2024-06-15', '2024-06-15', 8900.00, 'Delivered'),
(5004, 103, 20, 4, 'Hyderabad', '2024-06-12', '2024-06-14', NULL, 6000.00, 'In Transit'),
(5005, 100, 40, 1, 'Kolkata', '2024-06-15', '2024-06-22', NULL, 15000.00, 'In Transit'),
(5006, 100, 40, 4, 'Delhi', '2024-06-18', '2024-06-20', '2024-06-20', 4200.00, 'Delivered');

SELECT * FROM shipments;

# DDL ( Data Defination Language)
# 1. Add a new column ’contact_email’ (VARCHAR 100, unique constraint) to the Suppliers table.

SELECT * FROM suppliers; 

ALTER TABLE suppliers
ADD COLUMN contact_email VARCHAR(100) NOT NULL;


SELECT * FROM suppliers;

# 2. Rename the column ’unit_cost’ in the Products table to ’base_price’.

SELECT * FROM products;

ALTER TABLE products
CHANGE unit_cost base_price DECIMAL(12,2) NOT NULL;

SELECT * FROM products;

#3.Create a non-unique index named ’idx_shipment_status’ on the ’status’ column of the Shipments table.

SELECT * FROM Shipments;

CREATE INDEX idx_shipment_status
ON shipments(status);

SELECT * FROM Shipments;

SHOW INDEX FROM Shipments;

CREATE INDEX idx_shipment_status_2 ON shipments(status);

#4. Modify the ’capacity_sqft’ column in the Warehouses table to allow a larger capacity (e.g., BIGINT).

SELECT * FROM warehouses;

DESCRIBE warehouses;

ALTER TABLE  warehouses
CHANGE capacity_sqft larger_capacity BIGINT;

# II. DML (Data Manipulation Language - CRUD) 

#5. Insert a new product: ID 105, ’Solar Panel Unit’, category ’Renewable’, cost 25000.00, HS code ’8541.40’.

show tables;
SELECT * FROM products;

INSERT INTO products
(product_id,product_name,category,base_price,hs_code)
VALUES
(105,'Solar panel unit','Renewable' , 25000.00 , '8541.40');

SELECT * FROM products;

#6. Update the stock quantity of ’Basmati Rice (50kg)’ (Product ID 100) in the Mumbai warehouse (ID 1) to 600 units

SELECT * FROM inventory;

UPDATE inventory
SET stock_quantity = 600
WHERE product_Id = 100  AND warehouse_id = 1;

#Q7 Update the status of Shipment ID 5004 to ’Delayed’ and set the ’actual_delivery_date’ to ’2024-06-17’.

SELECT * FROM shipments;

UPDATE shipments
SET  status = 'Delayed',
    actual_delivery_date = '2024-06-17'
WHERE shipment_id = 5004 ;

#Q8 Insert a new warehouse: ID 5, ’Adani Logistics Park’, ’Ahmedabad’, 60000 sqft, managed by ’Anil Singh’.

SELECT * FROM warehouses;

INSERT INTO warehouses
(warehouse_id,warehouse_name,city,larger_capacity,manager_name)
VALUES
(5, 'Adani Logistics park', 'Ahmedabad', '6000 sqrt', 'Anil Singh');

DESCRIBE warehouses;

# Q9 Delete all inventory records for products belonging to the ’Pharma Raw’ category

SELECT * FROM inventory;
SELECT * FROM products;

 DELETE FROM products
 WHERE category = 'pharma Raw';

SELECT product_id FROM products WHERE category = 'pharama Raw';

DELETE FROM inventory
WHERE product_id IN(
 SELECT product_id FROM products 
 WHERE category = 'pharma Raw'
 );

# Q10 Delete the supplier named ’Amul Dairy Goods’ (ID 40).

SELECT * FROM suppliers;
SELECT * FROM shipments;

UPDATE shipments
SET supplier_id = NULL
	WHERE supplier_id  = 40;
    
DELETE FROM suppliers
WHERE supplier_id = 40
     AND supplier_name = 'Amul Dairy Goods';

SELECT * FROM suppliers;
SELECT * FROM shipments;

# III. DQL - Basic SELECT (Data Query Language)

# Q11 Select the warehouse name, city, and manager name for all warehouses in ’Mumbai’ or ’Bangalore’.
   
SELECT * FROM warehouses;
SELECT warehouse_name,city,manager_name FROM warehouses
WHERE city IN ( 'mumbai' , 'Bangalore');



SELECT warehouse_name, city, manager_name
FROM warehouses
WHERE city = 'Mumbai' OR city = 'Bangalore';

# Q12 Select the product name and HS code for all products whose category is NOT ’Food Grain’.
SELECT * FROM products;

SELECT product_name, hs_code FROM products
WHERE category != 'Food Grain' ;

# Q13 Find all unique registration cities of suppliers.

SELECT * FROM suppliers;
SELECT DISTINCT registration_city
FROM suppliers;

# Q14 List all shipments with a shipping cost between 5000.00 and 10000.00 (inclusive), ordered by cost descending.

SELECT * FROM shipments;
SELECT shipment_id,shipping_cost FROM shipments
WHERE shipping_cost BETWEEN 5000 AND 10000
ORDER BY shipping_cost DESC;

# Q15 Select all products whose product name contains the word ’Unit’ or ’Roll’.

SELECT * FROM products;

SELECT product_id,product_name FROM products
WHERE product_name LIKE '%Unit%' OR
	  product_name LIKE '%Roll%';
# Q16 List the top 2 highest capacity warehouses.

SELECT * FROM warehouses;

SELECT warehouse_id,warehouse_name,city,larger_capacity,manager_name FROM warehouses
ORDER BY larger_capacity DESC
LIMIT 2;

# Q17 Select all shipments that do not have an associated supplier (supplier_id is NULL).
 SELECT * FROM shipments;
 show tables;
 SELECT * FROM shipments
 WHERE supplier_id IS NULL;

#IV. Functions (String, Numeric, Date) - 8 Questions
# Q18 Concatenate the product name and category into a single string: ”NAME [CATEGORY]”.







