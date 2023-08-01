CREATE DATABASE applepie_store_sales_simulation;

\c applepie_store_sales_simulation;

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
  sales_date timestamp NOT NULL
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
