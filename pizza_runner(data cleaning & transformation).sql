-- DATA CLEANING & TRANSFORMATIONS
-- splitting the order_time into two different table 'order_date' and 'order-time' 
ALTER TABLE customer_orders
ADD order_date DATE;
UPDATE customer_orders
SET order_date = CONVERT(order_time, DATE)

ALTER TABLE customer_orders
ADD order_times TIME;
UPDATE customer_orders
SET order_times = CONVERT(order_time, TIME);

-- dropping the order_time table-- 
ALTER TABLE customer_orders
DROP order_time;

--cleaning out all the null and NULL values in customer_orders table
UPDATE customer_orders
SET extras = CASE 
WHEN extras = 'null' THEN ''
WHEN extras IS NULL THEN ''
ELSE extras
END;

UPDATE customer_orders
SET exclusions = CASE
WHEN exclusions = 'null' THEN ''
ELSE exclusions
END;

-- runner_orders-- 
-- replacing all distance without km with km in runner_orders
UPDATE 	runner_orders
SET distance = CASE
WHEN distance = '10' THEN '10km'
WHEN distance = '23.4' THEN '23.4km'
WHEN distance = '23.4 km' THEN '23.4km'
ELSE distance
END;

UPDATE runner_orders
SET pickup_time = CASE 
WHEN pickup_time = 'null' THEN ''
ELSE pickup_time
END ;

UPDATE runner_orders
SET distance = CASE
WHEN distance = 'null' THEN ''
ELSE distance
END;

UPDATE runner_orders
SET duration = CASE
WHEN duration = 'null' THEN ''
ELSE duration
END;

UPDATE runner_orders
SET cancellation = CASE
WHEN cancellation = 'null' THEN ''
ELSE cancellation
END;

-- --updating duration column with the right figures--  
UPDATE runner_orders
SET duration = CASE
WHEN duration = '15 minute' THEN '15 minutes'
WHEN duration = '20 mins' THEN '20 minutes'
WHEN duration = '40' THEN '40 minutes'
WHEN duration = '15' THEN '15 minutes'
WHEN duration = '10minutes' THEN '10 minutes'
WHEN duration = '25mins' THEN '25 minutes'
ELSE duration
END;


SELECT * FROM pizza_runner.runner_orders;
SELECT * FROM pizza_runner.customer_orders;
SELECT * FROM pizza_runner.pizza_names;
SELECT * FROM pizza_runner.pizza_recipes;
SELECT * FROM pizza_runner.runners;
SELECT * FROM pizza_runner.pizza_toppings;


