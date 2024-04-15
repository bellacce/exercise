package main

import (
	"crypto/sha256"
	"encoding/hex"
	"fmt"
	"math/rand"
	"time"
)

// 传入长度为32字节数组
func generateHash(data []byte) [32]byte {
	return sha256.Sum256(data)
}

// 生成随机数
func generateNonce() []byte {
	rand.Seed(time.Now().UnixNano())
	randomNum := rand.Intn(100000)
	//ace 别名
	combinedStr := fmt.Sprintf("%s%d", "ace", randomNum)
	//fmt.Printf("计算得到废弃的hash：%s \n", combinedStr)
	return []byte(combinedStr)
}

// 查看前缀包含字符串
func hasPrefixOfZeros(hash [32]byte, prefixLen int) bool {
	hexHash := fmt.Sprintf("%x", hash)
	return len(hexHash) >= prefixLen && hexHash[:prefixLen] == fmt.Sprintf("%0*d", prefixLen, 0)
}

// 寻找符合类型的hash
func findHashWithZeros(prefixLen int) ([32]byte, int64) {
	startTime := time.Now()
	count := 0

	for {
		data := generateNonce()
		hash := generateHash(data)
		count++

		if hasPrefixOfZeros(hash, prefixLen) {
			elapsedTime := time.Since(startTime).Milliseconds()
			return hash, elapsedTime
		} else {
			fmt.Printf("计算得到废弃的hash：%s \n", hex.EncodeToString(hash[:]))
			break
		}
	}
	str := "Hello, World!"

	return sha256.Sum256([]byte(str)), 23
}

func main() {
	//定义循环次数
	prefixLen := []int{4, 5}

	for _, length := range prefixLen {
		hash, elapsedTime := findHashWithZeros(length)
		hashStr := hex.EncodeToString(hash[:])
		fmt.Printf("计算得到开头包含 %d 个0的hash: %s, 花费时间: %.3fs \n", length, hashStr, float64(elapsedTime)/1000)
	}
}
