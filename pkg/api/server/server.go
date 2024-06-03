package server

import (
	"context"
	"fmt"
	"log"
	"net"
	"sps-cust-auth-plugin/pkg/api/server/defaults"

	"github.com/scalablepixelstreaming/apis/pkg/authentication"
	"google.golang.org/grpc"
)

// Represents the Authentication Plugin gRPC server
type PluginServer struct {
	authentication.UnimplementedAuthenticationPluginServer
}

// Our no-op authentication implementation
func (server *PluginServer) Authenticate(ctx context.Context, req *authentication.AuthenticationRequest) (*authentication.AuthenticationResponse, error) {
	log.Default().Println("sending back an error")
	return &authentication.AuthenticationResponse{

		// Unconditionally authenticate all users
		Outcome: authentication.AuthenticationResponse_ERROR,
		// Just generate a new UUID for the user ID value
		Payload: &authentication.AuthenticationResponse_Error{
			Error: "This is from the custom auth plugin ",
		},
	}, nil
}

func Start() {

	// Attempt to listen on the default port number for Authentication Plugins
	sock, err := net.Listen("tcp", fmt.Sprintf(":%d", defaults.AUTHENTICATION_PLUGIN_PORT))
	if err != nil {
		log.Default().Fatal(err.Error())
	}

	// Create our gRPC server and start serving requests
	grpcServer := grpc.NewServer()

	authentication.RegisterAuthenticationPluginServer(grpcServer, &PluginServer{})

	if err := grpcServer.Serve(sock); err != nil {
		log.Fatal(err.Error())
	}
}
