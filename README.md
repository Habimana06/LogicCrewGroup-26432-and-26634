# THE LOGIC CREW-SQL PROJECT

# GROUP MEMBERS

-HABIMANA NTAGANIRA HAPPY (26432)

-MANZI FRED (26634)

# PROJECT OVERVIEW

This project explores SQL Window Functions through practical examples. Window functions allow for complex analytical queries that would otherwise require multiple self-joins or subqueries. These functions perform calculations across a set of rows related to the current row and managing our products, providing powerful analytical capabilities.
# DATA SET STRUCTURE
Below is the SQL script used to create our 'sales' table and populate it with sample data:
```sql
DROP TABLE IF EXISTS sales;

CREATE TABLE sales (
  sale_id INT PRIMARY KEY,
  product_category VARCHAR(50),
  sale_date DATE,
  amount INT
);

INSERT INTO sales (sale_id, product_category, sale_date, amount) VALUES
(1, 'Electronics', TO_DATE('01-JAN-23', 'DD-MON-YY'), 500),
(2, 'Electronics', TO_DATE('05-JAN-23', 'DD-MON-YY'), 600),
(3, 'Clothing', TO_DATE('02-JAN-23', 'DD-MON-YY'), 200),
(4, 'Clothing', TO_DATE('04-JAN-23', 'DD-MON-YY'), 250),
(5, 'Electronics', TO_DATE('03-JAN-23', 'DD-MON-YY'), 500),
(6, 'Clothing', TO_DATE('06-JAN-23', 'DD-MON-YY'), 300);

SELECT * FROM sales;
```
![WhatsApp Image 2025-04-17 at 7 44 37 PM](https://github.com/user-attachments/assets/c3ffee3f-2d26-4718-96e8-651a881c9bd3)
# 2. ANALYTICAL QUERIES

 .QUERY 1: Compare Values with LAG() and LEAD()
. PURPOSE: Show sales trends compared to previous/next records.
```sql
SELECT 
  product_category, 
  sale_date, 
  amount,
  LAG(amount, 1) OVER (PARTITION BY product_category ORDER BY sale_date) AS prev_amount,
  LEAD(amount, 1) OVER (PARTITION BY product_category ORDER BY sale_date) AS next_amount,
  CASE 
    WHEN amount > LAG(amount, 1) OVER (PARTITION BY product_category ORDER BY sale_date) THEN 'HIGHER'
    WHEN amount < LAG(amount, 1) OVER (PARTITION BY product_category ORDER BY sale_date) THEN 'LOWER'
    ELSE 'EQUAL' 
  END AS comparison
FROM sales;
```
![LAG AND LEAD](https://github.com/user-attachments/assets/c7cdd69b-039a-4790-8e87-bfbe8a808da1)



