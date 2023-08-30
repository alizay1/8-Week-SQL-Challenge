--Introduction

/* Danny seriously loves Japanese food so in the beginning of 2021,
he decides to embark upon a risky venture and opens up a cute little
restaurant that sells his 3 favourite foods:
sushi, curry and ramen.

Danny’s Diner is in need of your assistance to help the restaurant stay afloat -
the restaurant has captured some very basic data from their few months of operation
but have no idea how to use their data to help them run the business. */



--What Danny wants to understand from the data.

/* 1.  Customer's visiting patterns.
   2.  How much money they spend in the restaurant 
   3.  Customer's favorite menu items */
   

--Why does he need these insights

/* 1.  Whether or not he should expand the customer loyalty program.
   2.  Develop readable datasets to share with others without having to use SQL */
   
 


--Entity Relationship Diagram

--Screenshot of ERD

/* Looking at the ERD, three tables will be used in the case study; sales, menu, and members.*/



/* The sales table consists of each 'customer_id' purchases along with the 'order_date'
of the purchase and the 'product_id' of the menu item that was ordered. */


SELECT *
FROM sales;



/* The members table provides the 'customer_id' and the 'join_date' of when
they joined the Danny's Dinner loyalty program. */


SELECT *
FROM members;



/* The menu table provides the 'product_name' and 'price' associated with the 'product_id'. */

SELECT *
FROM menu;




--Data Analysis 




--Question 1: What is the total amount each customer spent at the restaurant?

/* Approach: 

	1. Use INNER JOIN to combine the sales and menu table in order to get the price of the menu
	   item that each customer ordered
	2. To help get the total amount, select SUM(m.price) then GROUP BY the 'customer_id'.
	3. ORDER BY the total amount in descending order for better readability

    --Screenshot of the query

*/




SELECT s.customer_id,
       SUM(m.price) AS total_amount
FROM sales AS s
JOIN menu AS m
ON m.product_id = s.product_id
GROUP BY 1
ORDER BY 2 DESC;



/* Solution:

Screenshot

*/



/* Interpretation:

Customer A spent the most at Danny's Diner while Customer C spent the least.

*/







--Question 2: How many days has each customer visited the restaurant?


/* Approach: 

	1. Evaluate the sales table containing the 'customer_id' and the 'order_date' columns.
	2. Because the customer can order more than one item in a day, order dates can appear more than once.
	   We need to remove the duplicates to have unique order dates per customer. To do this,
	   use DISTINCT().
	3. To get the number of days each customer visited the restaurant, use COUNT(DISTINCT(order_date)) 
	   then GROUP BY the 'customer_id'.
	4. ORDER BY the number of days visited for better readability.
	
	--Screenshot of the query
*/





SELECT customer_id,
       COUNT(DISTINCT(order_date)) AS days_visited
FROM sales
GROUP BY customer_id
ORDER BY 2 DESC;



/* Solution:

Screenshot

*/


/* Interpretation:

Customer B frequented the restaurant the most followed by customer A.

*/





--Question 3: What was the first item from the menu purchased by each customer? 



/* Approach: 

	1. First create a common table expression 't1' where we INNER JOIN the
	   sales and menu table in order to obtain the 'product_name'.
	 
	2. Within the common table expression, use the window function DENSE_RANK() 
	   that ranks the 'order_date' in ascending order by 'customer_id'. DENSE_RANK() was chosen 
	   because timestamps were not provided with the 'order_date'.
	
	
	--Screen shot of common table expression query

    --Screenshot of the solution of the CTE

*/	
	
	

/*
	3. We then create a seperate query that selects the 'customer_id', 'order_date', and 'product_name'
	   from the CTE, then filters where the 'order_date_rank' equals 1. This represents the first menu item
	   purchased by the customer.
	   
	   
	   
    --Screenshot of the whole query
*/






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




/* Solution:

Screenshot

*/


/* Interpretation:

1. Customer A's first order was either curry or sushi. 
2. Customer B's first order was curry.
3. Customer C's first order was ramen.

*/




--Question 4: What is the most purchased item on the menu and how many times was it purchased by all customers?



/* Approach: 

	1. To find the most purchased item on the menu, first create a subquery called 'most_puchased' that 
	   selects the 'product_id,' 'product_name,' and COUNT(s.product_id). 
	   We then GROUP BY the 'product_id' and 'product_name', ORDER BY COUNT(s.product_id)
	   in descending order, and then select the first selection using LIMIT().
	  
	  --Screenshot of subquery
	  --Screenshot of result

	
*/
 






/* 
	2.  We only need the product name so select it from the 'most_purchased' subquery. 
	    The outerquery and the subquery is then put within the common table expression 't1'.
	
	--Screenshot the common table expression
	--Screenshot of the solution from the CTE
*/




/* 
	3.  To see how many times the most purchased item (ramen) was ordered by each customer, 
	    first write a query that INNER JOINs the sales and menu table to get the 
		'customer_id', 'product_name', and the COUNT(m.product_name). In the same query,
		GROUP BY the 'customer_id' followed by the 'product_name' then filter where the product 
		name equals ramen. We do this by utilizing the HAVING() clause and creating a
		nested subquery that selects the product name from the CTE t1.
	
	--Screeenshot of whole query
*/


WITH t1 AS (

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
HAVING product_name = (SELECT t1.product_name FROM t1)
ORDER BY 3 DESC;




/* Solution:

Screenshot

*/


/* Interpretation:

Customer A and C ordered ramen 3 times, while customer B ordered it twice. This sums up to 8 orders total.

*/




--Question 5: Which item was the most popular for each customer?


/* Approach: 

	1. To find the most popular item ordered by each customer, we first need to find how
	   many times each customer ordered each menu item. So, create a common table expression
	   where the first table is named t1. In the same table, INNER JOIN the sales and menu table
	   then select the 'customer_id', 'product_name', and the COUNT(m.product_name).
	   Next, GROUP BY the 'customer_id' followed by the 'product_name'.
	   
	   --Screenshot of t1 query.
	   
	   --Screenshot of t1 results.

	
*/
 



/*


	2. Create a second table in the CTE where we select everything from t1. Next, use the DENSE_RANK() 
	   window function to rank the 'order_total' in descending order by 'customer_id' so that the largest 
	   order count is considered first.
	   
	   --Screenshot of t2 query.
	   
	   --Screenshot of t2 results.



*/




/* 

	3. In the query outside of the CTE, select the 'customer_id', 'product_name',
	   and 'order_total' from 't2'. Afterwards, filter where 'order_total_rank'
	   equals 1.  This will give us the menu item that was the most popular choice
	   for each customer.


    --Screeenshot of whole query
*/

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



/* Solution:

Screenshot

*/


/* Interpretation:


Ramen was the most popular item for customer A and C. For customer B, 
all three of the nemu items (sushi, curry, ramen) were considered the 
most popular since it was tied at 2 each.

*/





--Question 6: Which item was purchased first by the customer after they became a member?


/* Approach: 

	1. First, create a common table expression with one table aliased as 'purchase_after_member'.
	   We need the 'customer_id', 'order_date', 'product_id', and the 'join_date'
	   so INNER JOIN the sales, menu, and members table. Since we need
	   to know what was the first item ordered after a customer became a member,
	   only consider records where the order date comes after the join date.
	   To do this, filter the results where the 'order_date' is greater than the
	   'join_date'. Next, utilize the DENSE_RANK() window function that ranks the
	   'order_date' in ascending order by 'customer_id'. We can see from the CTE
	   results (and even the members table provided above) that customer C never
	   joined the loyalty program.
	   
	   --Screenshot of purchase_after_member query.
	   
	   --Screenshot of purchase_after_member results.

	
*/



/* 

	2. In the query outside of the CTE, select the 'customer_id',
	   'order_date', and 'product_name'. Perform an initial INNER JOIN
	   with the sales and menu table. Afterwards, INNER JOIN the results from
	   'purchase_after_member'joining on the 'customer_id',
	   'product_id', and 'order_date'. Lastly, filter where the 'order_date_rank'
	   from 'purchase_after_member' equals 1.
	   This will isolate the results to the first menu item purchased by
	   customer A or B after they became a member.


    --Screeenshot of whole query
*/



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

/* Solution:

Screenshot

*/


/* Interpretation:

Customer A's first order after becoming a memeber was ramen while customer B's was sushi.


*/







--Question 7: Which item was purchased just before the customer became a member?





/* Approach: 

	1. First, create a common table expression with one table aliased as
	   'purchase_before_member'. We need the 'customer_id', 'product_id',
	   'order_date', and the 'join_date' so INNER JOIN the sales, menu, 
	   and members table. Since we need to know what was the first item ordered
	   right before a customer became a member, only consider records where the order date
	   comes before the join date. To do this, filter the results where the 'order_date'
	   is less than the 'join_date'. Next, utilize the DENSE_RANK() window function that ranks the
	   'order_date' in descending order by 'customer_id'. 
	   
	   --Screenshot of purchase_before_member query.
	   
	   --Screenshot of purchase_before_member results.

	
*/



/* 

	2. In the query outside of the CTE, select the 'customer_id',
	   'order_date', and 'product_name'. Perform an initial INNER JOIN
	   with the sales and menu table. Afterwards, INNER JOIN the results from
	   'purchase_before_member'joining on the 'customer_id', 'product_id',
	   and 'order_date'. Lastly, filter where the 'order_date_rank' from 
	   'purchase_before_member' equals 1. This will isolate the results to
	   the first menu item purchased by customer A or B right before they
	   became a member.


    --Screeenshot of whole query
*/





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
JOIN purchase_before_member as p
ON s.customer_id = p.customer_id AND s.product_id = p.product_id  AND s.order_date = p.order_date
WHERE p.order_date_rank = 1;




/* Solution:

Screenshot

*/


/* Interpretation:

Since a timestamp was not provided in 'order_date', 
Customer A's first order right before becoming a member was either
sushi or curry. For customer B, it was sushi.


*/





--Question 8: What is the total items and amount spent for each member before they became a member?



/* Approach: 

	1.  For this question, we need the 'customer_id', the 'price' of each menu item,
	    the 'order_date', and the 'join_date' of when the members joined the loyalty program.
		
	2.  Perform an INNER JOIN on the sales, menu, and members tables.
	
	3.  Since we are only interested in the customer records before they became a member,
	    filter the results where the 'order_date' is less than the 'join_date'.
	
	4.  To get the total items and amount spent for each customer, 
	    select the 'customer_id', COUNT(s.customer_id), and SUM(m.price).
		Next, GROUP BY the 'customer_id' which should aggregate the results 
		into the appropriate solution.
		
	5. ORDER BY the 'customer_id' for better readability.
	   
	   
	   --Screenshot of whole query

	
*/





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




/* Solution:

Screenshot

*/


/* Interpretation:

Customer A purchased 3 items for 25 dollars before becoming a member. 
Customer B spent more by buying 3 menu items for 40 dollars.


*/



/* Question 9: If each $1 spent equates to 10 points and sushi has a 2x points multiplier -
how many points would each customer have? */




/* Approach: 

	1.  Create a common table expression with one table called reward_points_table.
	    Within the CTE, perform an INNER JOIN on the sales and menu table.
	
	2.  We need to create a new column that provides the points according to the menu item. To do this,
	    utilize a CASE WHEN statement. When the product name equals sushi, 20 points will be multiplied
		with the price of the menu item. For everything else, only 10 points will be multiplied with the price.
		The new column is called 'reward_points'
	
	 --Screenshot of reward_points_table query
	 
	 --Screenshot of the results
	
	
	3.  To find out how many points each customer have, in the outer query
	    use SUM(r.reward_points) and select the 'customer_id'. GROUP BY the 'customer_id'
		to get the intended results. 
		
	4. ORDER BY the SUM(r.reward_points)
	   
	   
	   --Screenshot of whole query

	
*/







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




/* Solution:

Screenshot

*/


/* Interpretation:

Customer B had the most reward points with 940 points followed by customer A with 860 points.
Customer C only had 360 points.

*/







/* Question 10: In the first week after a customer joins the program 
(including their join date) they earn 2x points on all items,
not just sushi - how many points do customer A and B have at the end of January? */




/* Approach: 

	1.  Create a common table expression with one table called rewards_table.
	    Within the CTE, perform an INNER JOIN on the sales, menu, and members tables since
		columns are needed from each.
	
	2.  We need to create a new column that lists the points according to the 
	    conditions provided in the question. To do this, utilize a CASE WHEN statement. 
	
	3.  All menu items receive the 2x multiplier in the first week after a customer joins
	    the program (including the join date). What we need to do is make sure that the
		records under this condition have an'order_date' that comes after the 'join_date'
		and before 7 days after the 'join_date'. In other words, in the first WHEN statement,
		'order_date' has to be greater than or equal to the 'join_date' and less than or equal
		to the 'join_date' offsetted by 7 days using members.join_date + INTERVAL '7 days'.
	
	4. For items outside of the first week that only receive 10 points, do the opposite 
	   in the next WHEN statement by including records where the 
	   'order_date' is less then the 'join_date' or greater than the 'join_date' offsetted by 7 days using
	   members.join_date + INTERVAL '7 days'. Furthermore, also account for the fact that the menu item 
	   has to be either ramen or curry.
	  
	
	5. For the rest of the records (ie only the sushi menu item), apply the
	   2x rewards multiplier to the price.
	
	
	
	6. Finally, filter the results where the 'order_date' is less than or equal to January 31, 2021
	   since we are only interested in the records that occurred before the end of January.
	 
	 
	 
	 --Screenshot of reward_table query
	 
	 --Screenshot of the results
	
	
	7.  To find out how many points each customer have, in the outer query
	    use SUM(r.reward_points) and select the 'customer_id'. GROUP BY the 'customer_id'
		to get the intended results. 
		
	8. ORDER BY the 'customer_id'
	   
	   
	   --Screenshot of whole query

	
*/





WITH rewards_table AS (
	
	SELECT s.customer_id,
	       s.order_date,
	       m.product_name,
	       m.price,
           members.join_date,
	       CASE WHEN s.order_date >= members.join_date AND s.order_date <= members.join_date + INTERVAL '7 days'
	                 THEN (m.price * (2 * 10))
	            WHEN (s.order_date < members.join_date OR s.order_date > members.join_date + INTERVAL '7 days') AND 
	                 (m.product_name = 'ramen' OR m.product_name = 'curry') THEN (m.price * 10)
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




/* Solution:

Screenshot

*/


/* Interpretation:

Customer A had 1370 points while customer B had 940 points.

*/






/* BONUS QUESTIONS */




/* Bonus 1: Recreate the following table that includes the
  'customer_id', 'order_date', 'product_name', menu item 'price', 
  and a new column called 'member'  where the data is either Y or N.

  -- Screenshot of the table
*/
 
 
 


/* Approach: 

	1. First, INNER JOIN the sales and menu table then LEFT JOIN the members table. 
	   We have to use LEFT JOIN because no data exists for customer C in the members table.
	
	2. To create a new column, use a CASE WHEN statement where the first WHEN statement
	   states that any 'order_date' greater than or equal to the 'join_date' is considered a member.
	   Furthermore, the following WHEN statement indicates that any 'order_date' less than 
	   the 'join_date' is not considered a member
	 
	3. For any other cases, they are not considered members.
	
	4. Lastly, order by 'customer_id' then 'member'.
	   
	   --Screenshot of whole query

	
*/

 
 
 

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



/* Solution:

Screenshot

*/





/* Bonus 1: Recreate the following table that includes everything from the preivous table and 
   the ranking of member only purchases. Non-members should receive null ranking values.

  -- Screenshot of the table
  
*/
 
 
 


/* Approach: 

	1. For this question, utilize the same query from the previous problem.
	   However, this query will now be placed inside a common table expression 
	   with one table labelled as 'initial_query'.
	   
	2. In the outer query, call everything from 'initial_table'. Next, 
	   add a CASE WHEN statement where if customer is a member, apply the
	   DENSE_RANK() window function that provides ranks by 'customer_id' then 
	   'member' and orders by the 'order_date' in ascending order.
	   
	3. For the the non-member customers, use 'null'.
	   
	  
	  --Screenshot of whole query

	
*/



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



/* Solution:

Screenshot

*/

























