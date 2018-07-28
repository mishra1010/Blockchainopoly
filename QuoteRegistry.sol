pragma solidity ^0.4.20;

contract QuoteRegistry{
    
mapping (string=>address) records;
address public owner;

function QuoteRegistry() public  {
 owner=msg.sender;
}

function register (string _quote) public {
    records[_quote]=msg.sender;
}

function ownership (string _quote) public view returns (address) {
   owner = records[_quote];
   return owner;
}

function transfer (string _quote, address _newOwner) public payable{
    require(msg.value>=0.5 ether);
    records[_quote].transfer(msg.value);
    records[_quote]=_newOwner;
    
}

function Owner() public returns (address) {
        return owner;

}
}