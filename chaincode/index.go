package main

import (
	"encoding/json"
	"errors"
	"fmt"

	"github.com/hyperledger/fabric/core/chaincode/shim"
)


func CreateValueIndex(stub shim.ChaincodeStubInterface, indexType, key, value string) error {
	if value == "" {
		return errors.New("Index value can not be null")
	}
	key = indexType + key
	b, _ := stub.GetState(key)
	if len(b) != 0 {
		if string(b) != value {
			return fmt.Errorf("Index of Type %s KEY %s exists with diffent index value", indexType, key)
		} else {
			return nil
		}
	}
	err := stub.PutState(key, []byte(value))
	if err != nil {
		return err
	}
	return nil
}

func GetValueByIndex(stub shim.ChaincodeStubInterface, indexType, key string) (string, error) {
	b, err := stub.GetState(indexType + key)
	if err != nil {
		return "", err
	}
	return string(b), nil
}

func DelValueIndex(stub shim.ChaincodeStubInterface, indexType, key string) error {
	err := stub.DelState(indexType + key)
	if err != nil {
		return err
	}
	return nil
}

func CreateArrayIndex(stub shim.ChaincodeStubInterface, indexType, key, value string) error {
	if key == "" || value == "" {
		return errors.New("Index key or value is nil")
	}
	key = indexType + key

	var err error
	var b []byte
	var values []string

	b, _ = stub.GetState(key)
	json.Unmarshal(b, &values)

	flag := false
	for _, v := range values {
		if v == value {
			flag = true
			break
		}
	}

	if !flag {
		values = append(values, value)
		b, _ = json.Marshal(values)

		err = stub.PutState(key, b)
		if err != nil {
			return err
		}
	}

	return nil
}
func GetArrayByIndex(stub shim.ChaincodeStubInterface, indexType, key string) ([]string, error) {
	if key == "" {
		return nil, errors.New("Index key is nil")
	}
	key = indexType + key

	var b []byte
	var values []string

	b, _ = stub.GetState(key)
	json.Unmarshal(b, &values)

	return values, nil
}

func DelArrayIndex(stub shim.ChaincodeStubInterface, indexType, key, value string) error {
	if key == "" {
		return errors.New("Index key is nil")
	}
	key = indexType + key

	var err error
	var b []byte
	var values, res []string

	b, _ = stub.GetState(key)
	json.Unmarshal(b, &values)

	for _, v := range values {
		if v == value {
			continue
		} else {
			res = append(res, v)
		}
	}
	b, err = json.Marshal(res)
	if err != nil {
		return err
	}
	err = stub.PutState(key, b)
	if err != nil {
		return err
	}
	return nil
}

