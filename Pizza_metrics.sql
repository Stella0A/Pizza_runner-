--Pizza Metrics
-- How many pizzas were ordered?
SELECT COUNT(order_id) AS total_orders
FROM customer_orders

-- How many unique customer orders were made?
SELECT COUNT(DISTINCT order_id) AS unique_orders
FROM customer_orders

-- How many successful orders were delivered by each runner?
SELECT runner_id, COUNT(runner_id) AS orders
FROM runner_orders
WHERE cancellation = ''
GROUP BY runner_id

-- How many of each type of pizza was delivered?
SELECT cust.pizza_id, COUNT(cust.pizza_id) AS deliveries
FROM customer_orders cust
JOIN runner_orders   run
ON cust.order_id = run.order_id
WHERE cancellation = ''
GROUP BY pizza_id

-- How many Vegetarian and Meatlovers were ordered by each customer?
SELECT cust.customer_id, nam.pizza_name, COUNT(cust.pizza_id) AS deliveries
FROM customer_orders cust
JOIN pizza_names   nam
ON cust.pizza_id = nam.pizza_id
JOIN runner_orders run
ON cust.order_id = run.order_id
GROUP BY cust.customer_id,nam.pizza_name

-- What was the maximum number of pizzas delivered in a single order?
SELECT cust.order_id, COUNT(cust.pizza_id) AS deliveries
FROM customer_orders cust
JOIN runner_orders   run
ON cust.order_id = run.order_id
WHERE cancellation = ''
GROUP BY order_id
ORDER BY 2 DESC
LIMIT 1

-- For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
WITH changes AS(
SELECT cust.customer_id
    , cust.pizza_id
    , cust.exclusions
    , cust.extras
FROM customer_orders cust
JOIN runner_orders run
ON cust.order_id = run.order_id 
WHERE run.cancellation = '')

SELECT customer_id
    , SUM(CASE WHEN exclusions IS NOT NULL OR extras IS NOT NULL
                THEN 1 ELSE 0 END) AS pizza_changes
    , SUM(CASE WHEN exclusions IS NULL AND extras IS NULL
                THEN 1 ELSE 0 END) AS no_pizza_changes

FROM changes
GROUP BY customer_id
ORDER BY customer_id

-- How many pizzas were delivered that had both exclusions and extras?
WITH deliveries AS 
(SELECT cust.order_id
    , cust.pizza_id
    , cust.exclusions
    , cust.extras
FROM customer_orders cust
JOIN runner_orders   run
ON cust.order_id = run.order_id
WHERE cancellation = '')

SELECT order_id,
 COUNT(CASE WHEN exclusions IS NOT NULL AND extras IS NOT NULL
                THEN 1 ELSE 0 END) AS pizza_changes
FROM deliveries 


-- What was the total volume of pizzas ordered for each hour of the day?
SELECT HOUR(order_times) AS hour_24hr
    , COUNT(pizza_id) AS num_pizza
FROM customer_orders
GROUP BY hour_24hr
ORDER BY hour_24hr

-- What was the volume of orders for each day of the week?
DROP VIEW IF EXISTS daysofweek
CREATE VIEW daysofweek AS SELECT DAYOFWEEK(order_date) AS weekday
    , COUNT(pizza_id) AS num_pizza
FROM customer_orders
GROUP BY weekday
ORDER BY weekday
SELECT *,(CASE 
WHEN weekday = 1 THEN 'sunday'
WHEN weekday = 2 THEN 'monday'
WHEN weekday = 3 THEN 'tuesday'
WHEN weekday = 4 THEN 'wednesday'
WHEN weekday = 5 THEN 'thursday'
WHEN weekday = 6 THEN 'friday'
WHEN weekday = 7 THEN 'saturday'
ELSE weekday
END) AS days
FROM daysofweek



