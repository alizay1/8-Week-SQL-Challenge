# Case Study #2 - Pizza Runner

<img width="683" alt="Screenshot 2023-09-01 at 11 26 41 AM" src="https://github.com/alizay1/8-Week-SQL-Challenge/assets/101383537/ba41c066-fcd0-4406-bc93-e686d6eee6d8">


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
   - [Business Initiatives](#business-initiatives)
2. [Data Cleaning and Transformation](#data-cleaning-and-transformation)
3. [Data Analysis Questions](#data-analysis-questions)
   - [A. Pizza Metrics](#a-pizza-metrics)
   - [B. Runner and Customer Experience](#b-runner-and-customer-experience)
   - [C. Ingredient Optimization](#c-ingredient-optimization)
   - [D. Pricing and Ratings](#d-pricing-and-ratings)

# Introducing the Data



## Entity Relationship Diagram

Looking at the ERD, six tables will be used in the case study; 'runners', 'customer_orders', 'runner_orders', 'pizza_names', 'pizza_recipes', and 
'pizza_toppings'.

<img width="593" alt="Screenshot 2023-09-01 at 1 38 28 PM" src="https://github.com/alizay1/8-Week-SQL-Challenge/assets/101383537/ad160f59-5784-468a-9b0c-ab4f818eeb13">


## Tables


### Table 1: runners

The `runners` table provides the `registration_date` for each new runner.

![Screenshot 2023-09-01 at 1 52 34 PM](https://github.com/alizay1/8-Week-SQL-Challenge/assets/101383537/05998e1e-2cd4-41db-8d65-d3c3d91c4b8c)



### Table 2: customer_orders

The `customer_orders` table includes the `order_id`, the `customer_id`, 
the `pizza_id` representing the type of pizza, the ingredient `exclusions` id, 
the ingredient `extras` id, and the `order_time` with a timestamp.

You will notice problems with the data in the `exclusions` and `extras`
columns. This will be addressed before starting the analysis.

![Screenshot 2023-09-01 at 1 53 58 PM](https://github.com/alizay1/8-Week-SQL-Challenge/assets/101383537/d600c373-afe0-4abf-9433-75e21ed4e5cd)



### Table 3: runner_orders

The `runner_orders` table includes the `order_id`, the `runner_id`, 
the `pickup_time` of when a runner picks up the pizza(s), the `distance`
travelled by the runner in kilometers, the `duration` of the delivery in
minutes, and the `cancellation` of an order or not.

As with the `customer_orders` table, you will notice problems with null values
and blank spaces in most of the columns. In addition,
the `duration` and `distance` columns need to be edited in accordance to their
perceived data type. This will also be addressed before starting the analysis.

![Screenshot 2023-09-01 at 1 55 47 PM](https://github.com/alizay1/8-Week-SQL-Challenge/assets/101383537/6c5211ff-72c1-4afa-97ac-b1f13978a146)



### Table 4: pizza_names

The 'pizza_names' table provides the corresponding `pizza_name` to the `pizza_id`.

![Screenshot 2023-09-01 at 2 01 12 PM](https://github.com/alizay1/8-Week-SQL-Challenge/assets/101383537/d8421307-47c7-4157-b662-d5ffc3ad2285)



### Table 5: pizza_recipes

The `pizza_recipes` table lists out all the appropriate `toppings` (in id format) according to the `pizza_id`.

![Screenshot 2023-09-01 at 2 02 03 PM](https://github.com/alizay1/8-Week-SQL-Challenge/assets/101383537/fc974d34-51a9-4ea0-8aa9-8940dd6746f8)



### Table 6: pizza_toppings

The `pizza_toppings` table provides the `topping_name` corresponding to the `topping_id` from the `pizza_names` table.


![Screenshot 2023-09-01 at 2 03 07 PM](https://github.com/alizay1/8-Week-SQL-Challenge/assets/101383537/69556d8e-c4fe-4d67-b4d6-342e9aed1e1f)


***

## Business Initiatives


### What does Danny want to understand from the data? Furthermore, what does he want us to do with the data?

1.  Explore different pizza metrics.
2.  What are the runner and customer experiences in the restaurant?
3.  Possible ingredient optimizations.
4.  Analyze pricing and ratings.
5.  Perform data cleaning and transformations.



### Why does he need these insights?

1.  Wants to optimize Pizza Runner's operations.
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

![Screenshot 2023-09-01 at 2 31 31 PM](https://github.com/alizay1/8-Week-SQL-Challenge/assets/101383537/46bcba0d-f96e-4a4b-a6ae-26330b1ee4f5)



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


![Screenshot 2023-09-01 at 2 31 31 PM](https://github.com/alizay1/8-Week-SQL-Challenge/assets/101383537/42ac5d03-93d3-4ba7-acc1-d27c0c36f0d6)



8. You will notice that the `pickup_time` data type is character varying, while `distance_in_km`
   and `duration_in_min` are texts. This will obviously be a problem later
   on in the analysis.
   
9. To address this, use **ALTER TABLE** to alter the columns previously mentioned. For
   `pickup_time`, **TIMESTAMP WITHOUT A TIME ZONE** is the most appropriate choice. For 
   `distance_in_km` since some values have decimals, utilize a **NUMERIC** data type. 
   Lastly, for `duration_in_min`, change it to an **INTEGER** data type.



***

# Data Analysis Questions


Note: `customer_orders_temp` and `runner_orders_temp` will be used for the remainder of the analysis.


#### Approach:


```sql


```






***

## A. Pizza Metrics

### Question 1: 


#### Approach:


```sql


```

#### Solution:


#### Interpretation:


***


### Question 2: 


#### Approach:


```sql


```

#### Solution:


#### Interpretation:


***



### Question 3: 


#### Approach:


```sql


```

#### Solution:


#### Interpretation:


***


### Question 4: 


#### Approach:


```sql


```

#### Solution:


#### Interpretation:


***



### Question 5: 


#### Approach:


```sql


```

#### Solution:


#### Interpretation:


***



### Question 6: 


#### Approach:


```sql


```

#### Solution:


#### Interpretation:


***



### Question 7: 


#### Approach:


```sql


```

#### Solution:


#### Interpretation:


***



### Question 8: 


#### Approach:


```sql


```

#### Solution:


#### Interpretation:


***



### Question 9: 


#### Approach:


```sql


```

#### Solution:


#### Interpretation:


***


### Question 10: 


#### Approach:


```sql


```

#### Solution:


#### Interpretation:


***



## B. Runner and Customer Experience


### Question 1: 


#### Approach:


```sql


```

#### Solution:


#### Interpretation:


***



### Question 2: 


#### Approach:


```sql


```

#### Solution:


#### Interpretation:


***



### Question 3: 


#### Approach:


```sql


```

#### Solution:


#### Interpretation:


***


### Question 4: 


#### Approach:


```sql


```

#### Solution:


#### Interpretation:


***


### Question 5: 


#### Approach:


```sql


```

#### Solution:


#### Interpretation:


***


### Question 6: 


#### Approach:


```sql


```

#### Solution:


#### Interpretation:


***


### Question 7: 


#### Approach:


```sql


```

#### Solution:


#### Interpretation:


***




## C. Ingredient Optimization


### Question 1: 


#### Approach:


```sql


```

#### Solution:


#### Interpretation:


***




### Question 2: 


#### Approach:


```sql


```

#### Solution:


#### Interpretation:


***



### Question 3: 


#### Approach:


```sql


```

#### Solution:


#### Interpretation:


***




## D. Pricing and Ratings


### Question 1: 


#### Approach:


```sql


```

#### Solution:


#### Interpretation:


***




### Question 2: 


#### Approach:


```sql


```

#### Solution:


#### Interpretation:


***



### Question 3: 


#### Approach:


```sql


```

#### Solution:


#### Interpretation:


***



### Question 4: 


#### Approach:


```sql


```

#### Solution:


#### Interpretation:


***




### Question 5: 


#### Approach:


```sql


```

#### Solution:


#### Interpretation:









