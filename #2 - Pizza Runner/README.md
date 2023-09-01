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


```sql


```



***
### Runners Orders Table



#### Approach:


```sql


```


***

# Data Analysis Questions



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









