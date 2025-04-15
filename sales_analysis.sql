-- sales_analysis.sql
-- Group: TheRowdyRollbacks
-- GitHub: https://github.com/TheRowdyRollbacks/SQL-Window-Functions

/* 
========================================
1. Create Table and Insert Sample Data
========================================
*/
DROP TABLE IF EXISTS sales;
CREATE TABLE sales (
  sale_id INT PRIMARY KEY,
  product_category VARCHAR(50),
  sale_date DATE,
  amount INT
);

-- Insert sample sales records
INSERT INTO sales (sale_id, product_category, sale_date, amount)
VALUES
  (1, 'Electronics', '2023-01-01', 500),
  (2, 'Electronics', '2023-01-05', 600),
  (3, 'Clothing', '2023-01-02', 200),
  (4, 'Clothing', '2023-01-04', 250),
  (5, 'Electronics', '2023-01-03', 500),
  (6, 'Clothing', '2023-01-06', 300);

/* 
========================================
2. Analytical Queries
========================================
*/

-- Query 1: Compare Values with LAG() and LEAD()
-- Purpose: Show sales trends compared to previous/next records
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

-- Query 2: Ranking with RANK() vs DENSE_RANK()
-- Purpose: Demonstrate ranking differences
SELECT 
  product_category, 
  sale_date, 
  amount,
  RANK() OVER (PARTITION BY product_category ORDER BY amount DESC) AS rank,
  DENSE_RANK() OVER (PARTITION BY product_category ORDER BY amount DESC) AS dense_rank
FROM sales;

-- Query 3: Top 3 Sales per Category
-- Purpose: Identify best-performing products
WITH ranked_sales AS (
  SELECT 
    *,
    DENSE_RANK() OVER (PARTITION BY product_category ORDER BY amount DESC) AS dr
  FROM sales
)
SELECT * FROM ranked_sales WHERE dr <= 3;

-- Query 4: First 2 Sales per Category
-- Purpose: Find earliest transactions
WITH earliest_sales AS (
  SELECT 
    *,
    ROW_NUMBER() OVER (PARTITION BY product_category ORDER BY sale_date) AS rn
  FROM sales
)
SELECT * FROM earliest_sales WHERE rn <= 2;

-- Query 5: Aggregation with Window Functions
-- Purpose: Compare category vs overall performance
SELECT 
  *,
  MAX(amount) OVER (PARTITION BY product_category) AS category_max,
  MAX(amount) OVER () AS overall_max
FROM sales;

/* 
========================================
3. Verification
========================================
*/
-- Confirm data insertion
SELECT * FROM sales ORDER BY product_category, sale_date;