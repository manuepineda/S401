#Nivel 1

#Ej 1

CREATE DATABASE s401;

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
FOREIGN KEY (business_id) REFERENCES companies (company_id),
FOREIGN KEY (user_id) REFERENCES users (id)
);

SELECT * FROM companies;
SELECT * FROM credit_cards;
SELECT * FROM products;
SELECT * FROM users;
SELECT * FROM transactions;

 
SELECT * FROM transactions
where business_id = 'b-2242';


SELECT * FROM transactions
where business_id = 'b-2222';

#EJ1

SELECT user_id, transaction_count
FROM (
select user_id, COUNT(*) AS transaction_count
    FROM transactions
    GROUP BY user_id
    ) AS user_transactions
    WHERE transaction_count > 30;

#EJ2

SELECT Iban, Avg(amount) AS AVG_AMOUNT
FROM credit_cards
JOIN transactions ON credit_cards.id = transactions.card_id
JOIN companies ON transactions.business_id = companies.company_id
WHERE companies.company_name = 'Donec Ltd'
GROUP BY credit_cards.Iban;

#micas version

SELECT t.business_id, cc.iban, avg(t.amount) AS mitjana_trans
FROM transactions AS t
JOIN credit_cards AS cc
ON t.card_id=cc.id
JOIN companies AS c
ON c.company_id = t.business_id
WHERE company_name LIKE 'Donec Ltd%'
GROUP BY t.business_id, cc.iban;



SELECT * FROM credit_cards_status;
SELECT * FROM credit_cards;
SELECT * FROM transactions;
SELECT * FROM products;
#NIVEL 2
#EJ 1

CREATE TABLE credit_cards_status (
    credit_card_id VARCHAR(40),
    iban VARCHAR(40),
    card_status ENUM('active', 'inactive'),
    FOREIGN KEY(credit_card_id) REFERENCES credit_cards (id)
    );
   
#we use the data import wizard to add card id and iban data

UPDATE credit_cards_status
JOIN (
    SELECT
        credit_card_id,
        CASE
            WHEN RANK() OVER (PARTITION BY card_id ORDER BY timestamp) >= 3 AND SUM(declined) OVER (PARTITION BY card_id) = 3 THEN 'inactive'
            ELSE 'active'
        END AS new_card_status # el case te crea una columna nueva, y este es el nombre que se le pone
    FROM transactions
    JOIN credit_cards ON credit_cards.id = transactions.card_id
    JOIN credit_cards_status ON credit_cards.id = credit_cards_status.credit_card_id
    GROUP BY card_id, timestamp, declined
    ORDER BY card_id, timestamp DESC
) AS temp ON credit_cards_status.credit_card_id = temp.credit_card_id
SET credit_cards_status.card_status = temp.new_card_status;

Select DIStInCT count(credit_card_id) from credit_cards_status
where card_status = 'active';

Select DIStInCT count(credit_card_id) from credit_cards_status
where card_status = 'inactive';

#NIVEL 3

#EJ1

CREATE TABLE IF NOT EXISTS products(
id VARCHAR(50) PRIMARY KEY,
product_name VARCHAR(50),
price VARCHAR(50),
colour VARCHAR(50),
weight VARCHAR(50),
warehouse_id VARCHAR(50)
);

#FOREIGN KEY (product_ids) REFERENCES products (id) I added this line of code to the table transactions
# tambien hay que importar los datos con el wizard a la tabla products


CREATE TABLE IF NOT EXISTS products_transactions(
id VARCHAR(50) PRIMARY KEY,
product_name VARCHAR(50),
price VARCHAR(50),
colour VARCHAR(50),
weight VARCHAR(50),
warehouse_id VARCHAR(50)
);

Select product_name, count(product_ids)
from products
JOIN transactions
ON transactions.product_ids = products.id
group by product_name
order by count(product_ids) DESC;




