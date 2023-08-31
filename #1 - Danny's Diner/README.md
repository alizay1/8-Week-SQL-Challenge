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

The sales table consists of each 'customer_id' purchases along with the 'order_date'
of the purchase and the 'product_id' of the menu item that was ordered.

![Screenshot 2023-08-31 at 4 11 51 PM](https://github.com/alizay1/8-Week-SQL-Challenge/assets/101383537/7f468eb1-6800-49dc-bfb7-bac348483b38)

### Table 2: members

The members table provides the 'customer_id' and the 'join_date' of when
they joined the Danny's Dinner loyalty program. 

![Screenshot 2023-08-31 at 4 15 09 PM](https://github.com/alizay1/8-Week-SQL-Challenge/assets/101383537/20965ee2-302d-45b3-af9e-bbdadb01a550)


### Table 3: menu

The menu table provides the 'product_name' and 'price' associated with the 'product_id'.

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

#### Approach

1. Use INNER JOIN to combine the `sales` and `menu` table in order to get the price of the menu
   item that each customer ordered.

2. To help get the total amount, select **SUM(m.price)** then GROUP BY the `customer_id`.
   
3. ORDER BY the total amount in descending order for better readability.


```sql

SELECT s.customer_id,
       SUM(m.price) AS total_amount
FROM sales AS s
JOIN menu AS m
ON m.product_id = s.product_id
GROUP BY 1
ORDER BY 2 DESC;

```


#### Solution

![Screenshot 2023-08-31 at 4 30 23 PM](https://github.com/alizay1/8-Week-SQL-Challenge/assets/101383537/42ed8273-b5ba-40d5-843f-9a8a21a8e5e4)



#### Interpretation

Customer A spent the most at Danny's Diner while Customer C spent the least.


***

### Question 2


#### Approach



#### Solution



#### Interpretation



***

### Question 3


#### Approach



#### Solution



#### Interpretation





***

### Question 4


#### Approach



#### Solution



#### Interpretation




***
### Question 5

#### Approach



#### Solution



#### Interpretation






***
### Question 6


#### Approach



#### Solution



#### Interpretation



***
### Question 7


#### Approach



#### Solution



#### Interpretation




***

### Question 8


#### Approach



#### Solution



#### Interpretation



***
### Question 9


#### Approach



#### Solution



#### Interpretation



***
### Question 10


#### Approach



#### Solution



#### Interpretation





***
# Bonus Questions
