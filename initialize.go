package main

import (
  "database/sql"
  "fmt"
  "log"
  "math/rand"
  "time"
  _ "github.com/lib/pq"
)

func main() {
  // データベースに接続する
  db, err := sql.Open("postgres", "postgres://postgres:Welcome1@104.197.173.10:5432/applepie_store_sales_simulation")
  if err != nil {
    log.Fatal(err)
  }

  // 10000件の販売記録を挿入する
  for i := 0; i < 10000; i++ {
    // ランダムに選んだ店舗、商品、販売個数での販売を記録する
    store_id := rand.Intn(5) + 1
    item_id := rand.Intn(10) + 1
    sales_quantity := rand.Intn(10)
    sales_date := time.Now()

    // 販売記録を挿入する
    stmt, err := db.Prepare("INSERT INTO sales_records (store_id, item_id, sales_quantity, sales_date) VALUES (?, ?, ?, ?)")
    if err != nil {
      log.Fatal(err)
    }
    defer stmt.Close()

    result, err := stmt.Exec(store_id, item_id, sales_quantity, sales_date)
    if err != nil {
      log.Fatal(err)
    }

    rowsAffected, err := result.RowsAffected()
    if err != nil {
      log.Fatal(err)
    }

    fmt.Println("販売記録を挿入しました。件数:", rowsAffected)
  }
}