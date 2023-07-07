-- 1 What are the most ordered items?
SELECT 
    product_name,
    SUM(sales.quantity) AS total_quantity_ordered
FROM sales 
INNER JOIN products ON products.product_id = sales.product_id 
GROUP BY products.product_name
ORDER BY total_quantity_ordered DESC;

-- 2 What are the top 10 most ordered items?
SELECT 
    product_name,
    SUM(sales.quantity) AS total_quantity_ordered,
    RANK() OVER (ORDER BY SUM(sales.quantity) DESC) AS quantity_rank
FROM sales 
INNER JOIN products ON products.product_id = sales.product_id 
GROUP BY products.product_name
ORDER BY total_quantity_ordered DESC
LIMIT 10;

-- 3 Does the most ordered item generate the most revenue?
SELECT 
    product_name,
    SUM(sales.quantity) AS total_quantity_ordered,
    RANK() OVER (ORDER BY SUM(sales.quantity) DESC) AS quantity_rank,
    SUM(sales.total_price) AS total_revenue_generated,
    RANK() OVER (ORDER BY SUM(sales.total_price) DESC) AS revenue_rank
FROM sales
INNER JOIN products ON products.product_id = sales.product_id 
GROUP BY products.product_name
ORDER BY total_quantity_ordered DESC;

--4 By how many orders did the most ordered item exceed the least ordered item?
WITH most_ordered_item AS (
    SELECT 
        product_name,
        SUM(sales.quantity) AS total_quantity_ordered
    FROM sales 
    INNER JOIN products ON products.product_id = sales.product_id 
    GROUP BY products.product_name
    ORDER BY total_quantity_ordered DESC
    LIMIT 1 
),
least_ordered_item AS (
    SELECT 
        product_name,
        SUM(sales.quantity) AS total_quantity_ordered
    FROM sales 
    INNER JOIN products ON products.product_id = sales.product_id 
    GROUP BY products.product_name
    ORDER BY total_quantity_ordered ASC
    LIMIT 1 
)
SELECT 
    most_ordered_item.total_quantity_ordered - least_ordered_item.total_quantity_ordered AS difference_between_orders
FROM most_ordered_item, least_ordered_item;

-- Who are the top 10 customers that order an item?
SELECT 
    customer_name, 
    customer_id,
    gender,
    SUM(quantity) AS total_orders_made,
    RANK() OVER (ORDER BY SUM(quantity) DESC) AS rank_of_top_customers 
FROM customers
INNER JOIN orders ON orders.customer = customers.customer_id 
INNER JOIN sales ON sales.order_id = orders.order_id
GROUP BY customer_name, customer_id
ORDER BY total_orders_made DESC 
LIMIT 10;

-- 5 Which gender orders the most?
SELECT
    gender,
    SUM(quantity) AS total_orders_made
FROM customers
INNER JOIN orders ON orders.customer = customers.customer_id 
INNER JOIN sales ON sales.order_id = orders.order_id
GROUP BY gender
ORDER BY total_orders_made DESC;

-- 6 Which gender generates the most revenue, and does the gender that orders the most bring in the most revenue?
SELECT
    gender,
    SUM(quantity) AS total_orders_made,
    RANK() OVER (ORDER BY SUM(quantity) DESC) AS rank_of_order_quantity,
    SUM(sales.total_price) AS total_revenue_generated,
    RANK() OVER (ORDER BY SUM(total_price) DESC) AS rank_of_revenue_generated,
    SUM(total_price) / COUNT(gender) AS revenue_generated_per_customer,
    DENSE_RANK() OVER (ORDER BY SUM(total_price) / COUNT(gender) DESC) AS revenue_rank
FROM customers
INNER JOIN orders ON orders.customer = customers.customer_id 
INNER JOIN sales ON sales.order_id = orders.order_id
GROUP BY gender
ORDER BY total_orders_made DESC;

--7 Which customers order less than the average?
SELECT 
    customer_name,
    ROUND(AVG(quantity), 2) AS total_orders_made
FROM customers
INNER JOIN orders ON orders.customer = customers.customer_id 
INNER JOIN sales ON sales.order_id = orders.order_id
GROUP BY customer_name, customer_id, orders.order_id
HAVING AVG(quantity) < (
    SELECT AVG(quantity)
    FROM customers
    INNER JOIN orders ON orders.customer = customers.customer_id 
    INNER JOIN sales ON sales.order_id = orders.order_id
)
ORDER BY total_orders_made DESC;

-- 8 What is the monthly revenue generated?
SELECT
    EXTRACT(MONTH FROM order_date) AS month,
    TO_CHAR(order_date, 'Month-yyyy') AS month_year,
    SUM(total_price) AS monthly_revenue
FROM customers
INNER JOIN orders ON orders.customer = customers.customer_id 
INNER JOIN sales ON sales.order_id = orders.order_id
GROUP BY EXTRACT(MONTH FROM order_date), TO_CHAR(order_date, 'Month-yyyy')
ORDER BY EXTRACT(MONTH FROM order_date);

--9 What is the cumulative monthly revenue?
SELECT 
    EXTRACT(MONTH FROM order_date) AS month,
    SUM(total_price) AS monthly_revenue,
    SUM(SUM(total_price)) OVER (ORDER BY EXTRACT(MONTH FROM order_date)) AS cumulative_sum
FROM customers
INNER JOIN orders ON orders.customer = customers.customer_id 
INNER JOIN sales ON sales.order_id = orders.order_id
GROUP BY EXTRACT(MONTH FROM order_date)
ORDER BY month;

-- 10 Which state has the most sales?
SELECT
    state,
    SUM(total_price) AS total_sales
FROM customers
INNER JOIN orders ON orders.customer = customers.customer_id 
INNER JOIN sales ON sales.order_id = orders.order_id
GROUP BY state
ORDER BY total_sales DESC
LIMIT 1;

-- 11 What is the best selling item in each state?
SELECT 
    rank_of_states.product_name,
    revenue,
    rank_of_states.state
FROM (
    SELECT 
        state AS state, 
        products.product_name,
        SUM(total_price) AS revenue,
        ROW_NUMBER() OVER (PARTITION BY state ORDER BY SUM(total_price) DESC) AS rn
    FROM customers 
    INNER JOIN orders ON orders.customer = customers.customer_id 
    INNER JOIN sales ON sales.order_id = orders.order_id
    INNER JOIN products ON products.product_id = sales.product_id 
    GROUP BY state, products.product_name
    ORDER BY SUM(total_price) DESC
) AS rank_of_states
WHERE rn = 1 
ORDER BY revenue DESC;
