package main

import (
	"database/sql"
	"fmt"
	"log"
	"math/rand"
	"time"
	"os"
	_ "github.com/lib/pq"
)

func main() {
  // データベースのIPアドレスを環境変数から取得
  ip := os.Getenv("DATABASE_IP")

  // データベースに接続する
  db, err := sql.Open("postgres", "host=" + ip +
  " user=postgres password=Welcome1 " +
  "dbname=applepie_store_sim")
  if err != nil {
    log.Fatal(err)
  }
  defer db.Close()

  // 1 秒毎にランダムに選んだ店舗、商品、販売個数での販売を記録し、コンソールに出力
  for {
    // 店舗、商品、販売個数をランダムに選ぶ
    store_id := rand.Intn(5) + 1
    product_id := rand.Intn(7) + 1
    quantity := rand.Intn(24) + 1

    // 販売を記録する
	var sales_record_id int
	sql := "INSERT INTO sales_records " +
		"(store_id, item_id, sales_quantity, sales_date, total) " +
		"VALUES ($1, $2, $3, now(), (SELECT item_price * $3 * 1.1 FROM items WHERE item_id=$2)) "+
	    "RETURNING sales_record_id;"
    err = db.QueryRow(sql, store_id, product_id, quantity).Scan(&sales_record_id)
    if err != nil {
      log.Fatal(err)
    }

	// 売上情報をコンソールに出力
	var store_name string
	var item_name string
	var sales_date time.Time
	var total int
	sql = "SELECT s.store_name, i.item_name, r.sales_date, r.total FROM sales_records r "+
	"LEFT OUTER JOIN stores s ON s.store_id=r.store_id "+
	"LEFT OUTER JOIN items i ON i.item_id=r.item_id "+
	"WHERE sales_record_id = $1"
	row := db.QueryRow(sql , sales_record_id)
	err = row.Scan(&store_name, &item_name, &sales_date, &total)
	if err != nil {
		log.Fatal(err)
	}
	fmt.Printf("%s: %s で %s %d 個が %d 円で販売されました。\n", sales_date.Format("2006/1/2 15:04:05"), store_name, item_name, quantity, total)

	// 10秒毎に、各店舗の売上合計をレポートする
	now := time.Now()
	second := now.Second() % 10
	if second == 0 {
		fmt.Printf("%s 時点の集計\n", now.Format("2006/1/2 15:04:05"))

		sql = "SELECT s.store_name, SUM(r.total) FROM sales_records r "+
		"LEFT OUTER JOIN stores s ON s.store_id=r.store_id "+
		"GROUP BY 1"
		rows, err := db.Query(sql)
		if err != nil {
			log.Fatal(err)
		}
		defer rows.Close()
		for rows.Next() {
			err = rows.Scan(&store_name, &total)
			if err != nil {
			  log.Fatal(err)
			}
		
			// コンソールに出力
			fmt.Printf("    %s の売上額: %d 円\n", store_name, total)
		  }
	} 

    // 1 秒待つ
    time.Sleep(1 * time.Second)
  }
}
