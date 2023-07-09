pragma solidity 0.8.4;  //Do not change the solidity version as it negativly impacts submission grading
// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/access/Ownable.sol";
import "./YourToken.sol";

contract Vendor is Ownable {

  event BuyTokens(address buyer, uint256 amountOfETH, uint256 amountOfTokens);
  event SellTokens(address seller, uint256 amountOfTokens, uint256 amountOfETH);

  YourToken public yourToken;
  uint256 public constant tokensPerEth = 100;

  constructor(address tokenAddress) {
    yourToken = YourToken(tokenAddress);
  }

  // ToDo: create a payable buyTokens() function:
  function  buyTokens() public payable {
    uint256 calculateAmount = tokensPerEth * msg.value;
    yourToken.transfer(msg.sender,calculateAmount);
    emit BuyTokens (msg.sender,msg.value,calculateAmount);
  }


  // ToDo: create a withdraw() function that lets the owner withdraw ETH
  function withdraw() public onlyOwner {
    require(address(this).balance>0,"nothing to withdraw");
    payable(msg.sender).transfer(address(this).balance);
  }

  // ToDo: create a sellTokens(uint256 _amount) function:
  function  sellTokens(uint256 _amount) public {
    require(yourToken.balanceOf(msg.sender)>=_amount,"Insufficient Funds");

    uint256 ethAmount = _amount/tokensPerEth;
    yourToken.transferFrom(msg.sender,address(this),_amount);
    payable(msg.sender).transfer(ethAmount);
     emit SellTokens(msg.sender, _amount, ethAmount);
  }
}
