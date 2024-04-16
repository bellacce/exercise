package pkg

import (
	"crypto/sha256"
	"encoding/hex"
	"encoding/json"
	"fmt"
	"math/rand"
	"net/http"
	"time"
)

type Block struct {
	Index        int
	Timestamp    string
	Data         string
	PrevHash     string
	Hash         string
	MinerAddress string //矿工
	Reward       int
	Nonce        string
}

var Blockchain []Block

// 公开交易数据，全部矿工获取数据
var transactionData string = ""

func calculateHash(block Block) string {
	record := block.Nonce + string(block.Index) + block.Timestamp + block.Data + block.PrevHash + block.MinerAddress
	h := sha256.New()
	h.Write([]byte(record))
	hashed := h.Sum(nil)
	return hex.EncodeToString(hashed)
}

func generateBlock(prevBlock Block, minerAddress string) Block {
	var newBlock Block

	newBlock.Index = prevBlock.Index + 1
	newBlock.Timestamp = time.Now().String()
	newBlock.PrevHash = prevBlock.Hash
	newBlock.MinerAddress = minerAddress
	newBlock.Reward = 5
	for {
		newBlock.Nonce = generateNonce()
		newBlock.Data = transactionData
		newBlock.Hash = calculateHash(newBlock)
		// 检查是否满足挖矿条件（例如，前缀两个字符为“00”）
		if newBlock.Hash[:5] == "00000" {
			break
		}
		// 模拟挖矿速率
		//time.Sleep(time.Millisecond * time.Duration(1000/m.HashRate))
	}
	return newBlock
}

func isBlockValid(newBlock, prevBlock Block) bool {
	if prevBlock.Index+1 != newBlock.Index {
		return false
	}
	if prevBlock.Hash != newBlock.PrevHash {
		return false
	}
	if calculateHash(newBlock) != newBlock.Hash {
		return false
	}
	return true
}

func HandleMineBlock(w http.ResponseWriter, r *http.Request) {

	prevBlock := Blockchain[len(Blockchain)-1]
	minerName := r.URL.Query().Get("name")
	//工作量证明
	newBlock := generateBlock(prevBlock, minerName)

	if isBlockValid(newBlock, prevBlock) {
		Blockchain = append(Blockchain, newBlock)
		fmt.Println("Block mined successfully!")
		fmt.Println("New Block:", newBlock)
		w.WriteHeader(http.StatusCreated)
		json.NewEncoder(w).Encode(newBlock)
	} else {
		w.WriteHeader(http.StatusBadRequest)
		fmt.Println("Invalid block. Mining failed.")
	}
}

func AddTransaction(w http.ResponseWriter, r *http.Request) {
	transactionData = r.URL.Query().Get("data")
	w.WriteHeader(http.StatusOK)
}
func GetAllBlockInfo(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(Blockchain)
}

// 生成随机数
func generateNonce() string {
	rand.Seed(time.Now().UnixNano())
	data := make([]byte, 32) // 生成32字节的随机数据
	rand.Read(data)
	//ace 别名
	combinedStr := fmt.Sprintf("%s%s", "ace", hex.EncodeToString(data))
	return combinedStr
}
