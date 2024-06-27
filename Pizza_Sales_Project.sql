

--  "PIZZA SALES PROJECT"

create database Pizzahut;
drop database Pizzahut;

create database pizzahut;
use pizzahut;

show tables;

select*from pizzas;
select*from pizza_types;

-- ANOTHER TWO TABLES HAVE LARGE AMOUNT PF DATA SO TO IMPORT THAT DATA WE HAVE TO CREATE TABLE THEN IMPOT THE DATA

create table orders(
order_id int primary key not null,
order_date date not null,
order_time time not null
);

select*from orders;

create table order_details(
order_detail_id int primary key not null,
order_id int not null,
pizza_id varchar(20) not null,
quantity int not null,
foreign key(order_id) references orders(order_id)
);

desc order_details;
select*from order_details;



-- PROJECT QUESTION

# 1.Retrieve the total number of orders placed.  (21350)
	select count(*) from orders;
    select count(*) as Total_Number_Of_Orders from orders;
    select count(*) "Total_Number_Of_Orders" from orders;
    select count(*) "Total_No_Of_Orders" from orders;

# 2.Calculate the total revenue generated from pizza sales.	(817860.05)	
	select sum(price)  from pizzas;		#1578.3 this is total price
    select sum(price) as Total_Revenue from pizzas;
SELECT 
    SUM(price) 'Total_Revenue_From_Pizza'
FROM
    pizzas;	
    
    # TO CALCULATE TOTAL REVINUE PRICE*QUANTITY USE JOINS
    select pizzas.price*order_details.quantity from pizzas
    inner join order_details
    on pizzas.pizza_id = order_details.pizza_id;
    
	select round(sum(pizzas.price*order_details.quantity),2) as Total_Revenue from pizzas
    inner join order_details
    on pizzas.pizza_id = order_details.pizza_id;
    
    
# 3.Identify the highest-priced pizza.		(35.95)
	select price from pizzas  #"TO SELECT ONLY PRICE COLUMN FROM PIZZAS TABLE"
    order by price;
    
     select price as "Highest_Price_Of_Pizza" from pizzas
	 order by price;
    
    select price from pizzas
    order by price desc;
    
    select price from pizzas
    order by price desc limit 1;
    
    select price as "Highest_Price_Of_Pizza" from pizzas
	order by price DESC
    limit 1;
    
    SELECT 
    pizza_types.name, pizzas.price
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
ORDER BY pizzas.price DESC
LIMIT 1;
    
    
# 4.Identify the most common pizza size ordered.
	
	SELECT 
    pizzas.size,
    COUNT(order_details.order_details_id) AS Order_Count
FROM
    pizzas
        JOIN
    order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY pizzas.size
ORDER BY Order_Count DESC
LIMIT 1;
    
# 5.List the top 5 most ordered pizza types along with their quantities.
	# WE HAVE PIZZA TYPE IN PIZZAS AND QUANTITY IN ORDER DETAILS SO WE HAVE TO MAKE UNION OF THESE TWO TABLES
    
    select pizza_type_id from pizzas group by pizza_type_id;
    
	select pizzas.pizza_type_id, order_details.quantity from pizzas 
    inner join order_details
	on pizzas.pizza_id = order_details.pizza_id;
    
	select pizzas.pizza_type_id, count(order_details.order_details_id) as Total_Orders from pizzas 
    inner join order_details
	on pizzas.pizza_id = order_details.pizza_id
    group by pizzas.pizza_type_id order by Total_Orders desc
    limit 5;
    
    # NOW HERE WE HAVE TO JOIN THREE TABLES "PIZZAS", "PIZZA_TYPE", "ORDER_DETAILS"
    # WE WANT NAME AND QUANTITY
  SELECT 
    pizza_types.name, COUNT(order_details.quantity) AS Quantity
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY pizza_types.name
ORDER BY Quantity DESC
LIMIT 5;
    
    
    
   

    
# 6.Join the necessary tables to find the total quantity of each pizza category ordered.
	select pizza_types.pizza_type_id , category, pizza_id from pizza_types inner join pizzas
    on pizza_types.pizza_type_id = pizzas.pizza_type_id;
    
	select pizza_types.pizza_type_id , category, pizza_id from pizza_types inner join pizzas
    on pizza_types.pizza_type_id = pizzas.pizza_type_id  
    inner join order_details
     on pizzas.pizza_id = order_details.pizza_id;
     
     # HERE WE HAVE TO JOIN THREE TABLES
     select pizza_types.category, count(order_details.order_details_id) as Quantity_Of_Pizza 
     from pizza_types
     join pizzas
     on pizza_types.pizza_type_id = pizzas.pizza_type_id
     join order_details
     on pizzas.pizza_id = order_details.pizza_id
     group by pizza_types.category
     order by Quantity_Of_Pizza
     desc;
    
    
# 7.Determine the distribution of orders by hour of the day.
	select hour(orders.order_time) as Hour, count(orders.order_id) as Orders
    from orders
    group by hour(orders.order_time)
    order by Orders desc;
    
    select hour(order_time) as Hour, count(order_id) as Order_Count
    from orders
    group by hour(order_time); 
    
    
# 8.Join relevant tables to find the category-wise distribution of pizzas.
	select category, count(pizza_type_id) as Count_Of_Pizza
    from pizza_types
    group by category;
    
    
# 9.Group the orders by date and calculate the average number of pizzas ordered per day.		(138.47)
	#HERE WE ARE USING SUB QUERY
	select orders.order_date, sum(order_details.quantity) as Total_Quantity from orders
    join order_details
    on orders.order_id = order_details.order_id
    group by orders.order_date;
    
    select round(avg(Total_Quantity),2) as Avg_Pizza_Order_Per_Day from
    (select orders.order_date, sum(order_details.quantity) as Total_Quantity from orders
    join order_details
    on orders.order_id = order_details.order_id
    group by orders.order_date) as Order_Quantity;
 
    
# 10.Determine the top 3 most ordered pizza types based on revenue.
	select pizza_types.name, 
    sum(order_details.quantity*pizzas.price) as Revenue from pizza_types
    join pizzas
    on pizzas.pizza_type_id = pizza_types.pizza_type_id 
    join order_details
    on  order_details.pizza_id = pizzas.pizza_id
    group by  pizza_types.name
    order by Revenue desc
    limit 3;



# 11.Calculate the percentage contribution of each pizza type to total revenue.
	select pizza_types.name, pizzas.price*order_details.quantity from pizza_types 
    join pizzas
    on pizza_types.pizza_type_id = pizzas.pizza_type_id
    join order_details 
    on pizzas.pizza_id = order_details.pizza_id;
    
    
    select pizza_types.name, (pizzas.price*order_details.quantity) as Quantity
    from pizza_types 
    join pizzas
    on pizza_types.pizza_type_id = pizzas.pizza_type_id
    join order_details 
    on pizzas.pizza_id = order_details.pizza_id;
    
    
    
    select pizza_types.category, round(sum(order_details.quantity * pizzas.price) / 
    (select round(sum(order_details.quantity * pizzas.price),2) as Total_Sale 
    from order_details
    join pizzas
    on pizzas.pizza_id = order_details.pizza_id) *100,2)
    as Revenue
    from pizza_types 
    join pizzas
    on pizza_types.pizza_type_id = pizzas.pizza_type_id
    join order_details 
    on order_details.pizza_id = pizzas.pizza_id
    group by pizza_types.category
    order by Revenue desc;
   


# 12.Analyze the cumulative revenue generated over time.
	select order_date, 
    sum(Revenue) over (order by order_date) as Cum_Revenue
    from
    (select orders.order_date, 
    sum(order_details.quantity * pizzas.price) as Revenue 
    from order_details join pizzas
    on order_details.pizza_id = pizzas.pizza_id
    join orders
    on orders.order_id = order_details.order_id
    group by orders.order_date) as Sales;
    
    
# 13.Determine the top 3 most ordered pizza types based on revenue for each pizza category.
	select name,Revenue
    from
    (select name, category,Revenue,
    rank() over (partition by category order by Revenue desc) as Ranks
    from
    (select pizza_types.category , pizza_types.name,
    sum(order_details.quantity * pizzas.price) as Revenue 
    from pizza_types
    join pizzas
    on pizza_types.pizza_type_id = pizzas.pizza_type_id
    join order_details
    on order_details.pizza_id = pizzas.pizza_id
    group by pizza_types.category,  pizza_types.name) 
    as a) as B
    where Ranks<=3;
    


