package main

import (
	"crypto"
	"crypto/rand"
	"crypto/rsa"
	"crypto/sha256"
	"crypto/x509"
	"encoding/hex"
	"encoding/pem"
	"fmt"
	cusRand "math/rand"
	"time"
)

//go语言循环遍历hash，
//直到查到开头包含4个0的hash并打印，再循环遍历hash，直到查到开头5个0的hash

// 传入长度为32字节数组
func generateHash(data []byte) [32]byte {
	return sha256.Sum256(data)
}

// 生成随机数
func generateNonce() []byte {
	cusRand.Seed(time.Now().UnixNano())
	data := make([]byte, 32) // 生成32字节的随机数据
	rand.Read(data)
	//ace 别名
	combinedStr := fmt.Sprintf("%s%d", "ace", data)
	return []byte(combinedStr)
}

func main() {
	// 1.生成RSA密钥对
	privateKey, err := rsa.GenerateKey(rand.Reader, 2048)
	if err != nil {
		fmt.Println("Error generating private key:", err)
		return
	}
	// 将私钥编码为PEM格式
	privateKeyPEM := pem.EncodeToMemory(&pem.Block{
		Type:  "RSA PRIVATE KEY",
		Bytes: x509.MarshalPKCS1PrivateKey(privateKey),
	})

	// 将公钥编码为PEM格式
	publicKey := &privateKey.PublicKey
	publicKeyBytes, err := x509.MarshalPKIXPublicKey(publicKey)
	if err != nil {
		fmt.Println("Error encoding public key:", err)
		return
	}
	publicKeyPEM := pem.EncodeToMemory(&pem.Block{
		Type:  "PUBLIC KEY",
		Bytes: publicKeyBytes,
	})

	// 打印私钥和公钥
	fmt.Printf("公钥：\n%s", string(publicKeyPEM))
	fmt.Printf("私钥：\n%s\n", string(privateKeyPEM))

	data := generateNonce()
	// 生成哈希值
	hash := generateHash(data)
	hashStr := hex.EncodeToString(hash[:])

	fmt.Printf("生成的hash值：%s\n", hashStr)
	// 2.使用私钥对哈希值进行签名
	signature, err := rsa.SignPKCS1v15(rand.Reader, privateKey, crypto.SHA256, hash[:])
	if err != nil {
		fmt.Println("签名报错:", err)
		return
	}

	// 3.使用公钥验证签名
	err = rsa.VerifyPKCS1v15(publicKey, crypto.SHA256, hash[:], signature)
	if err != nil {
		fmt.Println("验签失败！")
		return
	}
	fmt.Println("验签成功！")
}
