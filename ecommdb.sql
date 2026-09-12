-- ============================================================
-- Olist E-commerce Dataset — Schema
-- MySQL 8.0+ (required for window functions and CTEs used in queries.sql)
-- Source: https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce
-- ============================================================

create database if not exists ecommerce_db;

USE ecommerce_db;




-- ============================================================
-- Customers
-- ============================================================

create table customers(
	customer_id 	VARCHAR(100) PRIMARY KEY,
    customer_unique_id 		VARCHAR(100) NOT NULL, 
    customer_zip_code_prefix 	integer,
    customer_city	varchar(100),
    customer_state	varchar(5)
);


-- ============================================================
-- Orders
-- ============================================================

create table orders(
	order_id	varchar(100) primary key,
    customer_id		varchar(100) NOT NULL,
    order_status	varchar(20),
    order_purchase_timestamp		DATETIME,
    order_approved_at				datetime,
    order_delivered_carrier_date 	DATETIME,
    order_delivered_customer_date 	DATETIME,
    order_estimated_delivery_date 	DATETIME,
    foreign key (customer_id) references customers(customer_id)
);

-- ============================================================
-- Sellers
-- ============================================================

create table sellers(
	seller_id		varchar(100) primary key,
    seller_zip_code_prefix		integer,
    seller_city		varchar(100),
    seller_state	varchar(5)
);

-- ============================================================
-- Product_category_translation
-- ============================================================

create table product_category_translation (
    product_category_name          VARCHAR(50) PRIMARY KEY,
    product_category_name_english  VARCHAR(50)
);


-- ============================================================
-- Productos
-- ============================================================

create table products(
	product_id		varchar(100) PRIMARY KEY,
    product_category_name		varchar(50),
    product_name_lenght integer,
	product_description_lenght integer,
	product_photos_qty integer,
	product_weight_g integer,
	product_length_cm integer,
    product_height_cm integer,
	product_width_cm integer,
    FOREIGN KEY (product_category_name) references product_category_translation(product_category_name)
);


-- ============================================================
-- Orders_item
-- ============================================================

create table order_items(
	order_id	VARCHAR(100) NOT NULL,
    order_item_id 	integer NOT NULL,
    product_id		varchar(100) NOT NULL,
    seller_id		varchar(100) not null,
    shipping_limit_date		DATETIME,
    price		DECIMAL(10,2),
    freight_value 	decimal(10,2),
    primary key(order_id, order_item_id),
    foreign key(product_id) references products(product_id),
    foreign key(order_id) references orders(order_id),
    foreign key(seller_id) references sellers(seller_id)
);

-- ============================================================
-- Order payments
-- ============================================================
CREATE TABLE order_payments (
    order_id             VARCHAR(100) NOT NULL,
    payment_sequential   INT NOT NULL,
    payment_type         VARCHAR(20),
    payment_installments INT,
    payment_value        DECIMAL(10,2),
    PRIMARY KEY (order_id, payment_sequential),
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

-- ============================================================
-- Order reviews
-- ============================================================

CREATE TABLE order_reviews (
    review_id               VARCHAR(100),
    order_id                VARCHAR(100) NOT NULL,
    review_score            INT,
    review_comment_title    VARCHAR(255),
    review_comment_message  TEXT,
    review_creation_date    DATETIME,
    review_answer_timestamp DATETIME,
     PRIMARY KEY (review_id, order_id),
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);


-- ============================================================
-- Geolocation
-- ============================================================

CREATE TABLE geolocation (
    geolocation_zip_code_prefix INT,
    geolocation_lat             DECIMAL(10,6),
    geolocation_lng             DECIMAL(10,6),
    geolocation_city            VARCHAR(100),
    geolocation_state           VARCHAR(2),
    INDEX idx_geo_zip (geolocation_zip_code_prefix)
);





