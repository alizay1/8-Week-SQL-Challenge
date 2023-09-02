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
