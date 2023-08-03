\c applepie_store_sim;
INSERT INTO sales_records (store_id, item_id, sales_quantity, sales_date, total)
WITH T1 AS ( 
    SELECT floor(random()*5)+1 as store_id,
        floor(random()*7)+1 as item_id,
        floor(random()*24)+1 as sales_quantity,
        '2023-01-01'::date + floor(random() * (365))::int as sales_date
    FROM generate_series(1, 50000000)
)
SELECT T1.store_id, T1.item_id, T1.sales_quantity, T1.sales_date,
    items.item_price * sales_quantity * 1.1 as total
FROM T1
LEFT OUTER JOIN items ON T1.item_id=items.item_id;