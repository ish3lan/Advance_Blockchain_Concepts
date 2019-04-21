
pragma solidity ^0.4.25;
contract Rate_Limiting {

  using SafeMath for uint256 ;  
  uint256 private enabled = block.timestamp;
  uint256 private entrancyGuardCounter = 0;


  modifier rateLimit(uint time){
    require( block.timestamp >= enabled, "Rate Limiting Not Passed");
    enbaled = enabled.add(time);
    _;
  }

  modifier entrancyGuard(){
    entrancyGuardCounter.add(1);
    uint256 localentrancyGuardCounter = entrancyGuardCounter;

    _;
    require(localentrancyGuardCounter == entrancyGuardCounter, "ReEntrancy Guard Blocking!");
  }

  function safeWithdraw(uint256 amount)

  external
  rateLimit(30 minutes)
  {

    //Withdraw code

  }

}