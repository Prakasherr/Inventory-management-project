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
    
SELECT * FROM products;
SELECT product_name, brand, unit_price FROM products;
SELECT product_name, brand, unit_price FROM products WHERE unit_price > 10000;
SELECT employee_name, job_role, salary FROM employees WHERE salary > 40000;
SELECT product_name, unit_price FROM products WHERE unit_price BETWEEN 1000 AND 5000;
SELECT product_id, product_name, brand FROM products WHERE product_name LIKE '%Laptop%';
SELECT employee_name, job_role, salary FROM employees WHERE location = 'Chennai';
SELECT product_name, brand, unit_price FROM products ORDER BY unit_price DESC LIMIT 10;
SELECT COUNT(*) AS total_products FROM products;
SELECT ROUND(AVG(unit_price), 2) AS average_price FROM products;
SELECT MAX(unit_price) AS highest_price,MIN(unit_price) AS lowest_price FROM products;
SELECT location,COUNT(*) AS employee_count FROM employees GROUP BY location ORDER BY employee_count DESC;
SELECT job_role,ROUND(AVG(salary), 2) AS average_salary FROM employees GROUP BY job_role;
SELECT category_id,COUNT(*) AS product_count FROM products GROUP BY category_id ORDER BY product_count DESC;
SELECT warehouse_id,SUM(quantity) AS total_stock FROM inventory GROUP BY warehouse_id ORDER BY total_stock DESC;
SELECT p.product_id,p.product_name,p.brand,c.category_name FROM products p JOIN categories c ON p.category_id = c.category_id;
SELECT p.product_name,p.brand,s.supplier_name FROM products p JOIN suppliers s ON p.supplier_id = s.supplier_id;
SELECT e.employee_name,e.job_role,e.salary,e.location,w.warehouse_name FROM employees e JOIN warehouses w ON e.warehouse_id = w.warehouse_id;
SELECT so.sales_order_id,c.customer_name,so.order_date,so.total_amount,so.status FROM sales_orders so JOIN customers c ON so.customer_id = c.customer_id;
SELECT p.product_name, w.warehouse_name, i.quantity AS current_stock FROM inventory i JOIN products p ON i.product_id = p.product_id JOIN warehouses w ON i.warehouse_id = w.warehouse_id;
SELECT p.product_id,p.product_name,i.quantity AS current_stock,p.reorder_level FROM products p JOIN inventory i ON p.product_id = i.product_id WHERE i.quantity < p.reorder_level;
SELECT p.product_id,p.product_name,SUM(si.quantity) AS total_sold FROM products p JOIN sales_items si ON p.product_id = si.product_id JOIN sales_orders so     ON si.sales_order_id = so.sales_order_id WHERE so.status = 'Completed' GROUP BY p.product_id, p.product_name ORDER BY total_sold DESC LIMIT 10;
SELECT p.product_id, p.product_name, SUM(si.subtotal) AS total_revenue FROM products p JOIN sales_items si ON p.product_id = si.product_id JOIN sales_orders so ON si.sales_order_id = so.sales_order_id WHERE so.status = 'Completed' GROUP BY p.product_id, p.product_name ORDER BY total_revenue DESC;
SELECT c.customer_id, c.customer_name, SUM(so.total_amount) AS total_spending FROM customers c JOIN sales_orders so ON c.customer_id = so.customer_id WHERE so.status = 'Completed' GROUP BY c.customer_id, c.customer_name ORDER BY total_spending DESC LIMIT 10;
SELECT s.supplier_id, s.supplier_name, SUM(po.total_amount) AS total_purchase FROM suppliers s JOIN purchase_orders po ON s.supplier_id = po.supplier_id WHERE po.status = 'Completed' GROUP BY s.supplier_id, s.supplier_name HAVING SUM(po.total_amount) > 100000 ORDER BY total_purchase DESC;
WITH product_sales AS (SELECT product_id, SUM(quantity) AS total_sold FROM sales_items GROUP BY product_id) SELECT p.product_id, p.product_name, ps.total_sold FROM product_sales ps JOIN products p ON ps.product_id = p.product_id WHERE ps.total_sold > (SELECT AVG(total_sold) FROM product_sales) ORDER BY ps.total_sold DESC;
WITH customer_spending AS (SELECT customer_id, SUM(total_amount) AS total_spending FROM sales_orders WHERE status = 'Completed' GROUP BY customer_id) SELECT c.customer_id, c.customer_name, cs.total_spending FROM customer_spending cs JOIN customers c ON cs.customer_id = c.customer_id WHERE cs.total_spending > (SELECT AVG(total_spending) FROM customer_spending) ORDER BY cs.total_spending DESC;
SELECT p.product_id, p.product_name, p.brand FROM products p LEFT JOIN sales_items si ON p.product_id = si.product_id WHERE si.product_id IS NULL;
SELECT w.warehouse_id, w.warehouse_name, SUM(i.quantity * p.unit_price) AS inventory_value FROM warehouses w JOIN inventory i ON w.warehouse_id = i.warehouse_id JOIN products p ON i.product_id = p.product_id GROUP BY w.warehouse_id, w.warehouse_name ORDER BY inventory_value DESC;
WITH product_sales AS (SELECT p.product_id, p.product_name, p.category_id, SUM(si.quantity) AS total_sold FROM products p JOIN sales_items si ON p.product_id = si.product_id JOIN sales_orders so ON si.sales_order_id = so.sales_order_id WHERE so.status = 'Completed' GROUP BY p.product_id, p.product_name, p.category_id), ranked_products AS (SELECT *, RANK() OVER (PARTITION BY category_id ORDER BY total_sold DESC) AS product_rank FROM product_sales) SELECT rp.product_name, c.category_name, rp.total_sold FROM ranked_products rp JOIN categories c ON rp.category_id = c.category_id WHERE rp.product_rank = 1;
WITH monthly_sales AS (SELECT DATE_FORMAT(order_date, '%Y-%m') AS sales_month, SUM(total_amount) AS revenue FROM sales_orders WHERE status = 'Completed' GROUP BY DATE_FORMAT(order_date, '%Y-%m')) SELECT sales_month, revenue, LAG(revenue) OVER (ORDER BY sales_month) AS previous_month_revenue FROM monthly_sales ORDER BY sales_month;
WITH monthly_sales AS (SELECT DATE_FORMAT(order_date, '%Y-%m') AS sales_month, SUM(total_amount) AS revenue FROM sales_orders WHERE status = 'Completed' GROUP BY DATE_FORMAT(order_date, '%Y-%m')), previous_sales AS (SELECT sales_month, revenue, LAG(revenue) OVER (ORDER BY sales_month) AS previous_revenue FROM monthly_sales) SELECT sales_month, revenue, previous_revenue, ROUND((revenue - previous_revenue) / NULLIF(previous_revenue, 0) * 100, 2) AS growth_percentage FROM previous_sales ORDER BY sales_month;
WITH product_revenue AS (SELECT p.product_id, p.product_name, p.category_id, SUM(si.subtotal) AS revenue FROM products p JOIN sales_items si ON p.product_id = si.product_id JOIN sales_orders so ON si.sales_order_id = so.sales_order_id WHERE so.status = 'Completed' GROUP BY p.product_id, p.product_name, p.category_id), ranked_products AS (SELECT *, DENSE_RANK() OVER (PARTITION BY category_id ORDER BY revenue DESC) AS product_rank FROM product_revenue) SELECT rp.product_name, c.category_name, rp.revenue, rp.product_rank FROM ranked_products rp JOIN categories c ON rp.category_id = c.category_id WHERE rp.product_rank <= 3 ORDER BY c.category_name, rp.product_rank;
WITH product_sales AS (SELECT product_id, SUM(quantity) AS total_sold FROM sales_items GROUP BY product_id), average_sales AS (SELECT AVG(total_sold) AS avg_sold FROM product_sales) SELECT p.product_id, p.product_name, ps.total_sold, i.quantity AS current_stock, p.reorder_level FROM products p JOIN product_sales ps ON p.product_id = ps.product_id JOIN inventory i ON p.product_id = i.product_id CROSS JOIN average_sales a WHERE ps.total_sold > a.avg_sold AND i.quantity < p.reorder_level ORDER BY ps.total_sold DESC;
WITH sales_data AS (SELECT product_id, SUM(quantity) AS total_sold, SUM(subtotal) AS total_revenue FROM sales_items GROUP BY product_id), purchase_data AS (SELECT product_id, AVG(unit_cost) AS average_purchase_cost FROM purchase_items GROUP BY product_id), inventory_data AS (SELECT product_id, SUM(quantity) AS current_stock FROM inventory GROUP BY product_id) SELECT p.product_id, p.product_name, p.brand, COALESCE(s.total_sold, 0) AS total_sold, ROUND(COALESCE(s.total_revenue, 0), 2) AS total_revenue, ROUND(COALESCE(pd.average_purchase_cost, 0), 2) AS average_purchase_cost, p.unit_price AS selling_price, COALESCE(i.current_stock, 0) AS current_stock, ROUND(p.unit_price - COALESCE(pd.average_purchase_cost, 0), 2) AS profit_per_unit, ROUND((p.unit_price - COALESCE(pd.average_purchase_cost, 0)) / NULLIF(COALESCE(pd.average_purchase_cost, 0), 0) * 100, 2) AS profit_margin, RANK() OVER (ORDER BY COALESCE(s.total_revenue, 0) DESC) AS revenue_rank FROM products p LEFT JOIN sales_data s ON p.product_id = s.product_id LEFT JOIN purchase_data pd ON p.product_id = pd.product_id LEFT JOIN inventory_data i ON p.product_id = i.product_id ORDER BY revenue_rank;
