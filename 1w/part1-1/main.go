package main

import (
	"crypto/sha256"
	"encoding/hex"
	"fmt"
	"math/rand"
	"time"
)

/**
编写程序（编程语言不限）用自己的昵称 + nonce，不断进行 sha256 Hash 运算：
直到满足 4 个 0 开头的哈希值，打印出花费的时间。
再次运算直到满足 5 个 0 开头的哈希值，打印出花费的时间。
*/

// 传入长度为32字节数组
func generateHash(data []byte) [32]byte {
	return sha256.Sum256(data)
}

// 生成随机数
func generateNonce() []byte {
	rand.Seed(time.Now().UnixNano())
	data := make([]byte, 32) // 生成32字节的随机数据
	rand.Read(data)
	//ace 别名
	combinedStr := fmt.Sprintf("%s%d", "ace", data)
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
		}
	}
}

func main() {
	//定义循环次数
	prefixLen := []int{4, 5}

	for _, length := range prefixLen {
		hash, elapsedTime := findHashWithZeros(length)
		hashStr := hex.EncodeToString(hash[:])
		fmt.Printf("pow 计算得到开头包含 %d 个0的hash: %s, 花费时间: %.3fs \n", length, hashStr, float64(elapsedTime)/1000)
	}

}
