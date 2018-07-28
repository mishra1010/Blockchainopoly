pragma solidity ^0.4.20;
contract Mtoken {
    string public symbol;
    string public  name;
    uint public decimals;
    uint public _totalSupply;
    uint public count = 0;
    uint price = 0.5 ether;
    uint public unitPrice ;
    uint public unitSold ;
    address owner;
    mapping(address => uint) balances;
    mapping(address => mapping(address => uint)) allowed;


    
    constructor () public {
        symbol = "!@#";
        name = "Dynamo";
        decimals = 0;
        _totalSupply = 1000;
        balances[msg.sender] = _totalSupply;
        owner = msg.sender;
    }
    
    function name() view returns (string){
        return name;
    }
    
    function symbol() view returns (string){
        return symbol;
    }
    
    function decimals() view returns (uint8){
        return 0;
    }
    
   
   
    function totalSupply() public constant returns (uint) {
        //return _totalSupply  - balances[address(0)];
        return _totalSupply;
    }


    function balanceOf(address tokenOwner) public constant returns (uint balance) {
        return balances[tokenOwner];
    }


  
    function transfer(address to, uint tokens) public returns (bool success) {
        balances[msg.sender] =  balances[msg.sender] - tokens;
        balances[to] = balances[msg.sender] + tokens;
        Transfer(address(0), msg.sender, _totalSupply);
        return true;
    }
    event Transfer (address indexed _from, address indexed _to, uint value);
    


    function approve(address spender, uint tokens) public returns (bool success) {
        require(tokens > 0);
        require (balances[msg.sender] > tokens);
        allowed[msg.sender][spender] = tokens;
        Approval(msg.sender, spender, tokens);
        return true;
    }
    event Approval(address indexed _owner, address indexed _spender, uint value);


 
    function transferFrom(address from, address to, uint tokens) public returns (bool success) {
        balances[from] = balances[from] - tokens;
        allowed[from][msg.sender] = allowed[from][msg.sender] - tokens;
        balances[to] = balances[to] + tokens;
       
        return true;
    }


   
    function allowance(address tokenOwner, address spender) public constant returns (uint remaining) {
        return allowed[tokenOwner][spender];
    }


    



    function () public payable {
        if(balances[owner]>=500){
            price=0.5 ether;
        }
        
        else{
            price=1 ether;
        }
        
        unitPrice = price;
        unitSold = msg.value/unitPrice;
        balances[msg.sender] = balances[msg.sender] + unitSold;
        balances[owner] = balances[owner] - unitSold;
        
        
    }



}