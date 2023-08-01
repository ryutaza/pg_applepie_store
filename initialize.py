import sqlalchemy
import os

# データベースに接続する
engine = sqlalchemy.create_engine('postgresql://postgres:Welcome1@'+os.environ['CSQL_ADDRESS']+':5432/applepie_store_sales_simulation')

# トランザクションを開始する
cur = conn.cursor()
cur.execute('BEGIN;')

# 10000 件の販売記録を挿入する
for i in range(10000):
  store_id = random.randint(1, 5)
  item_id = random.randint(1, 8)
  sales_quantity = random.randint(1, 24)
  sales_date = datetime.now()
  cur.execute('INSERT INTO sales_records (store_id, item_id, sales_quantity, sales_date) VALUES (%s, %s, %s, %s)', (store_id, item_id, sales_quantity, sales_date))

# トランザクションをコミットする
cur.execute('COMMIT;')

# 接続をクローズする
conn.close()