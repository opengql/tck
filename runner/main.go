package main

import (
	"flag"
	"github.com/opengql/tck/runner/clients"
	"log"
)

func main() {
	pluginNamePtr := flag.String("plugin", "default", "Plugin name")
	flag.Parse()

	if client, ok := clients.Clients[*pluginNamePtr]; ok {
		client.Execute("match (n) return n")
	} else {
		log.Fatalf("Plugin '%s' not found", *pluginNamePtr)
	}
}
