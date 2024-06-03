package main

import (
	"log"
	"sps-cust-auth-plugin/pkg/api/server"
)

func main() {
	log.Default().Println("Starting custom auth plugin")
	server.Start()
}
