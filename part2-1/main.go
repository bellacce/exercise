package main

import (
	"fmt"
	"net/http"
	"part2-1/pkg"
	"time"
)

func main() {
	//1.生成创世区块
	genesisBlock := pkg.Block{0, time.Now().String(), "Genesis Block", "0", "0000000000000000000000000000000000000000000000000000000000000000", "0", 0, "0"}
	//2.添加矿工开始挖矿 http://localhost:8080/mineBlock?name=jack
	http.HandleFunc("/mineBlock", pkg.HandleMineBlock)
	//3.添加交易 http://localhost:8080/addTransaction?data=hello block
	http.HandleFunc("/addTransaction", pkg.AddTransaction)
	//4.获取所有区块 http://localhost:8080/getAllBlockInfo
	http.HandleFunc("/getAllBlockInfo", pkg.GetAllBlockInfo)

	//添加区块
	pkg.Blockchain = append(pkg.Blockchain, genesisBlock)

	fmt.Println("Starting server on port 8080...")
	http.ListenAndServe(":8080", nil)
}
