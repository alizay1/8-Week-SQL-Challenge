# Case Study #2 - Pizza Runner

<img width="683" alt="Screenshot 2023-09-01 at 11 26 41 AM" src="https://github.com/alizay1/8-Week-SQL-Challenge/assets/101383537/5d4f304e-8d0d-407e-a454-219340219550">


Link to Case Study: [click me](https://8weeksqlchallenge.com/case-study-2/)

# Introduction

Did you know that over 115 million kilograms of pizza
is consumed daily worldwide??? (Well according to Wikipedia anyway…)

Danny was scrolling through his Instagram feed when something
really caught his eye - “80s Retro Styling and Pizza Is The Future!”

Danny was sold on the idea, but he knew that pizza alone was not going
to help him get seed funding to expand his new Pizza Empire - so he had
one more genius idea to combine with it - he was going to Uberize it -
and so Pizza Runner was launched!

Danny started by recruiting “runners” to deliver fresh pizza from
Pizza Runner Headquarters (otherwise known as Danny’s house) and also
maxed out his credit card to pay freelance developers to build a mobile
app to accept orders from customers.


***

# Table of Contents

1. [Introducing the Data](#introducing-the-data)
   - [Entity Relationship Diagram](#entity-relationship-diagram)
   - [Tables](#tables)
   - [Business Objectives](#business-objectives)
2. [Data Cleaning and Transformation](#data-cleaning-and-transformation)
3. [Data Analysis Questions](#data-analysis-questions)
   - [A. Pizza Metrics](#a-pizza-metrics)
   - [B. Runner and Customer Experience](#b-runner-and-customer-experience)
   - [C. Ingredient Optimization](#c-ingredient-optimization)
   - [D. Pricing and Ratings](#d-pricing-and-ratings)

# Introducing the Data



## Entity Relationship Diagram

Looking at the ERD, six tables will be used in the case study; `runners`, `customer_orders`, `runner_orders`, `pizza_names`, `pizza_recipes`, and `pizza_toppings`.

<img width="593" alt="Screenshot 2023-09-01 at 1 38 28 PM" src="https://github.com/alizay1/8-Week-SQL-Challenge/assets/101383537/4092152b-7338-4e2b-afc9-91f8fc620efe">


## Tables


### Table 1: runners

The `runners` table provides the `registration_date` for each new runner.

![Screenshot 2023-09-01 at 1 52 34 PM](https://github.com/alizay1/8-Week-SQL-Challenge/assets/101383537/1c3afb13-c6a6-4309-b1fe-9707c286d6d5)



### Table 2: customer_orders

The `customer_orders` table includes the `order_id`, the `customer_id`, 
the `pizza_id` representing the type of pizza, the ingredient `exclusions` id, 
the ingredient `extras` id, and the `order_time` with a timestamp.

You will notice problems with the data in the `exclusions` and `extras`
columns. This will be addressed before starting the analysis.


![Screenshot 2023-09-01 at 1 53 58 PM](https://github.com/alizay1/8-Week-SQL-Challenge/assets/101383537/035fad31-e92c-4d9b-8a2f-10e268bec64f)



### Table 3: runner_orders

The `runner_orders` table includes the `order_id`, the `runner_id`, 
the `pickup_time` of when a runner picks up the pizza(s), the `distance`
travelled by the runner in kilometers, the `duration` of the delivery in
minutes, and the `cancellation` of an order or not.

As with the `customer_orders` table, you will notice problems with null values
and blank spaces in most of the columns. In addition,
the `duration` and `distance` columns need to be edited in accordance to their
perceived data type. This will also be addressed before starting the analysis.

![Screenshot 2023-09-01 at 1 55 47 PM](https://github.com/alizay1/8-Week-SQL-Challenge/assets/101383537/8bd46711-1366-41ac-9872-20c2f86941d8)




### Table 4: pizza_names

The 'pizza_names' table provides the corresponding `pizza_name` to the `pizza_id`.


![Screenshot 2023-09-01 at 2 01 12 PM](https://github.com/alizay1/8-Week-SQL-Challenge/assets/101383537/f5d3c764-11cc-40fa-b199-04bd5107754d)



### Table 5: pizza_recipes

The `pizza_recipes` table lists out all the appropriate `toppings` (in id format) according to the `pizza_id`.


![Screenshot 2023-09-01 at 2 02 03 PM](https://github.com/alizay1/8-Week-SQL-Challenge/assets/101383537/76929fca-2612-4034-95b3-767f88382d0b)




### Table 6: pizza_toppings

The `pizza_toppings` table provides the `topping_name` corresponding to the `topping_id` from the `pizza_names` table.


![Screenshot 2023-09-01 at 2 03 07 PM](https://github.com/alizay1/8-Week-SQL-Challenge/assets/101383537/9ac28bbd-381a-4597-9bba-601574061c10)


***

## Business Objectives


### What does Danny want to understand from the data? Furthermore, what does he want us to do with the data?

1.  Explore different pizza metrics.
2.  What are the runner and customer experiences in the restaurant?
3.  Possible ingredient optimizations.
4.  Analyze pricing and ratings.
5.  Perform data cleaning and transformations.



### Why does he need these insights?

1.  Wants to optimize Pizza Runners' operations.
2.  Help direct its runners more effectively.


***

# Data Cleaning and Transformation


There were issues seen in the `customer_orders` and `runner_orders` tables. 
Instead of making direct edits to the primary tables, we will create temporary
tables that we can access for the rest of the analysis. In a real world case setting,
it's not the best approach to make permanent changes in a database. Since other 
employees may have to access the same database in the future, its imperative
that the tables remain in its original state.


### Customer Orders Table



#### Approach:



1. Create a temporary table called `customer_orders_temp`.

2. Use **CASE WHEN** statements to reformat the columns for `exclusions` and 
   `extras`. Indicate for `exclusions` that if the values are null characters or blank, 
   replace with *'no exclusions'* text. For `extras`, if the values are null, null 
   characters, or blanks, then replace with *'no extras'* text.

3. Make sure to select all the other columns from the `customer_orders` table.

   

```sql


 
DROP TABLE IF EXISTS customer_orders_temp;
CREATE TEMP TABLE customer_orders_temp AS (
 
SELECT order_id,
       customer_id,
       pizza_id,
       CASE WHEN exclusions = 'null' OR exclusions = '' THEN 'no exclusions'
            ELSE exclusions END AS exclusions,
       CASE WHEN extras IS NULL OR extras = 'null' OR extras = '' THEN 'no extras'
            ELSE extras END AS extras,
       order_time
 FROM customer_orders

 
)


```


![Screenshot 2023-09-01 at 2 20 19 PM](https://github.com/alizay1/8-Week-SQL-Challenge/assets/101383537/8d1575d2-27f4-416c-bb0a-925dce6615d1)




***
### Runners Orders Table



#### Approach:

1. Create a temporary table called `runner_orders_temp`.

2. First, create an inline subquery called `removed_nulls` that selects
   all columns from `runner_orders` and uses **CASE WHEN** statements to
   change the `pickup_time`, `distance`, `duration`, and `cancellation` columns.
   
3. For the null characters in `pickup_time`, `distance`, and `duration`, simply
   replace with the NULL function since these columns will be casted as either
   an integer, numeric, or timestamp.
   
4. Lastly, for the `cancellation` column, if the values are null, null 
   characters, or blanks, then replace with *'No Cancellation'* text.


5. Now that the null values have been addressed, the characters in the `distance`
   and `duration` columns need to to be removed. Start by selecting all columns
   from `removed_nulls`.

6. To remove the *'km'* in the `distance` column, utilize **TRIM(TRAILING 'km' FROM distance)**.
   Next, take out any unwanted spaces by inserting **TRIM(TRAILING 'km' FROM distance)** into
  **REPLACE()** as the first argument. Furthermore, use ' ' and '' as the second and third
   argument respectively in the same function. Save the newly reformatted column
   as `distance_in_km`.
   
7. In the `duration` column, since the time for each order is two digits, utilize **LEFT(duration, 2)**
   to extract the first two characters. Rename the reformatted column as `duration_in_min`.
   


```sql


 
DROP TABLE IF EXISTS runner_orders_temp;
CREATE TEMP TABLE runner_orders_temp AS (
 
SELECT order_id,
       runner_id,
       pickup_time,
       REPLACE(TRIM(TRAILING 'km' FROM distance), ' ', '') AS distance_in_km,
       LEFT(duration, 2) AS duration_in_min,
       cancellation
FROM		(SELECT order_id,
                 runner_id,
                 CASE WHEN pickup_time = 'null' THEN NULL
                      ELSE pickup_time END AS pickup_time,
                 CASE WHEN distance = 'null' THEN NULL
                      ELSE distance END AS distance,
                 CASE WHEN duration = 'null' THEN NULL
                      ELSE duration END AS duration,
                 CASE WHEN cancellation IS NULL OR cancellation = 'null' OR cancellation = '' THEN 'No Cancellation'
                      ELSE cancellation END AS cancellation
          FROM runner_orders) removed_nulls

)


```


![Screenshot 2023-09-01 at 2 31 31 PM](https://github.com/alizay1/8-Week-SQL-Challenge/assets/101383537/d822fd3f-b044-4ebf-9cce-963d1336f19c)




8. You will notice that the `pickup_time` data type is character varying, while `distance_in_km`
   and `duration_in_min` are texts. This will obviously be a problem later
   on in the analysis.
   
9. To address this, use **ALTER TABLE** to alter the columns previously mentioned. For
   `pickup_time`, **TIMESTAMP WITHOUT A TIME ZONE** is the most appropriate choice. For 
   `distance_in_km` since some values have decimals, utilize a **NUMERIC** data type. 
   Lastly, for `duration_in_min`, change it to an **INTEGER** data type.



```sql

ALTER TABLE runner_orders_temp
 ALTER COLUMN pickup_time TYPE TIMESTAMP WITHOUT TIME ZONE USING pickup_time::TIMESTAMP WITHOUT TIME ZONE,
 ALTER COLUMN distance_in_km TYPE NUMERIC USING distance_in_km::NUMERIC,
 ALTER COLUMN duration_in_min TYPE INT USING duration_in_min::INTEGER;


```

![Screenshot 2023-09-01 at 2 53 44 PM](https://github.com/alizay1/8-Week-SQL-Challenge/assets/101383537/760df9ce-bb50-4266-b710-f34482290399)




***

# Data Analysis Questions


Note: `customer_orders_temp` and `runner_orders_temp` will be used for the remainder of the analysis.




## A. Pizza Metrics

### Question 1: How many pizzas were ordered?



#### Approach:

1. For this question, we simply have to count all the orders.
   Select **COUNT(order_id)** from the `customer_orders_temp` table and
   rename it as `pizzas_ordered`.

```sql

SELECT COUNT(order_id) AS pizzas_ordered
FROM customer_orders_temp;

```



#### Solution:


![Screenshot 2023-09-01 at 4 53 10 PM](https://github.com/alizay1/8-Week-SQL-Challenge/assets/101383537/8ffca9aa-004f-4dc5-b40d-198f6008920a)



#### Interpretation:

14 pizzas were ordered.

***


### Question 2: How many unique customer orders were made?



#### Approach:

1. We have to remove the duplicate orders in `order_id`.
   Modify the query from question 1 by including **DISTINCT()** ie.
   **COUNT(DISTINCT(order_id))**. Rename it as `unique_orders`.


```sql

SELECT COUNT(DISTINCT(order_id)) AS unique_orders
FROM customer_orders_temp;

```

#### Solution:


![Screenshot 2023-09-01 at 4 56 15 PM](https://github.com/alizay1/8-Week-SQL-Challenge/assets/101383537/89a1d1d1-f086-4faa-a715-f423680151f9)



#### Interpretation:

10 unique orders were made.

***



### Question 3: How many successful orders were delivered by each runner?



#### Approach:

1. In the `runner_orders_temp` table, only consider orders that 
   were not cancelled. Afterwards, we count the amount of non-cancelled orders by
   `runner_id`.
  
2. To do this, select `runner_id` and **COUNT(cancellation)** then filter the results 
   where the `cancellation` column equals *'No Cancellation'*. Next, **GROUP BY**
   `runner_id` to get the intended results. Rename **COUNT(cancellation)**
   as `successful_orders`.


```sql

SELECT runner_id,
       COUNT(cancellation) AS successful_orders
FROM runner_orders_temp
WHERE cancellation = 'No Cancellation'
GROUP BY 1;

```

#### Solution:


![Screenshot 2023-09-01 at 5 08 50 PM](https://github.com/alizay1/8-Week-SQL-Challenge/assets/101383537/0b30ae89-21a9-4b27-9c38-9a6b4deb84a3)



#### Interpretation:

Runner 1 had 4 successful orders while runner 2 had 3. Runner 3 
only had 1 successful order.

***


### Question 4: How many of each type of pizza was delivered?


#### Approach:

1. To answer this question, we need the `pizza_id`, the `pizza_name`,
   and the `cancellation` status. First, peform an **INNER JOIN** between
   `customer_orders_temp` and `runner_orders_temp` then another **INNER JOIN** 
   between `customer_orders_temp` and `pizza_names`.
   
2. Filter the results where `cancellation` equals *'No cancellation'*.

3. Use **COUNT(c.pizza_id)** then **GROUP BY** `pizza_id` followed by  `pizza_name` to get
   the number of pizzas delivered by pizza type.



```sql

SELECT c.pizza_id,
       p.pizza_name,
       COUNT(c.pizza_id) AS delivered_pizza_by_type
FROM customer_orders_temp AS c
JOIN runner_orders_temp AS r
ON r.order_id = c.order_id
JOIN pizza_names AS p
ON p.pizza_id = c.pizza_id
WHERE cancellation = 'No Cancellation'
GROUP BY 1, 2;

```

#### Solution:


![Screenshot 2023-09-01 at 5 12 03 PM](https://github.com/alizay1/8-Week-SQL-Challenge/assets/101383537/7b0175f5-862f-4d03-8308-b4c4f1c7a516)




#### Interpretation:

9 meatlovers pizzas were delivered while vegetarian pizzas had only 3 deliveries.

***



### Question 5: How many Vegetarian and Meatlovers were ordered by each customer?


#### Approach:

1. First, perform an **INNER JOIN** between `customer_orders_temp` and `pizza_names`
   to get the appropriate pizza names.
   
2. To get how many Vegetarian and Meatlovers pizzas were ordered by each customer,
   use **COUNT(p.pizza_name)**. Next, **GROUP BY** the `customer_id` then the `pizza_name`.

3. **ORDER BY** the `customer_id` for better readabilty.


```sql

SELECT c.customer_id,
       p.pizza_name,
       COUNT(p.pizza_name) AS pizzas_ordered
FROM customer_orders_temp AS c
JOIN pizza_names AS p
ON p.pizza_id = c.pizza_id
GROUP BY 1, 2
ORDER BY 1;

```

#### Solution:


![Screenshot 2023-09-01 at 5 15 18 PM](https://github.com/alizay1/8-Week-SQL-Challenge/assets/101383537/97350535-d093-4509-a8c4-5c23d3e55b55)



#### Interpretation:

1. Customer 101 ordered 2 Meatlovers pizzas and 1 Vegetarian pizza.
2. Customer 102 ordered 2 Meatlovers pizzas and 1 Vegetarian pizza.
3. Customer 103 ordered 3 Meatlovers pizzas and 1 Vegetarian pizza.
4. Customer 104 ordered 3 Meatlovers pizzas.
5. Customer 105 ordered 1 Vegetarian pizza.

***



### Question 6: What was the maximum number of pizzas delivered in a single order?


#### Approach:

1. We need information from both the `customer_orders_temp` and 
   `runner_orders_temp` so perform an **INNER JOIN** between these two tables.
   
2. Filter where `cancellation` equals *'No Cancellation'*.

3. To get the max number of pizzas delevered in a single order, use
   **COUNT(c.order_id)** then **GROUP BY** `order_id`. Next, **ORDER BY** **COUNT(c.order_id)** 
   in descending order then use **LIMIT** to select the first row.


```sql

SELECT c.order_id,
       COUNT(c.order_id) AS max_orders_delivered
FROM customer_orders_temp AS c
JOIN runner_orders_temp AS r
ON r.order_id = c.order_id
WHERE r.cancellation = 'No Cancellation'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;

```


#### Solution:


![Screenshot 2023-09-01 at 5 19 48 PM](https://github.com/alizay1/8-Week-SQL-Challenge/assets/101383537/1b6329d4-ae30-4b96-a151-8893a6d87e7a)



#### Interpretation:

Order number 4 had the most number of pizzas delivered which was 3.

***



### Question 7: For each customer, how many delivered pizzas had at least 1 change and how many had no changes?


#### Approach:

1. Create a common table expression called `added_column`. Within the CTE,
   perform an **INNER JOIN** between `customer_orders_temp` and `runner_orders_temp`.
   
   
2. To help answer the question, select all the necessary columns and use **CASE WHEN** to add
   an additional column with the appropriate conditions. When 'exlusions' equals *'no exclusions'*
   and `extras` equals *'no extraas'* then write *'no changes'*. If the value doesn't follow this 
   criteria write *'at least one change'*. Name the new column, `changes_made_to_pizza`.

3. Filter where `cancellation` equals *'No Cancellation'*.


4. Outside of the CTE, select the `customer_id`, `changes_made_to_pizza`, and 
   **COUNT(a.changes_made_to_pizza)**. Afterwards, **GROUP BY** the `customer_id` followed by
   `changes_made_to_pizza` to get the appropriate solution.


```sql

WITH added_column AS (

SELECT c.customer_id,
       c.exclusions,
       c.extras,
       CASE WHEN c.exclusions = 'no exclusions' AND c.extras = 'no extras' THEN 'no changes'
            ELSE 'at least one change' END AS changes_made_to_pizza
FROM customer_orders_temp AS c
JOIN runner_orders_temp AS r
ON r.order_id = c.order_id
WHERE r.cancellation = 'No Cancellation'

)


SELECT a.customer_id,
       a.changes_made_to_pizza,
       COUNT(a.changes_made_to_pizza) AS changes_count
FROM added_column AS a
GROUP BY 1, 2
ORDER BY 1;

```

#### Solution:


![Screenshot 2023-09-01 at 5 37 49 PM](https://github.com/alizay1/8-Week-SQL-Challenge/assets/101383537/6ec75e5b-eb0b-44f7-8484-a81c134991fc)




#### Interpretation:

1. Customer 101 and 102 made no changes on all the pizzas they ordered.

2. Customer 103 and 104 made at least one change to the pizzas they ordered
   except for one pizza ordered by customer 104.

3. Customer 105 had at least one change.


***



### Question 8: How many pizzas were delivered that had both exclusions and extras?


#### Approach:

1. Create a common table expression called `exclusions_and_extras`. Within the CTE,
   perform an **INNER JOIN** between `customer_orders_temp` and `runner_orders_temp`.
   
   
2. Use **CASE WHEN** to indicate when `exlusions` does not equal *'no exclusions'*
   and `extras` does not equal *'no extras'* then write *'both'*. If the value doesn't follow this 
   criteria write *'n/a'*. Again, name the new column, `changes_made_to_pizza`.

3. Filter where `cancellation` equals *'No Cancellation'*.



4. Outside of the CTE, select `changes_made_to_pizza`, and 
   **COUNT(a.changes_made_to_pizza)**. Afterwards, **GROUP BY** the `changes_made_to_pizza`
   then use **HAVING** to filter the results where `changes_made_to_pizza`
   equals *'both'*.


```sql


WITH exclusions_and_extras AS (

SELECT c.customer_id,
       c.exclusions,
       c.extras,
       CASE WHEN c.exclusions != 'no exclusions' AND c.extras != 'no extras' THEN 'both'
            ELSE 'n/a' END AS changes_made_to_pizza
FROM customer_orders_temp AS c
JOIN runner_orders_temp AS r
ON r.order_id = c.order_id
WHERE r.cancellation = 'No Cancellation'

)


SELECT e.changes_made_to_pizza,
       COUNT(e.changes_made_to_pizza) AS changes_count
FROM exclusions_and_extras AS e
GROUP BY 1
HAVING e.changes_made_to_pizza = 'both';



```


#### Solution:


![Screenshot 2023-09-01 at 5 43 49 PM](https://github.com/alizay1/8-Week-SQL-Challenge/assets/101383537/8c7b9c56-8e38-49d7-81a2-4edec89d64d7)



#### Interpretation:

Only 1 pizza that was delivered had both extras and exclusions.

***



### Question 9: What was the total volume of pizzas ordered for each hour of the day?



#### Approach:


1. Use **DATE_PART()** to extract the *hour* from `order_time` in the `customers_orders_temp`
   table.

2. In addition, select the **COUNT(order_id)** then **GROUP BY DATE_PART('hour', order_time)**
   to get the intended results.
   
3. **ORDER BY** the hours extracted from `order_time`.


```sql

SELECT DATE_PART('hour', order_time) AS hour,
       COUNT(order_id) total_orders_by_hour
FROM customer_orders_temp
GROUP BY 1
ORDER BY 1;

```

#### Solution:



![Screenshot 2023-09-01 at 5 53 29 PM](https://github.com/alizay1/8-Week-SQL-Challenge/assets/101383537/d58e21e2-76f9-4a83-a963-3103e2f2977a)




#### Interpretation:

Most orders were placed between 13-18 (1:00 pm - 6:00 pm) and 21-23 (9:00 pm - 11:00 pm).
Only 1 order was made at 11 (11:00 am) and 19 (7:00 pm).

***


### Question 10: What was the volume of orders for each day of the week?


#### Approach:

1. Use **DATE_PART()** to extract the day of the week from `order_time` in the `customers_orders_temp`
   table.

2. In addition, select the **COUNT(order_id)** then **GROUP BY DATE_PART('dow', order_time)**
   to get the intended results.
   
3. **ORDER BY** the day of the week extracted from `order_time`.


```sql

SELECT DATE_PART('dow', order_time) AS day_of_week,
       COUNT(order_id) total_orders_by_dow
FROM customer_orders_temp
GROUP BY 1
ORDER BY 1;


```

#### Solution:


![Screenshot 2023-09-01 at 5 59 33 PM](https://github.com/alizay1/8-Week-SQL-Challenge/assets/101383537/b601074d-42a1-4ab2-80cd-4c686d969726)



#### Interpretation:

Most of the volume of orders occurred on Wednesday and Saturday followed by Thursday.
Surprisingly, only 1 order was placed on Friday.

***



## B. Runner and Customer Experience


### Question 1: How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)


#### Approach:

1. From the `runners` table, use **DATE_PART()** to extract the week from the `registration_date`.

2. Afterwards, select **COUNT(runner_id)** then **GROUP BY DATE_PART('week', registration_date)**.


```sql

SELECT DATE_PART('week', registration_date) AS week,
       COUNT(runner_id) AS num_of_runners
FROM runners
GROUP BY 1
ORDER BY 1;

```



![Screenshot 2023-09-01 at 6 02 06 PM](https://github.com/alizay1/8-Week-SQL-Challenge/assets/101383537/c7e738c5-7efd-4409-a315-f1e2dbfa9eef)




3. Upon evaluating the results, one issue stands out. It seems that the earliest registration dates
   are being considered as dates in the last week of the year.

4. If we refer to a calender, the week starts on 2021-01-04 instead of 2021-01-01. To fix this, we need 
   to offset the `registration_date` by 3 days. In other words, in **DATE_PART()** add 3
   to the `registration_date`.


```sql

SELECT DATE_PART('week', registration_date + 3) AS week,
	   COUNT(runner_id) AS num_of_runners
FROM runners
GROUP BY 1
ORDER BY 1;


```



#### Solution:


![Screenshot 2023-09-01 at 6 03 39 PM](https://github.com/alizay1/8-Week-SQL-Challenge/assets/101383537/e24d4987-cad5-4f56-8f25-05c3807ad851)



#### Interpretation:

2 runners registered in the first week of 2021. Only 1 runner registered in the
second and third week of January.

***



### Question 2: What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?


#### Approach:


1. What we need is the `runner_id`, `pickup_time`, and `order_time`. Start by performing
   an **INNER JOIN** between the `customer_orders_temp` and `runner_orders_temp`. Next,
   filter the results where `cancellation` equals *'No Cancellation'*.

2. Let's find how long it took each runner to pick up an order. We need to find the difference 
   between the `pickup_time` and the `order_time`. Use **EXTRACT()** to take out the exact minutes
   from the difference of the two times. From here, use **AVG()** around the differenced times then 
   **GROUP BY** `runner_id`.
   
3. Utilize **ROUND()** to clean up the results, then **ORDER BY** the averaged times in descending order.




```sql

SELECT r.runner_id,
       ROUND(AVG(EXTRACT(MINUTE FROM (r.pickup_time - c.order_time))), 2) AS avg_time
FROM customer_orders_temp AS c
JOIN runner_orders_temp AS r
ON r.order_id = c.order_id
WHERE r.cancellation = 'No Cancellation'
GROUP BY 1
ORDER BY 2 DESC;

```

#### Solution:


![Screenshot 2023-09-01 at 6 09 22 PM](https://github.com/alizay1/8-Week-SQL-Challenge/assets/101383537/4a0859a6-2ede-4936-bc79-944780bd9d28)



#### Interpretation:

On average, runner 2 took the most time to pick up orders followed by runner 1 then 3.

***



### Question 3: Is there any relationship between the number of pizzas and how long the order takes to prepare?


#### Approach:


1. Perform an **INNER JOIN** between the `customer_orders_temp` and `runner_orders_temp`. Next,
   filter the results where `cancellation` equals *'No Cancellation'*.

2. To find the number of pizzas for each order, use **COUNT(c.order_id)**.

3. As with the previous question, find the difference between the `pickup_time` and the `order_time`
   and then use **EXTRACT()** to take out the exact minutes. Subsequently, use **SUM()** to get the total time.
   
4. To get the intended results, **GROUP BY** `order_id` then **ORDER BY** the number of pizzas.
	


```sql

SELECT c.order_id,
       COUNT(c.order_id) AS num_of_pizzas,
       SUM(EXTRACT(MINUTE FROM (r.pickup_time - c.order_time))) AS total_time_in_min
FROM customer_orders_temp AS c
JOIN runner_orders_temp AS r
ON r.order_id = c.order_id
WHERE r.cancellation = 'No Cancellation'
GROUP BY 1
ORDER BY 2;

```

#### Solution:


![Screenshot 2023-09-01 at 6 13 36 PM](https://github.com/alizay1/8-Week-SQL-Challenge/assets/101383537/86b2e0df-f7e2-45a1-935c-39aed2e995b9)



#### Interpretation:

As the number of pizzas increases, the time it takes to make them increases
as well.

***


### Question 4: What was the average distance travelled for each customer?


#### Approach:

1. Perform an **INNER JOIN** between the `customer_orders_temp` and `runner_orders_temp`. Next,
   filter the results where `cancellation` equals *'No Cancellation'*.

2. Use **ROUND(AVG(r.distance_in_km), 2)** then **GROUP BY** `customer_id` to find the 
   rounded average distances for each customer.
   
3. **ORDER BY** the averaged distances in descending order.


```sql


SELECT c.customer_id,
       ROUND(AVG(r.distance_in_km), 2) AS avg_distance_km
FROM customer_orders_temp AS c
JOIN runner_orders_temp AS r
ON r.order_id = c.order_id
WHERE r.cancellation = 'No Cancellation'
GROUP BY 1
ORDER BY 2 DESC;

```

#### Solution:


![Screenshot 2023-09-01 at 6 18 45 PM](https://github.com/alizay1/8-Week-SQL-Challenge/assets/101383537/23e8adea-72b9-4f37-beaa-f1c9c81578b3)



#### Interpretation:

On average:

1. 25 kilometers were travelled for customer 105.  
2. 23.40 kilometers were travelled for customer 103. 
3. 20 kilometers were travelled for customer 101.
4. 16.73 kilometers were travelled for customer 102.
5. 10 kilometers were travelled for customer 104.


***


### Question 5: What was the difference between the longest and shortest delivery times for all orders?


#### Approach:


1. First, to find the difference between the longest and shortest delivery
   times simply use **MAX(duration_in_min)** and **MIN(duration_in_min)** and 
   take the difference between the two.

2. Filter the results where `cancellation` equals *'No Cancellation'*.



```sql

SELECT MAX(duration_in_min) - MIN(duration_in_min) AS diff_in_time
FROM runner_orders_temp
WHERE cancellation = 'No Cancellation'


```

#### Solution:


![Screenshot 2023-09-01 at 6 21 53 PM](https://github.com/alizay1/8-Week-SQL-Challenge/assets/101383537/873344b5-1ced-49a1-90c0-4a89cb226e0c)



#### Interpretation:

The difference in time was 30 minutes.



***


### Question 6: What was the average speed for each runner for each delivery and do you notice any trend for these values?


#### Approach:

1. The speed formula is the distance travelled divided by time. In this case, we 
   need to divide each `distance_in_km` by `duration_in_min` to
   get the speed. However before this, let's convert the `duration_in_min` to hours to
   get *km/hr*. 
  
2. First, use **CAST** to change `duration_in_min` data type to numeric, then divide each value by 60 in the
   column to convert to hours. Changing the values to numeric will allow division of decimals close to 0. 
   Afterwards, divide `distance_in_km` by **CAST(duration_in_min AS numeric)/ 60)**.

3. Use **ROUND(AVG(....), 2)** then **GROUP BY** the `order_id` followed by
   the `runner_id` to get the the average speed in km/hr.


4. Lastly, filter the results where `cancellation` equals *'No Cancellation'*.



```sql

SELECT  order_id,
        runner_id,
        ROUND(AVG((distance_in_km) / (CAST(duration_in_min AS numeric)/ 60)), 2) AS avg_speed_in_kmh
FROM runner_orders_temp
WHERE cancellation = 'No Cancellation'
GROUP BY 1, 2
ORDER BY 2, 3

```

#### Solution:


![Screenshot 2023-09-01 at 6 28 51 PM](https://github.com/alizay1/8-Week-SQL-Challenge/assets/101383537/4a1119fc-db05-4828-8eee-9e6083c539df)



#### Interpretation:


1. Runner 1's average speed gradually increased between 37.50 km/hr to 60 km/hr by order.
2. By the end of their deliveries, runner 2's average speed increased about 3x.
3. Runner 3's average speed was 40 km/hr.

***


### Question 7: What is the successful delivery percentage for each runner?


#### Approach:


1. First create a common table expression aliased as `runner_success`. Use two **CASE WHEN** statements to
   add two new columns where the first indicates if the order was successful or not.
   And for the second, no distiction is needed as it will be considered the total delivered and 
   non-delivered orders made.
  
2. In the outer query, select the **SUM(r.successful_deliveries)** divided by **SUM(r.total)** from
   `runner_success` CTE. Make sure to **CAST** each column to a numeric data type.
   Lastly, multiply each value by 100 and **ROUND** to the nearest whole number.
   
3. **GROUP BY** the `runner_id` to get the successful delivery percentage for each runner.



```sql

WITH runner_success AS (

SELECT runner_id,
       cancellation,
       CASE WHEN cancellation = 'No Cancellation' THEN 1 ELSE 0 END AS successful_deliveries,
       CASE WHEN cancellation = 'No Cancellation' THEN 1 ELSE 1 END AS total
FROM runner_orders_temp 

)


SELECT r.runner_id,
       ROUND((CAST(SUM(r.successful_deliveries) AS numeric)/
             CAST(SUM(r.total) AS numeric))* 100, 0) AS success_delivery_percent
FROM runner_success AS r
GROUP BY 1
ORDER BY 2 DESC;


```

#### Solution:


![Screenshot 2023-09-01 at 6 34 10 PM](https://github.com/alizay1/8-Week-SQL-Challenge/assets/101383537/092a1624-ab7f-4b4c-ae74-80b802068d3a)


#### Interpretation:


1. Runner 1 had a 100% success rate.
2. Runner 2 had a 75% success rate.
3. Runner 3 only had a 50% success rate.


***




## C. Ingredient Optimization


### Question 1: What are the standard ingredients for each pizza?


#### Approach:


1. Looking at the `pizza_recipes` and `pizza_toppings` tables, we need
   to somehow join these two tables to include the `pizza_id` and/or the `pizza_name`, 
   the `ingredients`, and the `toppings`. The problem is that in the `pizza_recipes`
   table the `toppings` are listed out in the same row so joining the two tables
   won't be possible without some adjustments.

2. To address this issue, utilize the **STRING_TO_ARRAY()** function on the
   `toppings` column indicating the comma as the delimiter. This function serves
   to split a string into array elements. Next, place **STRING_TO_ARRAY(toppings,',')**
   into the **UNNEST()** function which will expand the array elements into rows.
   Make sure to **CAST** the unnested list as an integer or we won't be able to join the
   tables. Place this query in a common table expression named `seperated_list`.


3. In the outer query, **INNER JOIN** the `pizza_toppings` and `seperated_list` tables.
   Next, **INNER JOIN** the `pizza_names` table. Make sure to join on the `topping_id`
   and the `pizza_id` from the `seperated_list` table.


4. Select all the necessary columns to get the intended results.


```sql

WITH seperated_list AS (
	
SELECT pizza_id,
       CAST(UNNEST(STRING_TO_ARRAY(toppings,',')) AS integer) AS topping_id
FROM pizza_recipes
	
)


SELECT pn.pizza_name,
       p.topping_name AS ingredients,
       p.topping_id AS ingredient_id
FROM pizza_toppings AS p
JOIN seperated_list AS s
ON s.topping_id = p.topping_id
JOIN pizza_names AS pn
ON s.pizza_id = pn.pizza_id
ORDER BY 1, 3;

```

#### Solution:


![Screenshot 2023-09-01 at 6 50 11 PM](https://github.com/alizay1/8-Week-SQL-Challenge/assets/101383537/bf7c2e34-1faa-4ed3-b512-d8163492c217)



***




### Question 2: What was the most commonly added extra?



#### Approach:

1. Following a similar approach to the previous question, 
   use **UNNEST(STRING_TO_ARRAY(extras, ','))** since some of the
   extras are listed out in one row. In addition, **CAST** it as an integer data type.

2. Next, select **COUNT(*)** then **GROUP BY**
   **CAST(UNNEST(STRING_TO_ARRAY(extras, ',')) AS integer)**.

3. Filter the results where `extras` does not equal *'no extras'*.

4. Put the resulting query in a common table expression called
   `common_extra`.

  
5. In the outer query, **INNER JOIN** the `pizza_toppings` and `common_extra` tables.

6. Select all the necessary columns, **ORDER BY** `extras_count` in descending order
   from the `common_extra` table, then use **LIMIT** to get the most commonly added
   extra.


```sql

WITH common_extra AS (

SELECT CAST(UNNEST(STRING_TO_ARRAY(extras, ',')) AS integer) AS extras,
       COUNT(*) AS extras_count
FROM customer_orders_temp
WHERE extras != 'no extras'
GROUP BY 1


)


SELECT p.topping_name AS ingredients,
       c.extras AS topping_id,
       c.extras_count
FROM pizza_toppings AS p
JOIN common_extra AS c
ON c.extras = p.topping_id
ORDER BY 3 DESC
LIMIT 1;


```

#### Solution:


![Screenshot 2023-09-01 at 6 52 52 PM](https://github.com/alizay1/8-Week-SQL-Challenge/assets/101383537/4971fb40-9ac5-4046-963d-078bd0669839)



#### Interpretation:


The most commonly added extra was bacon.

***



### Question 3: What was the most common exclusion?


#### Approach:


1. Use the same exact approach as the previous question, but this time
   replace `extras` with the `exclusions` column.
 


```sql


WITH common_exclusions AS (

SELECT CAST(UNNEST(STRING_TO_ARRAY(exclusions, ',')) AS integer) AS exclusions,
       COUNT(*) AS exclusions_count
FROM customer_orders_temp
WHERE exclusions != 'no exclusions'
GROUP BY 1


)



SELECT p.topping_name AS ingredients,
       c.exclusions AS topping_id,
       c.exclusions_count
FROM pizza_toppings AS p
JOIN common_exclusions AS c
ON c.exclusions = p.topping_id
ORDER BY 3 DESC
LIMIT 1;

```

#### Solution:


![Screenshot 2023-09-01 at 6 58 41 PM](https://github.com/alizay1/8-Week-SQL-Challenge/assets/101383537/149a5db7-5e3d-4dcd-9680-8d26026e1eb7)



#### Interpretation:


The most common exclusion was cheese.

***




## D. Pricing and Ratings


### Question 1: If a Meat Lovers pizza costs $12 and Vegetarian costs $10 and there were no charges for changes - how much money has Pizza Runner made so far if there are no delivery fees? 


#### Approach:


1. Start by creating a common table expression called `prices`.
   We need to create an additional column that lists out the prices
   corresponding to the pizza type. So within the CTE, use a **CASE 
   WHEN** statement that indicates if the `pizza_id` is 1 (Meatlovers) 
   then write *12* else *10* for 2 (Vegetarian).
   
2. Make sure to perform an **INNER JOIN** between `customer_orders_temp`
   and `runner_orders_temp`. Furthermore, filter where `cancellation` equals
   *'No Cancellation'*.

3. Outside of the CTE, select **SUM(p.pizza_price)** from `prices`
   to see how much money Pizza Runner made.



```sql

WITH prices AS (
 
SELECT c.pizza_id,
       CASE WHEN c.pizza_id = 1 THEN 12
       ELSE 10 END AS pizza_price
FROM customer_orders_temp AS c
JOIN runner_orders_temp AS r
ON r.order_id = c.order_id
WHERE r.cancellation = 'No Cancellation'

)

SELECT SUM(p.pizza_price) AS profit
FROM prices AS p

```

#### Solution:

![Screenshot 2023-09-01 at 7 28 08 PM](https://github.com/alizay1/8-Week-SQL-Challenge/assets/101383537/3bd36b33-28d8-4044-8e03-1d20945ba8c1)



#### Interpretation:

Pizza Runner's profit was 138 dollars.


***




### Question 2: Question 2: What if there was an additional $1 charge for any pizza extras?




#### Approach:

1. Using the same query from the previous question, we now have to differentiate the
   prices by indicating if any extras were made on the pizzas.

```sql

WITH prices AS (
 
SELECT c.pizza_id,
       c.exclusions,
       c.extras,
       CASE WHEN c.pizza_id = 1 AND c.extras = 'no extras' THEN 12
	    WHEN c.pizza_id = 2 AND c.extras = 'no extras' THEN 10
	    WHEN c.pizza_id = 1 AND c.extras = '1' THEN 12 + 1
	    WHEN c.pizza_id = 2 AND c.extras = '1' THEN 10 + 1
	    ELSE 12 + 2 END AS pizza_price
FROM customer_orders_temp AS c
JOIN runner_orders_temp AS r
ON r.order_id = c.order_id
WHERE r.cancellation = 'No Cancellation'

)

SELECT SUM(p.pizza_price) AS profit
FROM prices AS p


```

#### Solution:


![Screenshot 2023-09-01 at 7 31 26 PM](https://github.com/alizay1/8-Week-SQL-Challenge/assets/101383537/85be00f8-d660-4c73-a9f5-df100d640087)




#### Interpretation:

Pizza Runner's profit was 142 dollars.

***



### Question 3: The Pizza Runner team now wants to add an additional ratings system that allows customers to rate their runner, how would you design an additional table for this new dataset - generate a schema for this new table and insert your own datafor ratings for each successful customer order between 1 to 5.


Note: Ratings did not apply to non-delivered orders.


```sql


DROP TABLE IF EXISTS runner_rating;
CREATE TABLE runner_rating (
	order_id INTEGER,
	rating NUMERIC
);

INSERT INTO runner_rating 
	(order_id, rating)
VALUES
	(1, 4),
	(2, 4.5),
	(3, 2),
	(4, 1),
	(5, 4.5),
	(7, 3),
	(8, 3.5),
	(10, 5);


```



![Screenshot 2023-09-01 at 7 34 34 PM](https://github.com/alizay1/8-Week-SQL-Challenge/assets/101383537/64b78757-4165-457c-982a-e758b81a8275)






***



### Question 4: Using your newly generated table - can you join all of the information together to form a table which has the following information for successful deliveries?

**Information to use:**

-`customer_id`

-`order_id`

-`runner_id`

-`rating`

-`order_time`

-`pickup_time`

- Time between order and pickup
- Delivery duration
- Average speed
- Total number of pizzas


#### Approach:


1. Perform an **INNER JOIN** between `customer_orders_temp`, `runner_rating`,
   and `runner_orders_temp`.
  
2. Luckily for us, we already found the difference between the `pickup_time`
   and `order_time`, the average speed in km/hr, and the total number of pizzas in the
   previous sections. Therefore, we can use the same SQL code in this query.
   
3. Select all the requested columns, then **GROUP BY** the columns that do not use 
   aggregations.
   
   
4. **ORDER BY** `customer_id` for better readability.
	


```sql

SELECT c.customer_id,
       c.order_id,
       ro.runner_id,
       r.rating,
       c.order_time,
       ro.pickup_time,
       EXTRACT(MINUTE FROM (ro.pickup_time - c.order_time)) AS time_difference,
       duration_in_min AS delivery_duration,
       ROUND(AVG((ro.distance_in_km) / (CAST(ro.duration_in_min AS numeric)/ 60)), 1) AS avg_speed_in_kmh,
       COUNT(c.order_id) AS total_pizzas
FROM customer_orders_temp AS c
JOIN runner_rating AS r
ON c.order_id = r.order_id
JOIN runner_orders_temp AS ro
ON c.order_id = ro.order_id
GROUP BY 1, 2, 3, 4, 5, 6, 7, 8
ORDER BY 1;

```

#### Solution:


![Screenshot 2023-09-01 at 7 40 35 PM](https://github.com/alizay1/8-Week-SQL-Challenge/assets/101383537/f64a649c-153b-4272-9aa9-805cc2490c8e)




***




### Question 5: If a Meat Lovers pizza was $12 and Vegetarian $10 fixed prices with no cost for extras and each runner is paid $0.30 per kilometre traveled - how much money does Pizza Runner have left over after these deliveries? 


#### Approach:

1. We can use the common table expression from question 1 in this section 
   to help answer this question. Take the same CTE and rename the first table as `cost_table`. 
   
2. Create another table in the common table expression called `pizza_cost`. Here,
   select the `order_id` and  **SUM(pizza_cost)** from `cost_table` then **GROUP BY** `order_id`.
   The reason we are doing this is because even for orders with multiple pizzas, 
   only one runner will deliver the whole order. So, this is another way of removing
   any duplicate `runner_id` by aggregating the `pizza_cost` by `order_id` before we join 
   the table with `runner_orders_temp`.
   

3. Outside of the CTE, select from `pizza_cost` the **SUM(p.pizza_cost1)**, the 
   **SUM(r.distance_in_km * 0.3)** to calculate the cost per km travelled by
   each runner, and **SUM(p.pizza_cost1) - SUM(r.distance_in_km * 0.3)** to
   calculate the profit made.

4. Lastly, **INNER JOIN** the `pizza_cost` table with the `runner_orders_temp` table.

	

```sql

WITH cost_table AS (

SELECT c.order_id,
       c.pizza_id,
       CASE WHEN c.pizza_id = 1 THEN 12
            ELSE 10 END AS pizza_cost
FROM customer_orders_temp AS c
JOIN runner_orders_temp AS r
ON c.order_id = r.order_id
WHERE cancellation = 'No Cancellation'

),

pizza_cost AS (
		
SELECT order_id,
       SUM(pizza_cost) AS pizza_cost1
FROM cost_table
GROUP BY order_id
)

SELECT SUM(p.pizza_cost1) AS total_pizza_cost,
       SUM(r.distance_in_km * 0.3) AS payment_for_distance,
       SUM(p.pizza_cost1) - SUM(r.distance_in_km * 0.3) AS profit
FROM pizza_cost AS p
JOIN runner_orders_temp AS r
ON p.order_id = r.order_id



```

#### Solution:


![Screenshot 2023-09-01 at 7 48 39 PM](https://github.com/alizay1/8-Week-SQL-Challenge/assets/101383537/743a29ec-b8d5-4e99-996c-48d478cc6a5f)



#### Interpretation:

Pizza Runner has $94.44 left over.








