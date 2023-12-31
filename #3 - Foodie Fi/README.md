# Case Study #3 - Foodie-Fi


<img width="663" alt="Screenshot 2023-09-02 at 2 41 31 PM" src="https://github.com/alizay1/8-Week-SQL-Challenge/assets/101383537/b6b13181-6ff7-4448-be62-aa38a128b026">




Link to Case Study: [click me](https://8weeksqlchallenge.com/case-study-3/)

# Introduction

Subscription based businesses are super popular and Danny realised that there was a large gap in the market - he wanted to create a new streaming service that only had food related content - something like Netflix but with only cooking shows!

Danny finds a few smart friends to launch his new startup Foodie-Fi in 2020 and started selling monthly and annual subscriptions, giving their customers unlimited on-demand access to exclusive food videos from around the world!

Danny created Foodie-Fi with a data driven mindset and wanted to ensure all future investment decisions and new features were decided using data. This case study focuses on using subscription style digital data to answer important business questions.


***

# Table of Contents

1. [Introducing the Data](#introducing-the-data)
   - [Entity Relationship Diagram](#entity-relationship-diagram)
   - [Tables](#tables)
   - [Business Objectives](#business-objectives)
3. [Case Study Questions](#case-study-questions)
   - [A. Customer Journey](#a-customer-journey)
   - [B. Data Analysis Questions](#b-data-analysis-questions)

***

# Introducing the Data



## Entity Relationship Diagram


Looking at the ERD, only two tables will be used in the case study; plans and subscriptions.
   
<img width="649" alt="Screenshot 2023-09-02 at 2 42 14 PM" src="https://github.com/alizay1/8-Week-SQL-Challenge/assets/101383537/c9ed7d47-7c40-4c8a-b2f2-aacccc80287a">




## Tables


### Table 1: plans


The `plans` table contains the `plan_id`, the `plan_name`, and the `price`. There are 5 plans in total; trial, basic monthly, pro monthly, pro annual, and churn. The churn plan is when a customer chooses to cancel, but their plan will only terminate at the end of the billing period. Each potential subscriber can start with a 7 day trial period where they will continue with the pro monthly plan afterwards or they can choose a different plan altogether.


![Screenshot 2023-09-02 at 2 45 57 PM](https://github.com/alizay1/8-Week-SQL-Challenge/assets/101383537/27f755a6-bbe9-4290-8d64-dd87f75a8820)



### Table 2: subscriptions

The `subsriptions` table provides the `customer_id`, the `plan_id` listing all the plans they signed up for, and the `start_date` of when the `plan_id` starts.

- Note: The table only displays the first 15 rows.


![Screenshot 2023-09-02 at 2 46 38 PM](https://github.com/alizay1/8-Week-SQL-Challenge/assets/101383537/76a00045-b6f5-4e6b-9957-094878a4b15b)


***

## Business Objectives


### What does Danny want to understand from the data? 

1. The customers' decisions and behaviors regarding the subscription service.



### Why does he need these insights?

1.  If new features are needed in the subscription service.
2.  Whether making future investments is the best decision.


***


# Case Study Questions





## A. Customer Journey

Based off the 8 sample customers provided in the `subscriptions` sample table below, write a brief description about each customer’s onboarding journey.

Try to keep it as short as possible - you may also want to run some sort of join to make your explanations a bit easier!

<img width="268" alt="Screenshot 2023-09-02 at 2 52 20 PM" src="https://github.com/alizay1/8-Week-SQL-Challenge/assets/101383537/47b1cde3-6a5e-4ec3-bf4d-afa7eb438ed6">



#### Approach

1. As suggested, perform an **INNER JOIN** between the `plans` and `subscriptions` tables.

2. Filter the results where the `customer_id` is found in the id numbers 
   *1, 2, 11, 13, 15, 16, 18, or 19*.
   
3. **ORDER BY** the `customer_id` followed by the `plan_id`.



```sql


SELECT *
FROM subscriptions AS s
JOIN plans AS p
ON s.plan_id = p.plan_id
WHERE s.customer_id IN (1, 2, 11, 13, 15, 16, 18, 19)
ORDER BY s.customer_id, s.plan_id;

```



### Customer 1: 

After the 7 day trial period, **customer 1** downgraded to the basic monthly plan
instead of automatically continuing with the pro monthly plan.


*** 

### Customer 2: 

It seems that **customer 2** enjoyed the foodie fi service during the trial period. When it ended, they upgraded to the pro annual plan.

***

### Customer 11:

Unlike **customer 2**, **customer 11** did not like the foodie fi service. They chose to cancel after the trial period.

***

### Customer 13: 

Initially, **customer 13** downgraded to the basic monthly plan after the trial period.
This is probably because of cost or they did not need the benefits provided by the higher
tier plans at the time. However, a few months later, **customer 13** upgraded to a pro monthly plan.


***

### Customer 15: 


After the trial period, **customer 15** made no plan changes so they were automically enrolled in the pro monthly plan. 
However, after a month, they decided to terminate their plan with foodie-fi.


***

### Customer 16: 


Upon completing the trial period on 2020-06-07, **customer 16**
downgraded to the basic monthly plan. To probably take advantage of
more benfits and save money, they later upgraded to the pro annual
plan about five months later.

***

### Customer 18:

After the trial period, **customer 18** made no plan changes. 
They were automically enrolled in the pro monthly plan. 

***

### Customer 19: 


**Customer 19** automically continued with the pro monthly plan after
the trial period ended on 2020-06-29. Two months later, they upgraded
to the pro annual plan.



***

## B. Data Analysis Questions


### Question 1: How many customers has Foodie-Fi ever had?


#### Approach:

1. To get the number of customers, we first have to use
   **DISTINCT()** to remove duplicates then **COUNT()** to count the
   unique `customer_id`.


```sql

SELECT COUNT(DISTINCT (customer_id)) AS num_of_customers
FROM subscriptions;

```

#### Solution:


![Screenshot 2023-09-02 at 3 07 32 PM](https://github.com/alizay1/8-Week-SQL-Challenge/assets/101383537/06333ebf-cd09-4aa7-9a41-f411b13f0674)




#### Interpretation:

Foodie-Fi has had 1000 customers.

***




### Question 2: What is the monthly distribution of trial plan `start_date` values for our dataset - use the start of the month as the group by value 


#### Approach:


1. First, use **DATE_PART()** to extract the month from `start_date`.

2. Next, utilize **COUNT(plan_id**) then **GROUP BY** the extracted months
   to get the monthly distribution.

3. Make sure to filter the results where the `plan_id` equals 0
   for the trial period plan.


```sql

SELECT DATE_PART('month', start_date) AS month,
       COUNT(customer_id)
FROM subscriptions
WHERE plan_id = 0
GROUP BY 1
ORDER BY 1;

```

#### Solution:


![Screenshot 2023-09-02 at 3 41 53 PM](https://github.com/alizay1/8-Week-SQL-Challenge/assets/101383537/4cad1209-9dea-49e9-9912-008f7796d1b0)



#### Interpretation:

February had the lowest customer subscriptions while March had the highest.

***



### Question 3: What plan `start_date` values occur after the year 2020 for our dataset? Show the breakdown by count of events for each `plan_name`.


#### Approach:

1. Perform an **INNER JOIN** between the `plans` and `subscriptions` tables.

2. Filter the results where the plan `start_date` occurs after '2021-12-31'
   for the trial period plan.

3. Select the `plan_name` then **COUNT(p.plan_name)**. **GROUP BY** the `plan_name`
   then **ORDER BY** the count of the `plan_name`.



```sql

SELECT p.plan_name,
       COUNT(p.plan_name) AS plan_count
FROM subscriptions AS s
JOIN plans AS p
ON s.plan_id = p.plan_id
WHERE start_date > '2020-12-31'
GROUP BY 1
ORDER BY 2;

```

#### Solution:


![Screenshot 2023-09-02 at 3 46 23 PM](https://github.com/alizay1/8-Week-SQL-Challenge/assets/101383537/6f1602a7-2801-4f99-95c7-edf1ca69b601)



#### Interpretation:


After 2020, most of the customers either signed up for the pro monthly or pro annual plan. Unfortunately, the highest amount of the customers decided to cancel altogether.

***




### Question 4: What is the customer count and percentage of customers who have churned rounded to 1 decimal place?


#### Approach:


1. To get the customer count and percentage of customers that have churned, we have
   to create two seperate tables within a common table expression. The first 
   table called `customer_churn_count` uses **COUNT(DISTINCT(s.customer_id))** that counts the
   unique `customer_id` where the `plan_name` equals `churn`.
   
   
   
2.  In the second table called `customer_total_count`, we are simply
    counting the total number of unique `customer_id`.

    

3. In the outer query, divide the `churn_count` from `customer_churn_count` by the 
   `total_count` from `customer_total_count`, multiply by 100, then round to 1 decimal place.
   Make sure to use **CAST** to change the data type of the columns to numeric.


```sql


WITH customer_churn_count AS (

SELECT COUNT(DISTINCT(s.customer_id)) AS churn_count
FROM subscriptions AS s
JOIN plans AS p
ON s.plan_id = p.plan_id
WHERE p.plan_name = 'churn'

),
	

customer_total_count AS (


SELECT COUNT(DISTINCT(customer_id)) AS total_count
FROM subscriptions

)


SELECT c1.churn_count,
       ROUND(CAST(c1.churn_count AS numeric)/
       CAST(c2.total_count AS numeric) * 100, 1) AS churn_rate
FROM customer_churn_count AS c1,
     customer_total_count AS c2


```



#### Solution:


![Screenshot 2023-09-02 at 3 52 41 PM](https://github.com/alizay1/8-Week-SQL-Challenge/assets/101383537/7e9d4eb4-60ba-430b-851e-05e2afc4b013)



#### Interpretation:

The number of customers that churned was 307, and the percentage was 30.7%.

***



### Question 5: How many customers have churned straight after their initial free trial - what percentage is this rounded to the nearest whole number? 


#### Approach:

1. For this question, we have to create four seperate tables within a common
   table expression. In the first table called `ranked_plans`, use **ROW_NUMBER()**
   to provide a row number for each `plan_id` by `customer_id`.

2. In the second table called `rank_one_two`, select everything from `ranked_plans`, but only
   filter where the row number equals 1 or 2. At this point, the results contain the trial
   period plan and the plan that came right after it.

3. In the third table called `churn_count`, we now count the number of customers that
   churned right after the trial period. To do this, select **CAST(COUNT(*) AS numeric)** from
   `rank_one_two` and filter the results where the `plan_id` equals 4. 

4. In the last table called `total_count`, we are simply counting the total number
   of unique customers.

5. In the outer query, divide the churn count from `churn_count` by the 
   total number of unique customers from `total_count`, multiply by 100,
   then round to the nearest whole number. Also, select the churn count seperately
   from `churn_count`.



```sql


WITH ranked_plans AS (
	
SELECT s.customer_id,
       s.plan_id,
       p.plan_name,
       s.start_date,
       ROW_NUMBER() OVER (PARTITION BY s.customer_id ORDER BY s.plan_id) AS row_num
FROM subscriptions AS s
JOIN plans AS p
ON s.plan_id = p.plan_id

),

rank_one_two AS (
   
SELECT *
FROM ranked_plans AS r
WHERE r.row_num = 1 OR r.row_num = 2

),

churn_count AS (


SELECT CAST(COUNT(*) AS numeric) AS churn_num
FROM rank_one_two AS r
WHERE r.plan_id = 4

   
	
),

total_count AS (

SELECT CAST(COUNT(DISTINCT(customer_id)) AS numeric) AS t_count
FROM subscriptions
		
)



SELECT c.churn_num,
       ROUND((c.churn_num/t.t_count) * 100, 0) AS churn_rate
FROM churn_count AS c,
     total_count AS t


```

#### Solution:


![Screenshot 2023-09-02 at 4 05 49 PM](https://github.com/alizay1/8-Week-SQL-Challenge/assets/101383537/26191c05-b610-408b-a985-e63d51b4570c)



#### Interpretation:

92 or 9% of the customers churned right after the trial period.

***



### Question 6: What is the number and percentage of customer plans after their initial free trial?


#### Approach:


1. Start by creating three seperate tables within a common
   table expression. In the first table called `rankings`, use **RANK()**
   to provide the rank of each `plan_id` by `customer_id`.

2. In the second table called `num_plans`, select the `plan_id`, the `plan_name`
   and **CAST(COUNT(*) AS numeric)** from `ranked_plans`, but only
   filter where the plan rank equals 2. **GROUP BY** the `plan_id` followed
   by the `plan_name` for the intended results.


3. Reuse the `total_count` table from the previous question.


4. In the outer query, divide the number of plans from `num_plans` by the 
   total number of unique customers from `total_count`, multiply by 100,
   then round to one decimal point. Furthermore, select the `plan_id`, 
   the `plan_name`, and `number_of_plans` from `num_plans`.



```sql


WITH rankings AS (
	
SELECT s.customer_id,
       s.plan_id,
       p.plan_name,
       RANK() OVER (PARTITION BY s.customer_id ORDER BY s.plan_id) As plan_rank
FROM subscriptions AS s
JOIN plans AS p
ON s.plan_id = p.plan_id

),

num_plans AS (


SELECT r.plan_id,
       r.plan_name,
       CAST(COUNT(*) AS numeric) AS number_of_plans
FROM rankings AS r
WHERE r.plan_rank = 2
GROUP BY 1, 2

),


total_count AS (

SELECT CAST(COUNT(DISTINCT(customer_id)) AS numeric) AS t_count
FROM subscriptions
		
)



SELECT n.plan_id,
       n.plan_name,
       n.number_of_plans,
       ROUND((n.number_of_plans/t.t_count) * 100, 1) AS customer_percentage
FROM num_plans AS n,
     total_count AS t
ORDER BY 4 DESC;


```

#### Solution:


![Screenshot 2023-09-02 at 4 10 46 PM](https://github.com/alizay1/8-Week-SQL-Challenge/assets/101383537/58611a19-236e-4248-9229-b4ca9a683699)



#### Interpretation:

Foodie-Fi should focus their attention on increasing the subscription rate for the pro annual plan.


***


### Question 7: What is the customer count and percentage breakdown of all 5 plan_name values at 2020-12-31?


#### Approach:

1. Start by creating three seperate tables within a common
   table expression. In the first table called `filtered_dates`, use RANK()
   to provide the rank of each `start_date` in descending order by `customer_id`.
   Filter the results where the `start_date` is less than or equal to '2020-12-31'.
   

2. In the second table called `c_count`, select the `plan_id`, the `plan_name`,
   and **CAST(COUNT(*) AS numeric)** from `filtered_dates`, but 
   filter the results where the rank equals 1. This represents the latest plan the
   customer was under before the end of '2020-12-31'.
   **GROUP BY** the `plan_id` followed by the `plan_name` to get the customer count.


3. Reuse the `total_count` table from the previous question(s).


4. In the outer query, divide the number of customers from `c_count` by the 
   total number of unique customers from `total_count`, multiply by 100,
   then round to one decimal point. Furthermore, select the `plan_id`, 
   the `plan_name`, and `customer_count` from `c_count`.


```sql

WITH filtered_dates AS (
	
SELECT s.plan_id,
       p.plan_name,
       s.start_date,
       RANK() OVER(PARTITION BY s.customer_id ORDER BY s.start_date DESC) AS most_recent_plan
FROM subscriptions AS s
JOIN plans AS p
ON s.plan_id = p.plan_id
WHERE s.start_date <= '2020-12-31'

),

c_count AS (

SELECT f.plan_id,
       f.plan_name,
       CAST(COUNT(*) AS numeric) AS customer_count
FROM filtered_dates AS f
WHERE f.most_recent_plan = 1
GROUP BY 1, 2

),



total_count AS (

SELECT CAST(COUNT(DISTINCT(customer_id)) AS numeric) AS t_count
FROM subscriptions
		
)

SELECT c.plan_id,
       c.plan_name,
       c.customer_count,
       ROUND((c.customer_count/t.t_count) * 100, 1) AS customer_count_percentage
FROM c_count AS c,
     total_count AS t
ORDER BY 4 DESC;


```

#### Solution:


![Screenshot 2023-09-02 at 4 15 34 PM](https://github.com/alizay1/8-Week-SQL-Challenge/assets/101383537/ffd01a98-a82f-4979-a798-da3a02bb39c4)



#### Interpretation:

More customers are cancelling their subscription than downgrading to a basic monthly plan or saving on monthly costs by selecting the pro
annual plan.


***



### Question 8: How many customers have upgraded to an annual plan in 2020?


#### Approach:

1. Use **COUNT(DISTINCT s.customer_id)** to count the number of 
   unique customers from the subscriptions table. In addition,
   filter the dates for only the year 2020 and where the `plan_id`
   equals 3 for pro annual.


```sql

SELECT COUNT(DISTINCT customer_id) AS number_of_customers
FROM subscriptions
WHERE (start_date > '2019-12-31' AND start_date < '2021-01-01') AND plan_id = 3;

```

#### Solution:


![Screenshot 2023-09-02 at 4 17 51 PM](https://github.com/alizay1/8-Week-SQL-Challenge/assets/101383537/c7760aea-1f62-46d7-a018-2e4a02fd45ae)



#### Interpretation:


In 2020, 195 customers upgraded to the pro annual plan.


***



### Question 9:  How many days on average does it take for a customer to upgrade to an annual plan from the day they join Foodie-Fi?


#### Approach:


1. Start by creating two seperate tables within a common
   table expression. In the first table called `trial_data`,
   select all the necessary columns, but filter results where
   the `plan_id` equals 0 for the trial plan.
   

2. In the second table called `pro_annual_data`, do the same
   thing as the previous step,  but filter results where
   the `plan_id` equals 3 for the pro annual plan.


3. In the outer query, first **JOIN** the `trial_data` and the
   `pro_annual_data` tables. Next, calculate the difference
   between the pro annual `start_date` and the trial period 
   `start_date` to get how many days a customer took to upgrade
   to pro annual. Lastly, use the **AVG()** aggregation to get the 
   intended results.



```sql

WITH trial_data AS (


SELECT s.customer_id,
       s.plan_id,
       p.plan_name,
       s.start_date
FROM subscriptions AS s
JOIN plans AS p
ON s.plan_id = p.plan_id
WHERE s.plan_id = 0

),


pro_annual_data AS (


SELECT s.customer_id,
       s.plan_id,
       p.plan_name,
       s.start_date
FROM subscriptions AS s
JOIN plans AS p
ON s.plan_id = p.plan_id
WHERE s.plan_id = 3

)


SELECT ROUND(AVG(p.start_date - t.start_date)) AS avg_days
FROM trial_data AS t
JOIN pro_annual_data AS p
ON t.customer_id = p.customer_id;



```

#### Solution:


![Screenshot 2023-09-02 at 4 19 57 PM](https://github.com/alizay1/8-Week-SQL-Challenge/assets/101383537/bee45f0a-56e2-484e-bcb1-f8911eb27e36)



#### Interpretation:


It takes customers approximately 105 days on average to upgrade to the pro annual plan
from the day they joined Foodie-Fi.

***




### Question 10: Can you further breakdown this average value into 30 day periods (i.e. 0-30 days, 31-60 days etc)


#### Approach:


1. Use the same exact CTE from the previous question but
   now include an additional table called `buckets`. 
   In this table, utilize **WIDTH_BUCKET()** found [here](https://www.postgresql.org/docs/15/functions-math.html)
   that splits data into buckets based on given criteria.

2. First, **JOIN** `trial_data` and `pro_annual_data`.
   Next, place the difference between the the pro annual
   `start_date` and the trial period `start_date` within 
   **WIDTH_BUCKET()** then split the data into 12 buckets 
   starting at 0 days to the 365th day.


3. In the outer query, create a **CASE WHEN** statement that
   does some string manipulation to rename the buckets accordingly.
   Select the **COUNT(*)** then **GROUP BY** the created buckets to get
   the number of customers in each bucket. 
	   


```sql

WITH trial_data AS (


SELECT s.customer_id,
       s.plan_id,
       p.plan_name,
       s.start_date
FROM subscriptions AS s
JOIN plans AS p
ON s.plan_id = p.plan_id
WHERE s.plan_id = 0

),


pro_annual_data AS (


SELECT s.customer_id,
       s.plan_id,
       p.plan_name,
       s.start_date
FROM subscriptions AS s
JOIN plans AS p
ON s.plan_id = p.plan_id
WHERE s.plan_id = 3

),

buckets AS (

SELECT WIDTH_BUCKET(p.start_date - t.start_date, 0, 365, 12) AS breakdown
FROM trial_data AS t
JOIN pro_annual_data AS p
ON t.customer_id = p.customer_id
)


SELECT CASE WHEN breakdown = 1 THEN CONCAT(((b.breakdown - 1) * 30 ), ' ', '-', ' ', b.breakdown * 30, ' ', 'days')
            ELSE CONCAT(((b.breakdown - 1) * 30) + 1, ' ', '-', ' ', b.breakdown * 30, ' ', 'days')
            END AS thirty_day_periods,
       COUNT(*) 
FROM buckets AS b
GROUP BY 1
ORDER BY 2 DESC;


```

#### Solution:

Note: I was unable to get the buckets to be properly ordered.


![Screenshot 2023-09-02 at 5 31 54 PM](https://github.com/alizay1/8-Week-SQL-Challenge/assets/101383537/2bdd2308-c5fe-4111-a96f-18e4f2f151f3)



***



### Question 11: How many customers downgraded from a pro monthly to a basic monthly plan in 2020?




#### Approach:


1. Use a CTE similar to question 9, but now replace the tables for the basic
   monthly and pro monthly plans. Make sure to filter to only the year 2020
   within both tables.


2. In the outer query, first **JOIN** the `basic_monthly` and the
   `pro_monthly` tables. Next, select the **COUNT(*)**
   to represent the number of customers that downgraded.
   Lastly, filter the results where the difference between 
   the pro monthly `start_date` and the basic monthly `start_date`
   is less than 0.
   



```sql

WITH basic_monthly AS (
	
SELECT s.customer_id,
       s.plan_id,
       p.plan_name,
       s.start_date
FROM subscriptions AS s
JOIN plans AS p
ON s.plan_id = p.plan_id
WHERE (s.start_date > '2019-12-31' AND s.start_date < '2021-01-01') AND s.plan_id = 1
ORDER BY s.customer_id, s.plan_id

),

pro_monthly AS (
		
SELECT s.customer_id,
       s.plan_id,
       p.plan_name,
       s.start_date
FROM subscriptions AS s
JOIN plans AS p
ON s.plan_id = p.plan_id
WHERE (s.start_date > '2019-12-31' AND s.start_date < '2021-01-01') AND s.plan_id = 2
ORDER BY s.customer_id, s.plan_id

)



SELECT COUNT(*) AS num_of_customers
FROM basic_monthly AS b
JOIN pro_monthly AS p
ON b.customer_id = p.customer_id
WHERE p.start_date - b.start_date < 0;


```

#### Solution:


![Screenshot 2023-09-02 at 5 40 54 PM](https://github.com/alizay1/8-Week-SQL-Challenge/assets/101383537/0b6090f8-1288-4cad-8298-b561a3f1d67f)



#### Interpretation:

It seems that none of the customers downgraded from the pro monthly plan to the basic monthly plan.


***
