// main
package main

import (
	"fmt"

	"github.com/hyperledger/fabric/core/chaincode/shim"
	pb "github.com/hyperledger/fabric/protos/peer"
)

type DunChaincode struct {
}

func (t *DunChaincode) Init(stub shim.ChaincodeStubInterface) pb.Response {
	return t.init(stub)
}

func (t *DunChaincode) Invoke(stub shim.ChaincodeStubInterface) pb.Response {
	function, args := stub.GetFunctionAndParameters()
	if function == "userApprove" { 
		return t.userApprove(stub, args)
	} else if function == "userBind" { 
		return t.userBind(stub, args)
	} else if function == "bidEnter" { 
		return t.bidEnter(stub, args)
	} else if function == "bid" { 
		return t.bid(stub, args)
	} else if function == "bidApprove" { 
		//		return t.bid(stub, args)
	} else if function == "queryUserByUuid" { 
		return t.queryUserByUuid(stub, args)
	} else if function == "queryBid" { 
		return t.queryBid(stub, args)
	} else if function == "queryBidsByTender" { 
		return t.queryBidsByTender(stub, args)
	}

	return shim.Error("Invalid invoke function name.")
}

func main() {
	err := shim.Start(new(DunChaincode))
	if err != nil {
		fmt.Printf("Error starting Simple chaincode: %s", err)
	}
}

