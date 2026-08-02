create database walmart;
use walmart;
select count(*) as number from walmart;
select*from walmart;
create database walmart;

use walmart;

select * from walmart;

select count(*) from walmart;
select count(total) from walmart;

select * from walmart limit 10;

SELECT 
    payment_method,count(*)
    
FROM
    walmart
GROUP BY payment_method;

SELECT 
    COUNT(DISTINCT branch)
FROM
    walmart;

select max(quantity) from walmart;

select min(quantity) from walmart;

# ----- BUSSINESS PROBLEM ------ #

# 1 FIND THE PAYMENT METHOD AND NUMBER oF TRANSCTIONS ,NUMBER OF QTY SOLD

select * from walmart;

select payment_method ,count(total) as no_payment, sum(quantity) as total_qty_sold from walmart
group by payment_method;

# 2 IDENTIFY THE HIGHEST RATED CATEGORY IN EACH BRANCH ,DISPLAY THE BRANCH,CATEGORY AND AVG RATING
select *
from(
select Branch,category,avg(rating),
rank() over(partition by branch order by avg(rating) desc) as rnk
from walmart
group by  branch,category
) as t
where rnk = 1;

with ranked as 
(select Branch,category,avg(rating),
rank() over(partition by branch order by avg(rating) desc) as rnk
from walmart
group by  branch,category
) 
select * from ranked
where rnk =1;

# 3 IDENTIFY THE BUSIEST DAY FOR EACH BRANCH BASED ON THE NUMBER OF TRANSCTIONS

select* 
from(
SELECT Branch,count(*) as no_of_trans ,
DAYNAME(date) AS day_name,
rank() over(partition by branch order by count(*) )as rnk
from walmart
group by branch ,day_name) as t
where rnk = 1;


# 4 CALCULATE THE TOTAL QUANTITY OF ITEMS SOLD PER PAYMENT METHOD .LIST PAYMENT METHOD AND TOTAL QUANTITY

select sum(quantity) as total_quantity_sold,payment_method
from walmart 
group by payment_method
order by sum(quantity) desc;


# 5 DETERMINE THE AVERAGE,MIN,MAX RATING OF CATEGORY FOR EACH CITY . LIST THE CITY ,(AVERAGE,MIN,MAX RATING) 

SELECT 
    city,
    category,
    ROUND(AVG(rating), 2),
    MIN(rating),
    MAX(rating)
FROM
    walmart
GROUP BY 1 , 2; 


# 6 DETEMINE THE TOTAL PROFIT FOE EACH CATEGORY BY CONSIDERING TOTALPROFIT AS (UNIT_PRICE*QUANTITY*PROFIT_MARFIN).
# LIST CATEGOPRY AND TOTAL_PROFIT FROM HIGHEST TO LOWEST PROFIT.


SELECT 
    category,
    round(sum(total),2) as revenue,
    ROUND(SUM(unit_price * quantity * profit_margin),
            2) AS total_profit
FROM
    walmart
GROUP BY 1
ORDER BY total_profit DESC;


# 7 DETEMINE THE MOST COMMON PAYMENT METHOD FOR EACH BRANCH.
# DISPLAY BRANCH AND THE PREFERRED PAYMENT METHOD

SELECT*FROM WALMART;
with ranked as(
select branch,payment_method ,
count(*) as total_trans,
rank() over(partition by branch order by count(*) desc) as rnk
from walmart
group by 1,2
)
select * from ranked 
where rnk = 1;


# 8 categories sales into 3 group morning evening afternoon . 
# find out which of the shift and no of invoices
select*from walmart;
SELECT branch,
    CASE
        WHEN time >= '06:00:00' AND time < '12:00:00'
            THEN 'Morning'
        WHEN time >= '12:00:00' AND time < '17:00:00'
            THEN 'Afternoon'
        WHEN time >= '17:00:00' AND time < '24:00:00'
            THEN 'Evening'
        ELSE
            'Night'
    END AS shift_name,count(*) as no_of_voices
FROM walmart
group by 1,2 
order by 1,3;

# IDENTIFY 5 BRANCH WITH HIGHEST DECREASE RATIO IN REVENUE.
# C0MPARE TO LAST YEAR *(CURRENT YEAR 2023 AND LAST YEAR 2022)


select *,
YEAR(STR_TO_DATE(date,'%m/%d/%y')) AS year
from walmart;
# 2022 sales
WITH revenue_2022 AS
(
    SELECT
        branch,
        SUM(total) AS revenue
    FROM walmart
    WHERE YEAR(STR_TO_DATE(date,'%m/%d/%y')) = 2022
    GROUP BY branch
),
revenue_2023 AS
(
    SELECT
        branch,
        SUM(total) AS revenue
    FROM walmart
    WHERE YEAR(str_to_date(date,'%m/%d/%y')) = 2023
    GROUP BY branch
)
SELECT pre.branch,
pre.revenue as last_yrs,
cs.revenue as curr_yrs,
 round(((pre.revenue - cs.revenue) / pre.revenue) * 100 ,2)AS decrease_ratio
FROM revenue_2022 AS pre
JOIN revenue_2023 AS cs
ON pre.branch = cs.branch
WHERE pre.revenue > cs.revenue
order by 4 desc
limit 5;
