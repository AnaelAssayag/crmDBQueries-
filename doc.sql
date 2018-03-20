USE classicmodels;
-- set global sql_mode="NO_BACKSLASH_ESCAPES,STRICT_TRANS_TABLE,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION";



-- Using Microsoft SQL database available here
-- http://www.mysqltutorial.org/mysql-sample-database.aspx
-- 
--
-- Get the daily amount of payments

SELECT 
	payments.paymentDate AS paymentDate,
	SUM(payments.amount)
FROM payments
GROUP BY paymentDate
-- -- 
-- Monthly payment

SELECT 
	DATE_FORMAT(payments.paymentDate, '%Y-%m') AS paymentMonth,
	SUM(payments.amount) AS totalPayment
FROM payments
GROUP BY paymentMonth



-- Payment per country and per year
SELECT 
	DATE_FORMAT(payments.paymentDate, '%Y') AS paymentYear,
	customers.country AS country,
	SUM(payments.amount) AS totalPayment
FROM payments
JOIN customers ON payments.customerNumber = customers.customerNumber
GROUP BY country, paymentYear

-- Total amout due per customer with Orders table

SELECT
	 orders.customerNumber AS customerNumber,	
	 SUM(orderdetails.priceEach * orderdetails.quantityOrdered ) AS amountOrdered
FROM orderdetails
JOIN orders ON orderdetails.orderNumber = orders.orderNumber
GROUP BY customerNumber



-- Total amout pay per customer

SELECT 
	payments.customerNumber AS customerNumber,
	SUM(payments.amount) AS amountPaid

FROM payments
GROUP BY customerNumber


-- Customer who should have pay more

SELECT
	payments.customerNumber,
	SUM(orderdetails.priceEach * orderdetails.quantityOrdered) AS amountDue,
	SUM(payments.amount) AS amountPaid	
FROM payments
JOIN orders ON payments.customerNumber = orders.customerNumber 
JOIN orderdetails ON orders.orderNumber = orderdetails.orderNumber
GROUP BY payments.customerNumber
HAVING  amountDue > amountPaid


