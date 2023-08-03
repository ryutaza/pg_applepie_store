CREATE DATABASE applepie_store_sim;
\c applepie_store_sim;

CREATE TABLE stores (
  store_id serial PRIMARY KEY,
  store_name varchar(255) NOT NULL,
  store_address varchar(255) NOT NULL
);

CREATE TABLE items (
  item_id serial PRIMARY KEY,
  item_name varchar(255) NOT NULL,
  item_price int NOT NULL
);

CREATE TABLE sales_records (
  sales_record_id serial PRIMARY KEY,
  store_id int NOT NULL,
  item_id int NOT NULL,
  sales_quantity int NOT NULL,
  sales_date timestamp NOT NULL,
  total int NOT NULL
);

INSERT INTO stores (store_name, store_address) VALUES
('三宿店', '〒154-0002 東京都世田谷区下馬1-46-10'),
('青山店', '〒107-0062 東京都港区南青山5-8-9'),
('横浜店', '〒231-0001 神奈川県横浜市中区新港1-1 横浜赤レンガ倉庫2号館1F'),
('銀座店', '〒104-0061 東京都中央区銀座5-2-1 東急プラザ銀座B1F'),
('吉祥寺店', '〒180-8520 東京都武蔵野市吉祥寺本町1-5-1 吉祥寺パルコ 1F');

INSERT INTO items (item_name, item_price) VALUES
('ダッチ グランブル', 550),
('クラシック ラムレーズン', 500),
('フレンチ ダマンド', 750),
('イングランド カスタード', 400),
('ココナッツパイン アップル', 450),
('リコッタチーズとブルーベリーのアップルパイ', 300),
('ヨーグルト アップルパイ', 600);

INSERT INTO sales_records (store_id, item_id, sales_quantity, sales_date, total)
WITH T1 AS ( 
    SELECT floor(random()*5)+1 as store_id,
        floor(random()*7)+1 as item_id,
        floor(random()*24)+1 as sales_quantity,
        '2023-01-01'::date + floor(random() * (365))::int as sales_date
    FROM generate_series(1, 1000)
)
SELECT T1.store_id, T1.item_id, T1.sales_quantity, T1.sales_date,
    items.item_price * sales_quantity * 1.1 as total
FROM T1
LEFT OUTER JOIN items ON T1.item_id=items.item_id;