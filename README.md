# Ecommerce_Fashion_store_SQL_SCRIPT
This is a project that utilizes SQL statements to analyze data of a fictional Australian fashion ecommerce store. The dataset can be found at https://www.kaggle.com/datasets/ruchi798/shopping-cart-database 
The database consists of 4 tables: 

**Customers**

 Coloumn name   | Description  |
| ------------- | ------------- |
| customer_id | Unique identification attached to each customer |
| customer_name  | The first and last name of each customer |
| gender        | The gender the customer identifies with |
| age           | The age of the customer  |
|home_address| The home address of the customer|
|zip_code| The zip code of the customer| 
|city| The city whereby the customer resides |
|state| The state whereby the customer resides| 
|country| The country where the customer lives| 

**Orders**

 Coloumn name   | Description  |
| ------------- | ------------- |
| order_id | Unique identification attached to each order made  |
| customer  | The unique identification attached to each customer  |
| payment      | The payement received by the customer |
| order_date          | The date in which the order was placed   |
|delivery_date| The date in which the delivery was made to the customer|


**Products**

 Coloumn name   | Description  |
| ------------- | ------------- |
| product_id | Unique identification attached to each product |
| product_type  | The product category a product belongs to: Jacket, shirt, trousers |
| product_name      |The name of the product  |
| size         | The size of the product XS,S,M,L,XL |
|colour  | The colour of the products|
|price| The price of the product|
|quantity| The product inventory| 
|description| A small description of the product  |

**Products**

 Coloumn name   | Description  |
| ------------- | ------------- |
| product_id | Unique identification attached to each product |
| product_type  | The product category a product belongs to: Jacket, shirt, trousers |
| product_name      |The name of the product  |
| size         | The size of the product XS,S,M,L,XL |
|colour  | The colour of the products|
|price| The price of the product|
|quantity| The product inventory| 
|description| A small description of the product  |

**Sales**

 Coloumn name   | Description  |
| ------------- | ------------- |
| sales_id | Unique identification attached to each sale|
| order_id |Unique identification attached to each order |
| product_id      |Unnique identification attached to each product   |
| price_per_unit      | The price charged for each product |
|quantity  | The quanitity of items sold |
|total_price| Revenue generated from the sale of an item |





![Untitled Diagram drawio](https://github.com/jimmykarago/Ecommerce_Fashion_store_SQL_SCRIPT/assets/84075679/0ae93a03-e9f9-4538-bce9-51004e71ef54)
