--create database jar_ba

--use jar_ba

--loading dataset

select * from List_of_Orders
select * from Order_Details
select * from Sales_target

---Part 1
--Merge the List of Orders and Order Details datasets on the basis of Order ID. 
--Calculate the total sales (Amount) for each category across all orders. 

select o.Category ,SUM(Amount) as TotalAmount
from List_of_Orders as l
JOIN Order_Details as o
on l.Order_ID = o.Order_ID
group by o.Category;


--For each category, calculate the average profit per order and total profit margin (profit as a percentage of Amount). 
select o.Category ,round((sum(o.Amount) * 100.0) / (select sum(Amount) from Order_Details), 2) as PercentageContribution
from List_of_Orders as l
JOIN Order_Details as o
on l.Order_ID = o.Order_ID
group by o.Category;

select o.Category ,round(sum(o.Profit) / count(DISTINCT o.Order_ID),2) as AvgProfitPerOrder,
    round((SUM(o.Profit) * 100.0) / SUM(o.Amount),2) AS TotalProfitMarginPercentage
from List_of_Orders as l
JOIN Order_Details as o
on l.Order_ID = o.Order_ID
group by o.Category;

--- Electronics is clearly the best-performing category, bringing in the highest sales and profits, 
----likely because of strong demand and higher-priced items. 
----On the other hand, Furniture is struggling with very low profit margins and earnings per order, 
-----probably due to high costs and pricing challenges.

---Part 2: Target Achievement Analysis

--Using the Sales Target dataset, calculate the percentage change in target sales for the Furniture category month-over-month. 
select * from Sales_target

select 
    datename(month,Month_of_Order_Date) as Month,
    Category,
    Target,
    lag(Target) over (order by Month_of_Order_Date) as Previous_Target,
    round(
        (cast(Target as float) - lag(Target) over (order by Month_of_Order_Date)) 
        / lag(Target) over (order by Month_of_Order_Date) * 100, 2
    ) as Percentage_Change
from 
    Sales_Target
where 
    Category = 'Furniture';


	---Most months show small and steady increases in target sales, which suggests a careful
	---approach to growth. But April shows a sharp drop of -11.86%, which could be a reaction to 
	----low sales expectations or past performance. On the other hand, July and November targets are slightly higher, likely because of seasonal sales boosts.

		---To make targets more realistic, April’s drop should be reviewed and adjusted more smoothly instead of a sudden cut. 
		---Also, using past sales trends and seasonal patterns can help set better targets that match actual performance.

---Part 3: Regional Performance Insights 

--From the List of Orders dataset, identify the top 5 states with the highest order count. For each of these states, calculate the total sales and average profit.

select top 5
    l.State,
    count(distinct l.Order_ID) as OrderCount,
    sum(o.Amount) as TotalSales,
    round(avg(o.Profit), 2) as AvgProfit
from 
    List_of_Orders l
join 
    Order_Details o 
on 
    l.Order_ID = o.Order_ID
group by 
    l.State
order by 
    OrderCount desc;
---Highlight any regional disparities in sales or profitability. Suggest regions or cities that should be prioritized for improvement. 

There’s a clear regional disparity in performance. While Madhya Pradesh and Maharashtra 
are leading in both order count and total sales, their profits are just moderate, showing 
that high sales don’t always mean high profits. On the other hand, Punjab is concerning as 
it shows a negative average profit, meaning sales are happening at a loss. Even Gujarat, with
decent sales, is struggling with very low profits. This highlights that some regions may need 
a review of pricing, cost structures, or discounting strategies to improve profitability.






