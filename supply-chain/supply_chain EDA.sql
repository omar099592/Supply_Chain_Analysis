/* 
Key business insights neede : 

1.	Where are we losing money?
Some orders show negative profit. I want to know which categories, regions, or discount levels are the biggest offenders. Is it a few bad apples or a systemic problem?
2.	Who are our best customers/regions?
Rank regions and segments by profit — not just sales. Sales look good on paper but profit is what pays the bills.
3.	Returns pattern
Is there a category or sub-category with a returns problem? I want to know if it's a product quality issue or something else.
4.	Discount strategy
At what discount level does profit start going negative? I want a data-backed recommendation on a max discount threshold we shouldn't cross.
*/

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Q1 : Which categories contribute the most to losses ?

select category ,
round(sum(profit :: "numeric"),2)as total_loss
from supply_chain 
where profit < 0
group by category
order by total_loss

-- Furniture experienced the highest total loss, followed by Office Supplies and Technology



-- Q2 :  which regions contribute the most to losses ?

select region , round(sum(profit::"numeric") , 2) as total_loss
from supply_chain
where profit < 0
group by region 
order by total_loss

/*
The Central region experienced the highest total losses, followed by the East and South regions.
The West region recorded the lowest total losses among all regions.
*/

-- Q3 :  which discount levels contribute the most to losses ?

select 

case
when (discount <= 0.2) then 'low ( < 20%)'
when (discount <= 0.5 ) then 'med (< 50%)'
else 'high ( > 50%)'
end as discount_level,

count(*) as total_orders ,
count(*) filter ( where profit < 0) as loss_orders,
count(*) filter (where profit < 0) * 100/ count(*) as loss_percentage
from supply_chain
group by discount_level
order by loss_percentage desc

/* 
High discount levels (>50%) are associated with the highest losses,with 100% of orders resulting in negative profit.
Medium discount levels (21%–50%) also show poor performance, with 91% of orders resulting in negative profit.
*/

-- Q4 : Who are our best customers?

select customer_id , customer_name ,
round(sum(profit::"numeric"),2) as total_profit
from supply_chain
group by customer_id , customer_name
order by total_profit desc
limit 5

/*The top five customers who generated the highest profit for the business are:

Tamara Chand
Raymond Buch
Sanjit Chand
Hunter Lopez
Adrian Barton
*/

-- Q5 : waht are our best regions ?

select region , 
round(sum(profit::"numeric"),2) as total_profit
from supply_chain
group by region
order by total_profit desc

/*
The West region generated the highest total profit, followed by the East and South regions.
Meanwhile, the Central region recorded the lowest total profit.
*/ 

-- Q6 : What are our best customer segments ?

select segment , 
round(sum(profit::"numeric"),2) as total_profit
from supply_chain
group by segment
order by total_profit desc

/* Consumer customers were the most profitable customer segment, generating the highest total profit. 
They were followed by Corporate customers,while Home Office customers generated the lowest total profit.
*/


-- Q7: Which product categories have the highest return rates ?

select category,
       count(*) as total_orders,
       count(returned) filter(where returned = 'Yes') as returned_orders,
       round(count(returned) filter(where returned = 'Yes') * 100.0 / count(*), 2) as return_rate
from supply_chain
group by category
order by return_rate desc;

/*
The Technology category recorded the highest return rate at 8.45%, indicating that it may require further
investigation to identify the underlying causes of returns.

*/ 

-- Q8: Which product sub-category have the highest return rates ?

select sub_category,
       count(*) as total_orders,
       count(returned) filter(where returned = 'Yes') as returned_orders,
       round(count(returned) filter(where returned = 'Yes') * 100.0 / count(*), 2) as return_rate
from supply_chain
group by sub_category
order by return_rate desc;

-- The Machines sub-category had the highest return rate, with 11.30% of its orders being returned.


/*
 Q9: Discount strategy , At what discount level does profit start going negative?
I want a data-backed recommendation on a max discount threshold we shouldn't cross.
*/

select discount , 
round(sum(profit::numeric) ) as total_profit,
round(avg(profit::numeric)) as average_order_profit
from supply_chain
group by discount
order by discount ;

/*
Profit starts turning negative at a 30% discount level. Based on the analysis,
discounts should not exceed 20% to maintain profitability.
*/











 
