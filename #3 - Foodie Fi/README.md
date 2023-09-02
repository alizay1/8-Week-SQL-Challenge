# Case Study #3 - Foodie-Fi


<img width="663" alt="Screenshot 2023-09-02 at 2 41 31 PM" src="https://github.com/alizay1/8-Week-SQL-Challenge/assets/101383537/9406e6d1-0a70-43ae-8e80-d3548a7580a5">



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
   - [Business Initiatives](#business-initiatives)
3. [Case Study Questions](#case-study-questions)
   - [A. Customer Journey](#a-customer-journey)
   - [B. Data Analysis Questions](#b-data-analysis-questions)

***

# Introducing the Data



## Entity Relationship Diagram


Looking at the ERD, only two tables will be used in the case study; plans and subscriptions.
   
<img width="649" alt="Screenshot 2023-09-02 at 2 42 14 PM" src="https://github.com/alizay1/8-Week-SQL-Challenge/assets/101383537/29edda74-ee3e-4c38-aac3-9bc899fa066c">



## Tables


### Table 1: plans


The `plans` table contains the `plan_id`, the `plan_name`, and the `price`. There are 5 plans in total; trial, basic monthly, pro monthly, pro annual, and churn. The churn plan is when a customer chooses to cancel, but their plan will only terminate at the end of the billing period. Each potential subscriber can start with a 7 day trial period where they will continue with the pro monthly plan afterwards or they can choose a different plan altogether.


![Screenshot 2023-09-02 at 2 45 57 PM](https://github.com/alizay1/8-Week-SQL-Challenge/assets/101383537/c96689a6-3909-4fd6-b32c-b88fce5c0a58)



### Table 2: subscriptions

The `subsriptions` table provides the `customer_id`, the `plan_id` listing all the plans they signed up for, and the `start_date` of when the `plan_id` starts.

- Note: The table only displays the first 15 rows.


![Screenshot 2023-09-02 at 2 46 38 PM](https://github.com/alizay1/8-Week-SQL-Challenge/assets/101383537/dda35bfd-432b-4c60-8e8b-b03bf098cff9)


***

## Business Initiatives


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


<img width="268" alt="Screenshot 2023-09-02 at 2 52 20 PM" src="https://github.com/alizay1/8-Week-SQL-Challenge/assets/101383537/89d16dfe-62c8-4ea3-833e-6ec50524b850">


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


![Screenshot 2023-09-02 at 3 07 32 PM](https://github.com/alizay1/8-Week-SQL-Challenge/assets/101383537/ac025f46-313e-4f8a-a8a9-8ebbe86114ff)



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


![Screenshot 2023-09-02 at 3 41 53 PM](https://github.com/alizay1/8-Week-SQL-Challenge/assets/101383537/de884cc5-03b1-4101-a4c2-d3925a09670f)



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

![Screenshot 2023-09-02 at 3 46 23 PM](https://github.com/alizay1/8-Week-SQL-Challenge/assets/101383537/8b296203-2c4c-47b4-b5b5-74470a340e71)



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


![Screenshot 2023-09-02 at 3 52 41 PM](https://github.com/alizay1/8-Week-SQL-Challenge/assets/101383537/7da8880f-b98e-4d42-8b97-8da3eeaa7f72)



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


![Screenshot 2023-09-02 at 4 05 49 PM](https://github.com/alizay1/8-Week-SQL-Challenge/assets/101383537/8db2bc44-d327-4a2c-9646-0755d328cbf9)



#### Interpretation:

92 or 9% of the customers churned right after the trial period.

***



### Question 6: What is the number and percentage of customer plans after their initial free trial?


#### Approach:


1. Start by creating three seperate tables within a common
   table expression. In the first table called 'rankings', use RANK()
   to provide the rank of each 'plan_id' by 'customer_id'.

2. In the second table called 'num_plans', select the 'plan_id, the 'plan_name'
   and CAST(COUNT(*) AS numeric) from 'ranked_plans', but only
   filter where the plan rank equals 2. GROUP BY the 'plan_id' followed
   by the 'plan_name' for the intended results.


3. Reuse the 'total_count' table from the previous question.


4. In the outer query, divide the number of plans from 'num_plans' by the 
   total number of unique customers from 'total_count', multiply by 100,
   then round to one decimal point. Furthermore, select the 'plan_id', 
   the 'plan_name', and 'number_of_plans' from 'num_plans'.



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



### Question 11:


#### Approach:




```sql



```

#### Solution:


#### Interpretation:



***
