pragma solidity ^0.5.0;

import './Rocket.sol';

contract Rockets {
   address[] rockets;
   function createRocket(uint _enrollment_duration, uint _total_duration, uint _penalty) public {
       
      Rocket newRocket = new Rocket(_enrollment_duration, _total_duration, _penalty);            
      rockets.push(address(newRocket));   
   }
   function getDeployedRockets() public view returns (address[] memory) {
      return rockets;
   }
}


