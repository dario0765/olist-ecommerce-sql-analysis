# Olist E-commerce SQL Analysis

Business-oriented SQL analysis of the Olist Brazilian E-commerce dataset (~99K orders, 2016-2018), using MySQL to answer concrete business questions about customer value, revenue trends, product performance, and payment behavior.

## Dataset
[Brazilian E-Commerce Public Dataset by Olist](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce) — 9 relational CSV files covering customers, orders, order items, products, payments, reviews, and sellers.

## Tools
MySQL 8.0, MySQL Workbench

## Business Questions & Key Findings

**1. Who are the top 10 customers by total spend?**
The highest-spending customer totaled **R$13,440** in a single order, based in Rio de Janeiro (RJ). Most top-10 customers made only 1 purchase, suggesting Olist's revenue from top spenders comes from high order value rather than repeat purchases.

**2. Which customers are "at risk" (5+ historical orders, inactive 90+ days)?**
Several customers with as many as **9 historical orders** had gone quiet for over 90 days as of their last recorded purchase, a clear re-engagement opportunity for targeted retention campaigns.

**3. How has revenue grown month over month?**
Revenue grew from **R$135 in Sep 2016** to a peak of **R$987,765 in Nov 2017** (+52% month-over-month that month alone), before plateauing around R$800K–950K through mid-2018. The Nov 2017 spike aligns with Black Friday seasonality in Brazil.

**4. What are the top-selling product categories?**
**health_beauty** leads in revenue (R$1,258,681 from 9,670 units), narrowly ahead of **watches_gifts** (R$1,205,005) despite watches_gifts selling fewer units, indicating a higher average price point per item.

**5. What is the top product within each category?**
Findings vary widely by category, e.g., the top health_beauty product alone generated **R$63,885**, while the top product in smaller categories like small_appliances generated closer to R$14,590, highlighting concentration of revenue in a small number of hero products per category.

**6. How does revenue and average ticket size vary by state?**
**São Paulo (SP)** dominates in volume (40,501 orders, R$5.07M revenue) as expected given it's Brazil's largest economic hub, but it does **not** have the highest average ticket, states like **Tocantins (TO)** and **Roraima (RR)** show notably higher average tickets (R$176–R$188) despite far lower order volume, suggesting fewer but higher-value purchases in more remote states.

**7. What payment methods dominate, and how does order value vary by method?**
**Credit card** is used in the large majority of transactions (76,795 uses, R$12.05M total), consistent with expectations for Brazilian e-commerce. **Boleto** (a common Brazilian bank-slip payment method) is a distant second (19,784 uses), while **vouchers** show the lowest average payment value (R$65.70) among methods with meaningful volume.

## Files
- `ecommdb.sql` — table definitions and relationships for the 8 core tables
- `queries.sql` — the 7 business questions, written as commented SQL queries (JOINs, CTEs, window functions)

## Entity Relationship Diagram

![Entity Relationship Diagram](images\ER_diagram.png)

Query Results

Q1 — Top 10 Customers by Total Spend 

![Q1](images\q1_top_customers.png)

Q2 — At-Risk Customers (5+ orders, inactive 90+ days) 

![Q2](images\q2_at_risk_customers.png)

Q3 — Month-over-Month Revenue Growth 

![Q3](images\q3_monthly_revenue_growth.png)

Q4 — Top-Selling Product Categories 

![Q4](images\q4_top_categories.png)

Q5 — Top Product per Category 

![Q5](images\q5_top_product_per_category.png)

Q6 — Revenue and Average Ticket by State 

![Q6](images\q6_revenue_by_state.png)

Q7 — Payment Method Breakdown

![Q7](images\q7_payment_methods.png)




## Notes & Limitations
- Analysis is based on `delivered` orders only, to avoid counting cancelled or pending orders as revenue.
- Customer analysis uses `customer_unique_id` rather than `customer_id`, since Olist generates a new `customer_id` per order, grouping by `customer_id` would undercount repeat customers.
- "At-risk" threshold (90 days, 5+ orders) is a reasonable starting definition, not a validated churn model, a natural next step would be a proper cohort/retention analysis.