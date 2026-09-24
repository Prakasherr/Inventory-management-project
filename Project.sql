CREATE DATABASE inventory_management;

USE inventory_management;

drop database inventory_management;

CREATE TABLE categories (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(100) NOT NULL,
    description VARCHAR(255)
);

CREATE TABLE suppliers (
    supplier_id INT PRIMARY KEY AUTO_INCREMENT,
    supplier_name VARCHAR(100) NOT NULL,
    phone VARCHAR(15),
    email VARCHAR(100),
    address VARCHAR(255)
);

CREATE TABLE warehouses (
    warehouse_id INT PRIMARY KEY AUTO_INCREMENT,
    warehouse_name VARCHAR(100) NOT NULL,
    location VARCHAR(100),
    manager_name VARCHAR(100)
);

CREATE TABLE employees (
    employee_id INT PRIMARY KEY AUTO_INCREMENT,
    employee_name VARCHAR(100) NOT NULL,
    email VARCHAR(100),
    phone VARCHAR(15),
    job_role VARCHAR(50),
    salary DECIMAL(10,2),
    joining_date DATE,
    location VARCHAR(100),
    warehouse_id INT,

    FOREIGN KEY (warehouse_id)
    REFERENCES warehouses(warehouse_id)
);

CREATE TABLE products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    product_code VARCHAR(30) UNIQUE,
    product_name VARCHAR(100) NOT NULL,
    brand VARCHAR(100),
    category_id INT,
    supplier_id INT,
    unit_price DECIMAL(10,2),
    reorder_level INT,

    FOREIGN KEY (category_id)
    REFERENCES categories(category_id),

    FOREIGN KEY (supplier_id)
    REFERENCES suppliers(supplier_id)
);

CREATE TABLE customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_name VARCHAR(100) NOT NULL,
    phone VARCHAR(15),
    email VARCHAR(100),
    address VARCHAR(255)
);

CREATE TABLE purchase_orders (
    purchase_order_id INT PRIMARY KEY AUTO_INCREMENT,
    supplier_id INT NOT NULL,
    employee_id INT,
    order_date DATE,
    total_amount DECIMAL(12,2),
    status VARCHAR(30),

    FOREIGN KEY (supplier_id)
    REFERENCES suppliers(supplier_id),

    FOREIGN KEY (employee_id)
    REFERENCES employees(employee_id)
);

CREATE TABLE purchase_items (
    purchase_item_id INT PRIMARY KEY AUTO_INCREMENT,
    purchase_order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_cost DECIMAL(10,2),
    subtotal DECIMAL(12,2),

    FOREIGN KEY (purchase_order_id)
    REFERENCES purchase_orders(purchase_order_id),

    FOREIGN KEY (product_id)
    REFERENCES products(product_id)
);

CREATE TABLE sales_orders (
    sales_order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    employee_id INT,
    order_date DATE,
    total_amount DECIMAL(12,2),
    status VARCHAR(30),

    FOREIGN KEY (customer_id)
    REFERENCES customers(customer_id),

    FOREIGN KEY (employee_id)
    REFERENCES employees(employee_id)
);

CREATE TABLE sales_items (
    sales_item_id INT PRIMARY KEY AUTO_INCREMENT,
    sales_order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10,2),
    subtotal DECIMAL(12,2),

    FOREIGN KEY (sales_order_id)
    REFERENCES sales_orders(sales_order_id),

    FOREIGN KEY (product_id)
    REFERENCES products(product_id)
);

CREATE TABLE inventory (
    inventory_id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT NOT NULL,
    warehouse_id INT NOT NULL,
    quantity INT NOT NULL DEFAULT 0,
    last_updated DATE,

    FOREIGN KEY (product_id)
    REFERENCES products(product_id),

    FOREIGN KEY (warehouse_id)
    REFERENCES warehouses(warehouse_id),

    UNIQUE (product_id, warehouse_id)
);

CREATE TABLE stock_movements (
    movement_id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT NOT NULL,
    warehouse_id INT NOT NULL,
    movement_type VARCHAR(10) NOT NULL,
    quantity INT NOT NULL,
    movement_date DATE,
    reference_type VARCHAR(30),
    reference_id INT,

    FOREIGN KEY (product_id)
    REFERENCES products(product_id),

    FOREIGN KEY (warehouse_id)
    REFERENCES warehouses(warehouse_id)
);

select * from categories
select * from suppliers
select * from warehouses
select * from employees
select * from products
select * from customers
select * from purchase_orders
select * from purchase_items
select * from sales_orders
select * from sales_items
select * from inventory
select * from stock_movements
