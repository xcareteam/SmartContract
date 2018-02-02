package main

const (
	CONST_USER_STATUS_Approved string = "1" 
)

type User struct {
	Uuid      string            `json:"Uuid"`      
	UserName  string            `json:"UserName"`  
	UserCert  string            `json:"UserCert"`  
	Status    string            `json:"Status"`   
	BackTimes string            `json:"BackTimes"` 
	ID        File              `json:"ID"`        
	License   File              `json:"License"`  
	Dict      map[string]string `json:"Dict"`      
}

type File struct {
	FileName string 
	FilePath string 
	FileHash string 
}
