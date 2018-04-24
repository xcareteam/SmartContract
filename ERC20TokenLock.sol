pragma solidity ^0.4.16;

contract ERC20 {

    string public name;
    string public symbol;
    uint8 public decimals = 8;
    uint256 public totalSupply;

    mapping (address => uint256) public balanceOf;
    mapping (address => mapping (address => uint256)) public allowance;
    mapping (address => string) public  keys;

    function transfer(address _to, uint256 _value) public;
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
    function approve(address _spender, uint256 _value) public returns (bool success);
    function register(string key) public;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Register (address user, string key);
}

contract Math {
    
    function add(uint256 x, uint256 y) pure internal returns (uint256 z) {
        assert((z = x + y) >= x);
    }

    function sub(uint256 x, uint256 y) pure internal returns (uint256 z) {
        assert((z = x - y) <= x);
    }

    function mul(uint256 x, uint256 y) pure internal returns (uint256 z) {
        assert((z = x * y) >= x);
    }

    function div(uint256 x, uint256 y) pure internal returns (uint256 z) {
        z = x / y;
    }

}

contract TokenLock is Math {

    uint256 startTime;
    uint256 lockedDays;
    address owner;

    ERC20 token;

    function TokenLock(uint256 _lockedDays, address _address) public {
        lockedDays = _lockedDays;
        startTime = time();

        token = ERC20(_address);
        owner = msg.sender;
    }

    function transferOwner(address _address) external {
        require(msg.sender == owner);
        require(_address != address(0));

        owner = msg.sender;
    }

    function getBalance() view external returns (uint256) {
        return token.balanceOf(address(this));
    }
    
    function transfer(address to, uint256 value) external {
        require(msg.sender == owner);
        
        uint passedDays = dayFor(time());
        require(passedDays > lockedDays);
        
        token.transfer(to, value);
    }

    function time() public constant returns (uint) {
        return block.timestamp;
    }

    function dayFor(uint timestamp) internal constant returns (uint) {
        return timestamp < startTime
            ? 0
            : sub(timestamp, startTime) / 24 hours + 1;
    }
    
    function getPassedDays() external constant returns (uint) {
        return dayFor(time());
    }
}