pragma solidity ^0.4.20;

contract AbstractMultiSig {
    address Owner;
    uint public contractbalance;
    uint public remainingbalance;
    mapping (address => bool) public contributors;
    mapping (address => uint) public contributorsamt;
    mapping(address => mapping(address => bool)) public benprop;
    mapping (address => uint) public listbeneficiary;
    mapping (address => bool) public beneficiary;
    mapping (address => bool) public signer;
    mapping (address => uint) public approvecounter;
    mapping (address => uint) public rejectcounter;
    mapping(address=>bool) public open;
    bool status = false;
    address [] public beneficiarylist;
    address [] public contributor ;
    address public contributer;
    address [] public signers;
    uint public approvercount;
    uint public rejectcount;
    bool public complete;
    enum State {CONTRIBUTIONS,ACTIVE}
    State state;
    function AbstractMultiSig () public {
        state = State.CONTRIBUTIONS;
        Owner = msg.sender;
        //contractbalance=this.balance; 
        setSigner ();
    }
    
    function owner () view external returns(address){
        return Owner;
    }
  function () public payable{
    require(state == State.CONTRIBUTIONS);
    require(msg.value > 0);
    if(contributors[msg.sender]== false){
        contributorsamt[msg.sender] = msg.value;
        contributor.push(msg.sender);
        contributors[msg.sender] = true;
        contributorsamt[msg.sender] = msg.value;
    }
    else
    {
        contributorsamt[msg.sender] = contributorsamt[msg.sender] + msg.value;    
    }
    contractbalance = contractbalance + msg.value;
     ReceivedContribution(msg.sender,msg.value);
}

function setSigner() public {
   
       /*signer[0x4b0897b0513fdc7c541b6d9d7e929c4e5364d2db]=true;
       signers.push(0x4b0897b0513fdc7c541b6d9d7e929c4e5364d2db);
       signer[0x583031d1113ad414f02576bd6afabfb302140225]=true;
       signers.push(0x583031d1113ad414f02576bd6afabfb302140225);
       signer[0xdd870fa1b7c4700f2bd7f44238821c26f7392148]=true;
       signers.push(0xdd870fa1b7c4700f2bd7f44238821c26f7392148);*/
      
       signer[0xfA3C6a1d480A14c546F12cdBB6d1BaCBf02A1610]=true;
       signers.push(0xfA3C6a1d480A14c546F12cdBB6d1BaCBf02A1610);
       signer[0x2f47343208d8Db38A64f49d7384Ce70367FC98c0]=true;
       signers.push(0x2f47343208d8Db38A64f49d7384Ce70367FC98c0);
       signer[0x7c0e7b2418141F492653C6bF9ceD144c338Ba740]=true;
       signers.push(0x7c0e7b2418141F492653C6bF9ceD144c338Ba740);
   }

   function getSigner()  public view returns (address []){
	return signers;
   }

  event ReceivedContribution(address indexed _contributor, uint _valueInWei);
   
function endContributionPeriod() external{
   require(beneficiary[msg.sender] == false);
   require(signer[msg.sender] == true);
   //require(contributors[msg.sender] == false); //------------------------- Checkit--------------
    state = State.ACTIVE;
    signer[msg.sender] = true;
    signers.push(msg.sender);
    
}
 
  function submitProposal(uint _valueInWei) external {
      require (state == State.ACTIVE);
      require(open[msg.sender]==false);
      require(!(signer[msg.sender]));
      require (!(10*_valueInWei > contractbalance));
       beneficiarylist.push(msg.sender);
       listbeneficiary[msg.sender]=_valueInWei;
       beneficiary[msg.sender] = true;
       open[msg.sender]=true;
       contractbalance = (contractbalance - _valueInWei);
       ProposalSubmitted(msg.sender,_valueInWei);
  }
  
  event ProposalSubmitted(address indexed _beneficiary, uint _valueInWei);

  function listOpenBeneficiariesProposals() external view returns (address[]){
      return beneficiarylist;
  }

  
  function getBeneficiaryProposal(address _beneficiary) external view returns (uint){
      require (state == State.ACTIVE);
      return listbeneficiary[_beneficiary];
      
  }

  
  function listContributors() external view returns (address[]){
      return contributor;
  }

  
  function getContributorAmount(address _contributor) external view returns (uint){
      return contributorsamt[_contributor];
  }

  
  function approve(address _beneficiary) external{
      require (state == State.ACTIVE);
      require(signer[msg.sender]==true);
      require(beneficiary[_beneficiary] == true);
      require(benprop[msg.sender][_beneficiary] == false);
        benprop[msg.sender][_beneficiary] = true;
        approvecounter[_beneficiary]++;
        
       ProposalApproved(msg.sender,_beneficiary,listbeneficiary[_beneficiary]);
  }
  event ProposalApproved(address indexed _approver, address indexed _beneficiary, uint _valueInWei);

  
  function reject(address _beneficiary) external{
      require (state == State.ACTIVE);
      require(signer[msg.sender]==true);
      require(beneficiary[_beneficiary] == true);
      require(benprop[msg.sender][_beneficiary] == false);
      benprop[msg.sender][_beneficiary] = true;
      rejectcounter[_beneficiary]++;
     ProposalRejected(msg.sender,_beneficiary,listbeneficiary[_beneficiary]);
  }
  event ProposalRejected(address indexed _approver, address indexed _beneficiary, uint _valueInWei);

  
  function withdraw(uint _valueInWei) external payable{
      require (state == State.ACTIVE);
      require(beneficiary[msg.sender] == true);
      if (approvecounter[msg.sender]>rejectcounter[msg.sender]){
        require(_valueInWei < listbeneficiary[msg.sender]);
        msg.sender.transfer(_valueInWei);
        remainingbalance = listbeneficiary[msg.sender] - _valueInWei;
        contractbalance = contractbalance + remainingbalance;
        complete = true;
      listOpenBeneficiaryProposals(msg.sender);
      open[msg.sender] = false;
      }
      else{
          contractbalance = contractbalance + listbeneficiary[msg.sender];
          complete = true;
          listOpenBeneficiaryProposals(msg.sender);
          open[msg.sender] = false;
      }
       WithdrawPerformed(msg.sender,_valueInWei);
  }
  event WithdrawPerformed(address indexed beneficiary, uint _valueInWei);
  
  function listOpenBeneficiaryProposals(address _beneficiary) internal returns (address[]) {
      require (complete);
      for (uint i = 0; i < beneficiarylist.length; i++) {
        if(beneficiarylist[i] == _beneficiary){
         delete beneficiarylist[i];
            beneficiarylist.length--;
      }
      }
            return beneficiarylist;
  }

}