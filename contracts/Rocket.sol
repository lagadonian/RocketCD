pragma solidity ^0.5.0;


contract Rocket {

	struct Account {

		uint256 balance; //amount of eth deposited and accumulated
		uint256 shares;
	}
	
	uint enrollment_end = block.timestamp+86400;
	uint expiration = block.timestamp+604800;

	mapping(address => Account) public accounts;
	
	uint pot; 
	uint shares_outstanding; 


	function deposit() payable public {
	    require(block.timestamp<enrollment_end, "Enrollment ended.");
		Account storage account = accounts[msg.sender];
		account.shares+=msg.value;
		account.balance+=msg.value; //credit his account with initial balance and shares equal to the sent sum

		shares_outstanding+=msg.value; //add these newly created shares to the table


	}

	function check_balance() public view returns (uint) {
		Account storage account = accounts[msg.sender];
		return account.balance;


	}
	
	function check_shares() public view returns (uint) {
		Account storage account = accounts[msg.sender];
		return account.shares;


	}
	
	function check_pot() public view returns (uint) {
	    return pot;
	}
	
	function check_shares_outstanding() public view returns (uint) {
	    return shares_outstanding;
	}
	
	function check_time_left() public view returns (uint) {
	    uint time_left = expiration-block.timestamp;
	    if (block.timestamp<expiration) {
	        return time_left;
	    }
	    else {
	        return 0;
	    }
	}
	
	function cashout(address _address) private {
	    Account storage account = accounts[_address];
	    uint256 pot_share = account.shares*pot/shares_outstanding;  
	    account.balance+=pot_share; //credit the user with his percentage of the pot
	    pot=pot-pot_share; //subtract the credited sum from the pot
	    shares_outstanding=shares_outstanding-account.shares; //remove his used up shares from the table
	    account.shares=0; //remove his used up shares from his account
	   
	}

	function withdraw() public returns(uint256) {
	    
	    
	    uint256 amount;
	    uint256 payout;
		Account storage account = accounts[msg.sender];
		address payable User = msg.sender;
		
		cashout(User); //user cashes out his share of the pot
		
		

		amount = account.balance;
		if (block.timestamp<expiration && block.timestamp>enrollment_end) {
		    payout = amount*4/5;
		
    		User.transfer((payout)); //contract transfers 80% of the user's balance to user
    		pot+=amount/5;            //remaining 20% is added to the pot
		}
		else {
		    payout=amount;
		    User.transfer((payout));    
		}
		
		account.balance=account.balance-amount; //zero the user's balance
		return payout;
	}
}