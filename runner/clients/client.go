package clients

type Client interface {
	Execute(program string) (any, error)
}

var Clients map[string]Client = make(map[string]Client)
