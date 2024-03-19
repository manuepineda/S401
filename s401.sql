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

/*
CREATE TABLE IF NOT EXISTS products(
id VARCHAR(50) PRIMARY KEY,
product_name VARCHAR(50),
price VARCHAR(50),
colour VARCHAR(50),
weight VARCHAR(50),
warehouse_id VARCHAR(50)
);
*/

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
SELECT * FROM transactions;
SELECT * FROM users;


SELECT * FROM transactions
where business_id = 'b-2242';

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

#NIVEL 2

SELECT * FROM credit_cards_status;
SELECT * FROM credit_cards;
SELECT * FROM transactions;

#EJ 1

CREATE TABLE credit_cards_status (
    credit_card_id VARCHAR(40),
    iban VARCHAR(40),
    card_status ENUM('active', 'inactive'),
    FOREIGN KEY(credit_card_id) REFERENCES credit_cards (id)
    );
    
    
    
INSERT INTO credit_cards_status (card_status)
SELECT CASE 
         WHEN SUM(CASE WHEN transactions.declined = 'true' THEN 1 ELSE 0 END) = 3 
         THEN 'inactive'
         ELSE 'active'
      END AS card_status
FROM credit_cards
LEFT JOIN (
    SELECT card_id, MAX(declined) AS declined
    FROM (
        SELECT card_id, declined
        FROM transactions
        ORDER BY timestamp DESC
    ) AS recent_transactions
    GROUP BY card_id
    LIMIT 3
) AS transactions ON credit_cards.id = transactions.card_id
GROUP BY credit_cards.id 




