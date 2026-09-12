-- ============================================================
-- Olist E-commerce Dataset — Business Questions & Queries
-- MySQL 8.0+ required (window functions, CTEs)
-- ============================================================

USE ecommerce_db;


-- ============================================================
-- Q1. Who are the top 10 customers by total spend?
-- ============================================================

select 
c.customer_unique_id, c.customer_city, c.customer_state,
round(sum(oi.price),2) as total_spent, count(distinct o.order_id) as total_orders
from customers c 
join orders o on c.customer_id = o.customer_id
join order_items oi on o.order_id = oi.order_id 
where o.order_status = 'delivered'
group by c.customer_unique_id, c.customer_city, c.customer_state 
order by total_spent desc limit 10;


-- ============================================================
-- Q2. Which customers appear "at risk"  (5+ historical orders)
-- but no purchase in the last 90 days relative to the dataset's
-- most recent order date
-- ============================================================

with last_order_date as (
    select MAX(order_purchase_timestamp) as max_date
    from orders
),
customer_activity as (
    select
        c.customer_unique_id,
        max(o.order_purchase_timestamp) as last_purchase,
        count(distinct o.order_id) as total_orders
    from customers c
    join orders o on c.customer_id = o.customer_id
    where o.order_status = 'delivered'
    group by c.customer_unique_id
)
select ca.customer_unique_id, ca.last_purchase, ca.total_orders
from customer_activity ca
cross join last_order_date lod
where ca.total_orders >= 5
  and ca.last_purchase < DATE_SUB(lod.max_date, interval 90 day)
order by ca.total_orders desc;

-- ============================================================
-- Q3. Month-over-month revenue growth
-- ============================================================

with monthly_revenue as (
    select DATE_FORMAT(o.order_purchase_timestamp, '%Y-%m-01') as month, ROUND(SUM(oi.price), 2) as revenue
    from orders o
    join order_items oi on o.order_id = oi.order_id
    where o.order_status = 'delivered'
    group by month
)
select month, revenue, lag(revenue) over (order by month) as prev_month_revenue, ROUND((revenue - lag(revenue) over (order by month)) / lag(revenue) over (order by month) * 100, 2 ) as growth_pct
from monthly_revenue
order by month;
 

-- ============================================================
-- Q4. Top-selling product categories (in English)
-- ============================================================
select t.product_category_name_english as category, COUNT(oi.order_item_id) as units_sold, ROUND(SUM(oi.price), 2) as total_revenue
from order_items oi
join products p on oi.product_id = p.product_id
join product_category_translation t on p.product_category_name = t.product_category_name
group by t.product_category_name_english
order by total_revenue desc
limit 15;
 
-- ============================================================
-- Q5. Top product within each category (by revenue)
-- ============================================================

with product_sales as (
    select t.product_category_name_english as category, p.product_id, ROUND(SUM(oi.price), 2) as revenue
    from order_items oi
    join products p on oi.product_id = p.product_id
    join product_category_translation t on p.product_category_name = t.product_category_name
    group by category, p.product_id
),
ranked_products as (
    select category, product_id, revenue, rank() over (partition by category order by revenue desc) as rank_in_category
    from product_sales
)
select category, product_id, revenue
from ranked_products
where rank_in_category = 1
order by revenue desc
limit 15;


-- ============================================================
-- Q6. Revenue and average ticket size by Brazilian state
-- ============================================================

select c.customer_state, COUNT(distinct o.order_id) as total_orders, ROUND(SUM(oi.price), 2) as total_revenue, ROUND(SUM(oi.price) / COUNT(distinct o.order_id), 2) as avg_ticket
from customers c
join orders o on c.customer_id = o.customer_id
join order_items oi on o.order_id = oi.order_id
where o.order_status = 'delivered'
group by c.customer_state
order by total_revenue desc;
 


-- ============================================================
-- Q7. Payment method breakdown: usage and average order value
-- ============================================================
select payment_type, COUNT(*) as times_used, ROUND(avg(payment_value), 2) as avg_payment_value, ROUND(SUM(payment_value), 2) as total_value
from order_payments
group by payment_type
order by total_value desc;







