package clients

import (
	"log"
)

type DefaultClient struct{}

const pluginName = "default"

func init() {
	Clients[pluginName] = DefaultClient{}
	log.Printf("Registered %s client\n", pluginName)
}

func (s DefaultClient) Execute(program string) (any, error) {
	log.Printf("Executing %s\n", program)
	return "hello world", nil
}
