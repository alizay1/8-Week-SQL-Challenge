# Case Study #1 - Danny's Diner

<img width="665" alt="Screenshot 2023-08-31 at 12 46 39 PM" src="https://github.com/alizay1/8-Week-SQL-Challenge/assets/101383537/0f186064-c7f0-4459-ba2a-59e16a4a2e45">


# Introduction

Danny seriously loves Japanese food so in the beginning of 2021,
he decides to embark upon a risky venture and opens up a cute little
restaurant that sells his 3 favourite foods:
sushi, curry and ramen.

Danny’s Diner is in need of your assistance to help the restaurant stay afloat -
the restaurant has captured some very basic data from their few months of operation
but have no idea how to use their data to help them run the business.

***

# Table of Contents



***

# Introducing the Data


## Entity Relationship Diagram


Looking at the ERD, three tables will be used in the case study; sales, menu, and members.

<img width="555" alt="Screenshot 2023-08-16 at 1 46 12 PM" src="https://github.com/alizay1/8-Week-SQL-Challenge/assets/101383537/f42f0c6d-a307-4b6c-bfcb-76bfa828afbf">


## Tables


### Table 1: sales

The sales table consists of each `customer_id` purchases along with the `order_date`
of the purchase and the 'product_id' of the menu item that was ordered.

![Screenshot 2023-08-31 at 4 11 51 PM](https://github.com/alizay1/8-Week-SQL-Challenge/assets/101383537/7f468eb1-6800-49dc-bfb7-bac348483b38)

### Table 2: members

The members table provides the `customer_id` and the `join_date` of when
they joined the Danny's Dinner loyalty program. 

![Screenshot 2023-08-31 at 4 15 09 PM](https://github.com/alizay1/8-Week-SQL-Challenge/assets/101383537/20965ee2-302d-45b3-af9e-bbdadb01a550)


### Table 3: menu

The menu table provides the `product_name` and `price` associated with the `product_id`.

![Screenshot 2023-08-31 at 4 17 35 PM](https://github.com/alizay1/8-Week-SQL-Challenge/assets/101383537/5fc05c8b-df50-4a69-8e5c-6e24ee216d44)


*** 

## Business Initiatives

### What does Danny want to understand from the data?

1. Customer's visiting patterns.
2. How much money customers spend in the restaurant.
3. Customer's favorite menu items.

### Why does he need these insights?

1. Whether or not he should expand the customer loyalty program.
2. Develop readable datasets to share with others without having to use SQL.

***

# Data Analysis Questions




### Question 1: What is the total amount each customer spent at the restaurant?

#### Approach:

1. Use **INNER JOIN** to combine the `sales` and `menu` table in order to get the price of the menu
   item that each customer ordered.

2. To help get the total amount, select **SUM(m.price)** then **GROUP BY** the `customer_id`.
   
3. **ORDER BY** the total amount in descending order for better readability.


```sql

SELECT s.customer_id,
       SUM(m.price) AS total_amount
FROM sales AS s
JOIN menu AS m
ON m.product_id = s.product_id
GROUP BY 1
ORDER BY 2 DESC;

```


#### Solution:

![Screenshot 2023-08-31 at 4 30 23 PM](https://github.com/alizay1/8-Week-SQL-Challenge/assets/101383537/42ed8273-b5ba-40d5-843f-9a8a21a8e5e4)



#### Interpretation:

Customer A spent the most at Danny's Diner while Customer C spent the least.


***

### Question 2: How many days has each customer visited the restaurant?


#### Approach:

1. Evaluate the `sales` table containing the `customer_id` and the `order_date` columns.
   
2. Because the customer can order more than one item in a day, order dates can appear more than once.
   We need to remove the duplicates to have unique order dates per customer. To do this,
   use **DISTINCT()**.
   
3. To get the number of days each customer visited the restaurant, use **COUNT(DISTINCT(order_date))** 
   then **GROUP BY** the `customer_id`.
   
4. **ORDER BY** the number of days visited for better readability.


```sql

SELECT customer_id,
       COUNT(DISTINCT(order_date)) AS days_visited
FROM sales
GROUP BY customer_id
ORDER BY 2 DESC;
```

#### Solution:



![Screenshot 2023-08-31 at 4 46 17 PM](https://github.com/alizay1/8-Week-SQL-Challenge/assets/101383537/5baa8150-f4ed-4a80-a48c-9b9d70b59e4c)


#### Interpretation:

Customer B frequented the restaurant the most followed by customer A. Customer C only visited the restaurant twice.

***

### Question 3: What was the first item from the menu purchased by each customer? 


#### Approach:

1. First create a common table expression called `t1` where we **INNER JOIN** the
   `sales` and `menu` table in order to obtain the `product_name`.
	 
2. Within the common table expression, use the window function **DENSE_RANK()** 
   that ranks the `order_date` in ascending order by `customer_id`. **DENSE_RANK()** was chosen 
   because timestamps were not provided with the `order_date`.


3. Create a seperate query that selects the `customer_id`, `order_date`, and `product_name`
   from the CTE, then filters where the `order_date_rank` equals 1. This represents the first menu item
   purchased by the customer.


```sql

WITH t1 AS (

SELECT s.customer_id,
       m.product_name,
       s.order_date,
       DENSE_RANK() OVER (PARTITION BY s.customer_id ORDER BY s.order_date) AS order_date_rank
FROM sales AS s
JOIN menu AS m
ON m.product_id = s.product_id

)


SELECT t1.customer_id,
       t1.order_date,
       t1.product_name
FROM t1
WHERE t1.order_date_rank = 1;

```

#### Solution:

![Screenshot 2023-08-31 at 5 03 00 PM](https://github.com/alizay1/8-Week-SQL-Challenge/assets/101383537/8d64b50b-b3cd-4a79-a25e-f520e559ceb3)


#### Interpretation:


1. Customer A's first order was either curry or sushi. 
2. Customer B's first order was curry.
3. Customer C's first order was ramen.


***

### Question 4: What is the most purchased item on the menu and how many times was it purchased by all customers?



#### Approach:

1. To find the most purchased item on the menu, first create an inline subquery called `most_puchased` that 
   selects the `product_id`, `product_name`, and **COUNT(s.product_id)**. 
   We then **GROUP BY** the `product_id` and `product_name`, **ORDER BY COUNT(s.product_id)**
   in descending order, and then select the first selection using **LIMIT()**.

2.  We only need the product name so select it from the `most_purchased` subquery. 
    The outer query and the subquery is then put within the common table expression `pn`.


3. To see how many times the most purchased item (ramen) was ordered by each customer, 
   first write a query that **INNER JOIN**s the `sales` and `menu` table to get the 
   `customer_id`, `product_name`, and the **COUNT(m.product_name)**. In the same query,
   **GROUP BY** the `customer_id` followed by the `product_name` then filter where the `product_name`
   equals ramen. We do this by utilizing the **HAVING()** clause and creating a
   nested subquery that selects the `product_name` from the CTE `pn`.


```sql


WITH pn AS (

SELECT product_name
FROM   (SELECT s.product_id,
               m.product_name,
               COUNT(s.product_id) AS order_count
        FROM sales AS s
        JOIN menu AS m
        ON m.product_id = s.product_id
        GROUP BY 1, 2
        ORDER BY 3 DESC
        LIMIT 1) AS most_purchased
)


SELECT s.customer_id,
       m.product_name,
       COUNT(m.product_name) AS order_total
FROM sales AS s
JOIN menu AS m
ON m.product_id = s.product_id
GROUP BY 1, 2
HAVING product_name = (SELECT pn.product_name FROM pn)
ORDER BY 3 DESC;


```


#### Solution:

![Screenshot 2023-08-31 at 5 14 07 PM](https://github.com/alizay1/8-Week-SQL-Challenge/assets/101383537/a0689704-d10c-437a-ba05-3ff2d9af3c46)


#### Interpretation:

Customer A and C ordered ramen 3 times, while customer B ordered it twice. This sums up to 8 orders total.


***

### Question 5: Which item was the most popular for each customer?


#### Approach:

1. To find the most popular item ordered by each customer, we first need to find how
   many times each customer ordered each menu item. So, create a common table expression
   where the first table is named `t1`. In the same table, **INNER JOIN** the `sales` and `menu` table
   then select the `customer_id`, `product_name`, and the **COUNT(m.product_name)**.
   Next, **GROUP BY** the `customer_id` followed by the `product_name`.

2. Create a second table in the CTE called `t2` where we select everything from `t1`. Next, use the **DENSE_RANK()** 
   window function to rank the `order_total` in descending order by `customer_id` so that the largest 
   order count is considered first.


3. In the query outside of the CTE, select the `customer_id`, `product_name`,
   and `order_total` from `t2`. Afterwards, filter where `order_total_rank`
   equals 1.  This will give us the menu item that was the most popular choice
   for each customer.


```sql


WITH t1 AS (

SELECT s.customer_id,
       m.product_name,
       COUNT(m.product_name) AS order_total
FROM sales AS s
JOIN menu AS m
ON m.product_id = s.product_id
GROUP BY 1, 2
	
),

t2 AS (
	
SELECT t1.*,
       DENSE_RANK() OVER (PARTITION BY t1.customer_id ORDER BY t1.order_total DESC) AS order_total_rank
FROM t1

)


SELECT t2.customer_id,
       t2.product_name,
       t2.order_total
FROM t2
WHERE t2.order_total_rank = 1;


```

#### Solution:

![Screenshot 2023-08-31 at 5 21 10 PM](https://github.com/alizay1/8-Week-SQL-Challenge/assets/101383537/f8da1f3e-ae3c-43d3-8890-08370fe23492)


#### Interpretation:


Ramen was the most popular item for customer A and C. For customer B, 
all three of the menu items were considered the 
most popular since it was tied at 2 each.


***

### Question 6: Which item was purchased first by the customer after they became a member?




#### Approach:

1. First, create a common table expression aliased as `purchase_after_member`.
   We need the `customer_id`, `order_date`, `product_id`, and the `join_date`
   so **INNER JOIN** the `sales`, `menu`, and `members` tables. Since we need to know what was the first
   item ordered after a customer became a member, only consider records where the order date comes after the join date.
   To do this, filter the results where the `order_date` is greater than the `join_date`. Next, utilize the **DENSE_RANK()**
   window function that ranks the `order_date` in ascending order by `customer_id`. Important to note that from
   the members table provided above, customer C never joined the loyalty program.

2. In the query outside of the CTE, select the `customer_id`,
   `order_date`, and `product_name`. Perform an initial **INNER JOIN**
   with the `sales` and `menu` tables. Afterwards, **INNER JOIN** the results from
   `purchase_after_member` joining on the `customer_id`,
   `product_id`, and `order_date`. Lastly, filter where the `order_date_rank`
   from `purchase_after_member` equals 1.
   This will isolate the results to the first menu item purchased by
   customer A or B after they became a member.


```sql


WITH purchase_after_member AS (
	
SELECT s.customer_id,
       s.product_id,
       s.order_date,
       members.join_date,
       DENSE_RANK() OVER (PARTITION BY s.customer_id ORDER BY s.order_date) AS order_date_rank
FROM sales AS s
JOIN menu AS m
ON m.product_id = s.product_id
JOIN members
ON members.customer_id = s.customer_id
WHERE s.order_date > members.join_date

)


SELECT s.customer_id,
       s.order_date,
       m.product_name
FROM sales AS s
JOIN menu AS m
ON m.product_id = s.product_id
JOIN purchase_after_member as p
ON s.customer_id = p.customer_id AND s.product_id = p.product_id AND s.order_date = p.order_date
WHERE p.order_date_rank = 1;

```



#### Solution:

![Screenshot 2023-08-31 at 6 44 25 PM](https://github.com/alizay1/8-Week-SQL-Challenge/assets/101383537/289297a5-3983-4d87-9e22-53db44a8c3ad)



#### Interpretation:

Customer A's first order after becoming a member was ramen while customer B's was sushi.



***

### Question 7: Which item was purchased just before the customer became a member?


#### Approach:

1. First, create a common table expression aliased as
   `purchase_before_member`. We need the `customer_id`, `product_id`,
   `order_date`, and the `join_date` so **INNER JOIN** the `sales`, `menu`, 
   and `members` tables. Since we need to know what was the first item ordered
   right before a customer became a member, only consider records where the order date
   comes before the join date. To do this, filter the results where the `order_date`
   is less than the `join_date`. Next, utilize the **DENSE_RANK()** window function that ranks the
   `order_date` in descending order by `customer_id`. 


2. In the query outside of the CTE, select the `customer_id`,
   `order_date`, and `product_name`. Perform an initial **INNER JOIN**
   with the `sales` and `menu` tables. Afterwards, **INNER JOIN** the results from
   `purchase_before_member` joining on the `customer_id`, `product_id`,
   and `order_date`. Lastly, filter where the `order_date_rank` from 
   `purchase_before_member` equals 1. This will isolate the results to
   the first menu item purchased by customer A or B right before they
   became a member.



```sql



WITH purchase_before_member AS (

SELECT s.customer_id,
       s.product_id,
       s.order_date,
       members.join_date,
       DENSE_RANK() OVER (PARTITION BY s.customer_id ORDER BY s.order_date DESC) AS order_date_rank
FROM sales AS s
JOIN menu AS m
ON m.product_id = s.product_id
LEFT JOIN members
ON members.customer_id = s.customer_id
WHERE s.order_date < members.join_date

)


SELECT s.customer_id,
       s.order_date,
       m.product_name
FROM sales AS s
JOIN menu AS m
ON m.product_id = s.product_id
JOIN purchase_before_member AS p
ON s.customer_id = p.customer_id AND s.product_id = p.product_id  AND s.order_date = p.order_date
WHERE p.order_date_rank = 1;


```
#### Solution:

![Screenshot 2023-08-31 at 6 51 52 PM](https://github.com/alizay1/8-Week-SQL-Challenge/assets/101383537/a0ac5237-0977-4a28-a781-922d5468b649)


#### Interpretation:


Since a timestamp was not provided in `order_date`, 
Customer A's first order right before becoming a member was either
sushi or curry. For customer B, it was sushi.



***

### Question 8


#### Approach:



#### Solution:



#### Interpretation:




***
### Question 9


#### Approach:



#### Solution:



#### Interpretation:





***
### Question 10


#### Approach:



#### Solution:



#### Interpretation:







***
# Bonus Questions


### Bonus 1: Recreate the following table that includes the `customer_id`, `order_date`, `product_name`, menu item `price`, and a new column called `member`  where the entries are either Y or N.

#### Approach:



#### Solution:








### Bonus 2: Recreate the following table that includes everything from the previous table and the ranking of member only purchases. Non-members should receive null ranking values.


#### Approach:



#### Solution:



#### Interpretation:


