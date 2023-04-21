/// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

error BuyToken__InSuffientFundSent();
error ClaimToken__UserNotBuyedToken();
error ClaimToken__ClaimNotMatured();
error ClaimToken__TransactionError();
error WithdrawRevenue__RevenueNotSent();

contract MarketPlace is ReentrancyGuard, Ownable {
    //type Declarations
    struct WaitList {
        uint timeBuyed;
        uint payedAmt;
        uint amount;
    }
    mapping(address => WaitList) public waitinglist;

    //state variables
    IERC20 public immutable Htoken;
    uint public constant price = 1 * (10 ** 16);

    //contructors
    constructor(address _tokenAdress) {
        Htoken = IERC20(_tokenAdress);
    }

    event TokenBuyed(address indexed buyer, uint amount, uint payed);
    event TokenClaimed(address indexed buyer, uint amount);
    event RevenueCollected(address owner, uint amount);

    // functions
    function buyToken(uint _amt) public payable {
        if (msg.value < price * _amt) revert BuyToken__InSuffientFundSent();
        waitinglist[msg.sender] = WaitList(block.timestamp, msg.value, _amt);
        emit TokenBuyed(msg.sender, _amt, msg.value);
    }

    function claimToken() public {
        if (waitinglist[msg.sender].timeBuyed == 0) revert ClaimToken__UserNotBuyedToken();
        if (waitinglist[msg.sender].timeBuyed + 365 days > block.timestamp)
            revert ClaimToken__ClaimNotMatured();
        bool sucess = Htoken.transfer(msg.sender, waitinglist[msg.sender].amount);
        if (sucess) {
            delete waitinglist[msg.sender];
        } else {
            revert ClaimToken__TransactionError();
        }
        emit TokenClaimed(msg.sender, waitinglist[msg.sender].amount);
    }

    function withdrawRevenue() public onlyOwner {
        uint bal = address(this).balance;
        (bool success, ) = payable(msg.sender).call{value: bal}("");
        if (!success) revert WithdrawRevenue__RevenueNotSent();
        emit RevenueCollected(msg.sender, bal);
    }
}
