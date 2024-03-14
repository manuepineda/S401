#Nivel 1

#Ej 1

#creamos la tablas en la que introduciremos los datos

CREATE TABLE IF NOT EXISTS companies (
company_id VARCHAR(50) PRIMARY KEY,
company_name VARCHAR(50),
phone VARCHAR(50),
email VARCHAR(50),
country VARCHAR(50),
website VARCHAR(50)
);


CREATE TABLE IF NOT EXISTS credit_cards(
id VARCHAR(50) PRIMARY KEY,
user_id VARCHAR(50),
Iban VARCHAR(40),
pan VARCHAR(40), 
pin int, 
cvv INT, 
track1 VARCHAR(50),
track2 VARCHAR(50),
expiring_date VARCHAR (20) #usamos varchar para que no de error en el DATE
);

CREATE TABLE IF NOT EXISTS products(
id VARCHAR(50) PRIMARY KEY,
product_name VARCHAR(50),
price VARCHAR(50),
colour VARCHAR(50),
weight VARCHAR(50),
warehouse_id VARCHAR(50)
);


#importaremos las tres tablas de usuarios aqui


CREATE TABLE IF NOT EXISTS users(
id VARCHAR(50),
name VARCHAR(50),
surname VARCHAR(50),
phone VARCHAR(50),
email VARCHAR(50),
birth_date VARCHAR(50),
country VARCHAR(50),
city VARCHAR(50),
postal_code VARCHAR(50),
address VARCHAR(50)
);

CREATE INDEX index_user_id ON users (id);

CREATE TABLE IF NOT EXISTS transactions(
id VARCHAR(50),
card_id VARCHAR(50),
business_id VARCHAR(50),
timestamp VARCHAR(50),
amount VARCHAR(50),
declined VARCHAR(50),
product_ids VARCHAR(50),
user_id VARCHAR(50),
lat VARCHAR(50),
longitude VARCHAR(50),
FOREIGN KEY(card_id) REFERENCES credit_cards (id),
FOREIGN KEY (business_id) REFERENCES companies(company_id),
FOREIGN KEY (product_ids) REFERENCES products(id),  
FOREIGN KEY (user_id) REFERENCES users(id)   
);

SELECT * FROM companies;
SELECT * FROM credit_cards;
SELECT * FROM products;
SELECT * FROM transactions;
SELECT * FROM users;