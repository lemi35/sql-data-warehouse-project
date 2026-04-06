Data Dictionary for Golden Layer
Business-level data representation, structured to support analytics and reports. 
It contains dimention tables and fact tables.

1.gold.dim_customers
Purpose: stores customer details enriched with demographic and geographic data.
Columns:
customer_key	INT 			Unique surrogate key for the customer
customer_id		INT 			Customer identifier from source system
customer_number	NVARCHAR(50) 	Business/customer reference number
first_name		NVARCHAR(50) 	Customer’s first name
last_name		NVARCHAR(50) 	Customer’s last name
country			NVARCHAR(50) 	Customer’s country of residence
marital_status	NVARCHAR(50) 	Customer’s marital status
gender			NVARCHAR(50) 	Customer’s gender
birthdate		NVARCHAR(50) 	Customer’s date of birth
create_date		NVARCHAR(50) 	Date when the customer record was created

2.gold.dim_products
Purpose: stores product details 
Columns:
product_key		INT 			Unique surrogate key for the product
product_id		INT  			Product identifier from source system
product_number	NVARCHAR(50) 	Business/product reference number
product_name	NVARCHAR(50)	Name of the product
category_id		NVARCHAR(50)	Identifier for the product category
category		NVARCHAR(50)	Main product category
subcategory		NVARCHAR(50)	Product subcategory
maintenance		NVARCHAR(50)	Maintenance classification or requirement
cost			INT 			Cost of the product
product_line	NVARCHAR(50)	Product line classification
start_date		DATE			Date when the product became available

3.gold.fact_sales
Purpose: stores sales details
order_number	NVARCHAR(50)	Unique identifier for each order
product_key		INT 			Identifier of the purchased product
customer_key	INT				Unique identifier for the customer
order_date		DATE			Date when the order was placed
shipping_date	DATE			Date when the order was shipped
due_date		DATE			Expected delivery or due date
sales_amount	INT				Total monetary value of the order
quantity		INT				Number of items ordered
price			INT				Price per item
