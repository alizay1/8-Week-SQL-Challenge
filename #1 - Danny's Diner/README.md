# Case Study #1 - Danny's Diner

<img width="665" alt="Screenshot 2023-08-31 at 12 46 39 PM" src="https://github.com/alizay1/8-Week-SQL-Challenge/assets/101383537/d1d45b5a-c110-4729-98eb-bb3e4df3d9b2">



Link to Case Study: [click me](https://8weeksqlchallenge.com/case-study-1/)

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

1. [Introducing the Data](#introducing-the-data)
   - [Entity Relationship Diagram](#entity-relationship-diagram)
   - [Tables](#tables)
   - [Business Objectives](#business-objectives)
2. [Data Analysis Questions](#data-analysis-questions)
3. [Bonus Questions](#bonus-questions)


***

# Introducing the Data


## Entity Relationship Diagram


Looking at the ERD, three tables will be used in the case study; sales, menu, and members.


<img width="555" alt="Screenshot 2023-08-16 at 1 46 12 PM" src="https://github.com/alizay1/8-Week-SQL-Challenge/assets/101383537/fea0c2ad-dfdb-432c-a0b7-3932de06f95f">



## Tables


### Table 1: sales

The sales table consists of each `customer_id` purchases along with the `order_date`
of the purchase and the 'product_id' of the menu item that was ordered.

![Screenshot 2023-08-31 at 4 11 51 PM](https://github.com/alizay1/8-Week-SQL-Challenge/assets/101383537/6896cc12-e07c-4fad-b457-c162ec5fd7f4)


### Table 2: members

The members table provides the `customer_id` and the `join_date` of when
they joined the Danny's Dinner loyalty program. 

![Screenshot 2023-08-31 at 4 15 09 PM](https://github.com/alizay1/8-Week-SQL-Challenge/assets/101383537/262744ba-6aee-4f26-929b-526061b11a53)


### Table 3: menu

The menu table provides the `product_name` and `price` associated with the `product_id`.


![Screenshot 2023-08-31 at 4 17 35 PM](https://github.com/alizay1/8-Week-SQL-Challenge/assets/101383537/a1089658-b743-43b6-b011-db93a67dfb49)


*** 

## Business Objectives

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

![Screenshot 2023-08-31 at 4 30 23 PM](https://github.com/alizay1/8-Week-SQL-Challenge/assets/101383537/7fdcf0c4-74ba-4214-8f84-f3de485eebb9)


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


![Screenshot 2023-08-31 at 4 46 17 PM](https://github.com/alizay1/8-Week-SQL-Challenge/assets/101383537/3fdd603d-9405-43f4-9df2-861720ba7374)


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


![Screenshot 2023-08-31 at 5 03 00 PM](https://github.com/alizay1/8-Week-SQL-Challenge/assets/101383537/1358c3e3-f938-40f6-925a-3963354d6c96)



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

![Screenshot 2023-08-31 at 5 14 07 PM](https://github.com/alizay1/8-Week-SQL-Challenge/assets/101383537/0925c13e-6b28-4c32-80dc-5d097217a475)



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


![Screenshot 2023-08-31 at 5 21 10 PM](https://github.com/alizay1/8-Week-SQL-Challenge/assets/101383537/0bc234f9-bc93-4b9e-a09a-4581ffa864fa)



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


![Screenshot 2023-08-31 at 6 44 25 PM](https://github.com/alizay1/8-Week-SQL-Challenge/assets/101383537/1fbe6ad4-a164-47dd-afc2-fc3a35dd82f2)



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

![Screenshot 2023-08-31 at 6 51 52 PM](https://github.com/alizay1/8-Week-SQL-Challenge/assets/101383537/21c1b3a3-b9fa-458f-9d15-bbd4890fc8d8)



#### Interpretation:


Since a timestamp was not provided in `order_date`, 
Customer A's first order right before becoming a member was either
sushi or curry. For customer B, it was sushi.



***

### Question 8: What is the total items and amount spent for each member before they became a member?


#### Approach:

1.  For this question, we need the `customer_id`, the `price` of each menu item,
    the `order_date`, and the `join_date` of when the members joined the loyalty program.
	
2.  Perform an **INNER JOIN** on the `sales`, `menu`, and `members` tables.

3.  Since we are only interested in the customer records before they became a member,
    filter the results where the `order_date` is less than the `join_date`.

4.  To get the total items and amount spent for each customer, 
    select the `customer_id`, **COUNT(s.customer_id)**, and **SUM(m.price)**.
    Next, **GROUP BY** the `customer_id` which should aggregate the results 
    into the appropriate solution.
	
5. **ORDER BY** the `customer_id` for better readability.


```sql


SELECT s.customer_id,
       COUNT(s.customer_id) AS total_purchased_items,
       SUM(m.price) AS total_spent
FROM sales AS s
JOIN menu AS m
ON m.product_id = s.product_id
JOIN members
ON members.customer_id = s.customer_id
WHERE s.order_date < members.join_date
GROUP BY 1
ORDER BY 1;

```


#### Solution:

![Screenshot 2023-08-31 at 7 21 18 PM](https://github.com/alizay1/8-Week-SQL-Challenge/assets/101383537/e417af7b-5e9a-46f0-90de-46020a60e068)



#### Interpretation:

1. Customer A purchased 3 items for 25 dollars before becoming a member.
2. Customer B spent more by buying 3 menu items for 40 dollars.


***

### Question 9: If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?


#### Approach:

1.  Create a common table expression called `reward_points_table`.
    Within the CTE, perform an **INNER JOIN** between the `sales` and `menu` tables.

2.  We need to create a new column that provides the points according to the menu item. To do this,
    utilize a **CASE WHEN** statement. When the `product_name` equals sushi, 20 points will be multiplied
    with the price of the menu item. For everything else, only 10 points will be multiplied with the price.
    The new column is then called `reward_points`.

3.  To find out how many points each customer has, in the outer query
    use **SUM(r.reward_points)** and select the `customer_id`. **GROUP BY** the `customer_id`
    to get the intended results. 
	
4. **ORDER BY** the **SUM(r.reward_points)**.



```sql

WITH reward_points_table AS (
	
SELECT s.customer_id,
       CASE WHEN m.product_name = 'sushi' THEN (m.price * (2 * 10))
       ELSE (m.price * 10) END AS reward_points
FROM sales AS s
JOIN menu AS m
ON m.product_id = s.product_id
)


SELECT r.customer_id,
       SUM(r.reward_points) AS total_reward_points
FROM reward_points_table AS r
GROUP BY 1
ORDER BY 2 DESC;



```

#### Solution:

![Screenshot 2023-09-01 at 10 55 17 AM](https://github.com/alizay1/8-Week-SQL-Challenge/assets/101383537/4364f208-85cf-49de-9b05-c7cca9ca49c8)



#### Interpretation:

Customer B had the most reward points with 940 points followed by customer A with 860 points.
Customer C only had 360 points.



***

### Question 10: In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?


#### Approach:


1.  Create a common table expression called `rewards_table`.
    Within the CTE, perform an **INNER JOIN** between the `sales`, `menu`, and `members` tables since
    columns are needed from each.


2.  We need to create a new column that lists the points according to the 
    conditions provided in the question. To do this, utilize a **CASE WHEN** statement. 


3.  All menu items receive the 2x multiplier in the first week after a customer joins
    the program (including the join date). What we need to do is make sure that the
    records under this condition have an `order_date` that comes after the `join_date`
    and before *7 days after* the `join_date`. In other words, in the first **WHEN** statement,
    `order_date` has to be greater than or equal to the `join_date` and less than or equal
    to the `join_date` offsetted by 7 days using **members.join_date + INTERVAL '7 days'**.


4. For items outside of the first week that only receive 10 points, do the opposite 
   in the next **WHEN** statement. Only include records where the 
   `order_date` is less then the `join_date` or greater than the `join_date` offsetted by 7 days using
   **members.join_date + INTERVAL '7 days'**. Furthermore, also account for the fact that the menu item 
   has to be either ramen or curry.
  

5. For the rest of the records (ie. only the sushi menu item), apply the
   2x rewards multiplier to the price.


6. Finally, filter the results where the `order_date` is less than or equal to January 31, 2021
   since we are only interested in the records that occurred before the end of January.
 

7. To find out how many points each customer has, in the outer query
   use **SUM(r.reward_points)** and select the `customer_id`. **GROUP BY** the `customer_id`
   to get the intended results. 

 
8. ORDER BY the `customer_id`.

```sql


WITH rewards_table AS (

SELECT s.customer_id,
       s.order_date,
       m.product_name,
       m.price,
       members.join_date,
       CASE WHEN s.order_date >= members.join_date AND s.order_date <= members.join_date + INTERVAL '7 days'
	         THEN (m.price * (2 * 10))
	    WHEN (s.order_date < members.join_date OR s.order_date > members.join_date + INTERVAL '7 days') AND 
	         (m.product_name = 'ramen' OR m.product_name = 'curry')
                 THEN (m.price * 10)
	    ELSE (m.price * (2 * 10)) END AS reward_points
FROM sales AS s
JOIN menu AS m
ON m.product_id = s.product_id
JOIN members
ON members.customer_id = s.customer_id
WHERE s.order_date <= '2021-01-31'

)

SELECT r.customer_id,
       SUM(r.reward_points) AS total_reward_points
FROM rewards_table AS r
GROUP BY 1
ORDER BY 1


```



#### Solution:


![Screenshot 2023-09-01 at 11 07 34 AM](https://github.com/alizay1/8-Week-SQL-Challenge/assets/101383537/73e2b053-dc20-4be3-8020-5471d5844969)



#### Interpretation:

Customer A had 1370 points while customer B had 940 points.




***
# Bonus Questions


### Bonus 1: Recreate the following table that includes the `customer_id`, `order_date`, `product_name`, menu item `price`, and a new column called `member`  where the entries are either Y or N.

<img width="583" alt="Screenshot 2023-09-01 at 11 08 24 AM" src="https://github.com/alizay1/8-Week-SQL-Challenge/assets/101383537/4ddd2ec4-7c39-407e-86bc-4547300540a1">



#### Approach:


1. First, **INNER JOIN** the `sales` and `menu` tables then **LEFT JOIN** the `members` table. 
   We have to use **LEFT JOIN** because no data exists for customer C in the `members`table.

2. To create a new column, use a **CASE WHEN** statement where the first **WHEN** statement
   states that any `order_date` greater than or equal to the `join_date` is considered a member.
   Furthermore, the following **WHEN** statement indicates that any `order_date` less than 
   the `join_date` is not considered a member. For any other cases, they are not considered members.

3. Lastly, **ORDER BY** `customer_id` then `member`.



```sql


SELECT s.customer_id,
       s.order_date,
       m.product_name,
       m.price,
       CASE WHEN s.order_date >= members.join_date THEN 'Y'
	    WHEN s.order_date < members.join_date THEN 'N'
	    ELSE 'N' END AS member
FROM sales AS s
JOIN menu AS m
ON s.product_id = m.product_id
LEFT JOIN members
ON members.customer_id = s.customer_id
ORDER BY 1, 2



```

#### Solution:

![Screenshot 2023-09-01 at 11 13 46 AM](https://github.com/alizay1/8-Week-SQL-Challenge/assets/101383537/54e5115c-8291-4fd4-8e9f-08b4fa3e2a2d)



***

### Bonus 2: Recreate the following table that includes everything from the previous table and the ranking of member only purchases. Non-members should receive null ranking values.

<img width="677" alt="Screenshot 2023-09-01 at 11 15 06 AM" src="https://github.com/alizay1/8-Week-SQL-Challenge/assets/101383537/c99229e7-4a97-4690-8c0e-256db90961e0">


#### Approach:

1. For this question, utilize the same query from the previous problem.
   However, this query will now be placed inside a common table expression 
   labelled as `initial_query`.
   
2. In the outer query, call everything from `initial_table`. Next, 
   add a **CASE WHEN** statement where if a customer is a member, apply the
   **DENSE_RANK()** window function that provides ranks by `customer_id` then 
   `member` and **ORDER**s **BY** the `order_date` in ascending order.
   
3. For the the non-member customers, use `NULL`.


```sql



WITH initial_query AS (

SELECT s.customer_id,
       s.order_date,
       m.product_name,
       m.price,
       CASE WHEN s.order_date >= members.join_date THEN 'Y'
            WHEN s.order_date < members.join_date THEN 'N'
            ELSE 'N' END AS member
FROM sales AS s
JOIN menu AS m
ON s.product_id = m.product_id
LEFT JOIN members
ON members.customer_id = s.customer_id
ORDER BY 1, 2

)


SELECT *,
       CASE WHEN i.member = 'Y' THEN DENSE_RANK() OVER (PARTITION BY i.customer_id, i.member ORDER BY order_date)
	    ELSE NULL END AS ranking
FROM initial_query AS i; 




```




#### Solution:


![Screenshot 2023-09-01 at 11 20 42 AM](https://github.com/alizay1/8-Week-SQL-Challenge/assets/101383537/a91f5b35-2697-4749-9f04-6bd92ec4921e)




