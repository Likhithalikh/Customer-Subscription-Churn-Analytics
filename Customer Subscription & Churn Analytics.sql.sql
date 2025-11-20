-- Customer Subscription & Churn Analytics SQL Project
-- Author: Likhitha

-- ------------------------------
-- 1. Create Database
-- ------------------------------
CREATE DATABASE churn_analytics;
USE churn_analytics;

-- ------------------------------
-- 2. Customer Table
-- ------------------------------
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100),
    join_date DATE,
    gender VARCHAR(10),
    age INT
);

-- ------------------------------
-- 3. Subscription Table
-- ------------------------------
CREATE TABLE subscriptions (
    subscription_id INT PRIMARY KEY,
    customer_id INT,
    plan VARCHAR(50),
    start_date DATE,
    end_date DATE,
    price DECIMAL(10,2),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- ------------------------------
-- 4. Churn Table
-- ------------------------------
CREATE TABLE churn (
    churn_id INT PRIMARY KEY,
    customer_id INT,
    churn_date DATE,
    churn_reason VARCHAR(255),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- ------------------------------
-- 5. Insert Sample Data
-- ------------------------------
INSERT INTO customers VALUES
(1, 'Aarav', 'aarav@mail.com', '2023-01-10', 'Male', 26),
(2, 'Diya', 'diya@mail.com', '2023-02-15', 'Female', 22),
(3, 'Rahul', 'rahul@mail.com', '2023-03-05', 'Male', 30),
(4, 'Liya', 'liya@mail.com', '2023-04-20', 'Female', 25);

INSERT INTO subscriptions VALUES
(101, 1, 'Premium', '2023-01-10', '2023-12-31', 999.00),
(102, 2, 'Basic', '2023-02-15', '2023-09-30', 499.00),
(103, 3, 'Premium', '2023-03-05', '2023-08-15', 999.00),
(104, 4, 'Standard', '2023-04-20', '2023-12-31', 699.00);

INSERT INTO churn VALUES
(1, 2, '2023-09-30', 'Too Expensive'),
(2, 3, '2023-08-15', 'Not Satisfied');

-- ------------------------------
-- 6. Useful Churn Analytics Queries
-- ------------------------------

-- 6.1 Churn Rate
SELECT 
    (SELECT COUNT(*) FROM churn) / (SELECT COUNT(*) FROM customers) * 100 
    AS churn_rate_percent;

-- 6.2 Active vs Churned Customers
SELECT
    (SELECT COUNT(*) FROM customers) AS total_customers,
    (SELECT COUNT(*) FROM churn) AS churned_customers;

-- 6.3 Churn Reasons Breakdown
SELECT churn_reason, COUNT(*) AS total 
FROM churn
GROUP BY churn_reason;

-- 6.4 Customer Lifetime (in days)
SELECT 
    c.customer_id, 
    name,
    DATEDIFF(IFNULL(ch.churn_date, CURDATE()), join_date) AS lifetime_days
FROM customers c
LEFT JOIN churn ch ON c.customer_id = ch.customer_id;

