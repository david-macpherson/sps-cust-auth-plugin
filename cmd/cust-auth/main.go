package main

import (
	"log"
	"os"
	"sps-cust-auth-plugin/pkg/api/server"
	"sps-cust-auth-plugin/pkg/api/server/defaults"
	"strconv"
)

func main() {
	portEnv := os.Getenv("PORT")
	if portEnv == "" {
		portEnv = defaults.AUTHENTICATION_PLUGIN_PORT
	}

	port, err := strconv.Atoi(portEnv)
	if err != nil {
		panic("unable to convert portEnv: " + err.Error())
	}

	log.Default().Printf("Starting custom auth plugin listening on: %v\n", port)
	server.Start(port)
}
