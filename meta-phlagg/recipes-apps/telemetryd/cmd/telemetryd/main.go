package main

import (
	"log"
	"time"
)

func main() {
	log.Println("telemetryd starting")

	ticker := time.NewTicker(10 * time.Second)

	for range ticker.C {
		log.Println("heartbeat")
	}
}
