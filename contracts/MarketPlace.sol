/// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "./costomIercInterface.sol";

error BuyToken__InSuffientFundSentSendMultiplesOfPrice();
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
    mapping(address => WaitList[]) public waitinglist;

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

    //helper function
    function removeElement(uint _index) private {
        uint lastIndex = waitinglist[msg.sender].length - 1;
        if (lastIndex != _index) {
            waitinglist[msg.sender][_index] = waitinglist[msg.sender][lastIndex];
        }
        waitinglist[msg.sender].pop();
    }

    // functions
    function buyToken() public payable returns (uint256 index) {
        if (msg.value % price != 0) revert BuyToken__InSuffientFundSentSendMultiplesOfPrice();
        uint256 amount = (msg.value) / price;
        waitinglist[msg.sender].push(WaitList(block.timestamp, msg.value, amount));
        emit TokenBuyed(msg.sender, amount, msg.value);
        return waitinglist[msg.sender].length - 1;
    }

    function claimToken(uint _index) public nonReentrant {
        if (waitinglist[msg.sender][_index].timeBuyed == 0) revert ClaimToken__UserNotBuyedToken();
        if (block.timestamp - waitinglist[msg.sender][_index].timeBuyed < 365 days)
            revert ClaimToken__ClaimNotMatured();
        uint amount = waitinglist[msg.sender][_index].amount;
        bool sucess = Htoken.mint(msg.sender, amount);
        if (sucess) {
            emit TokenClaimed(msg.sender, waitinglist[msg.sender][_index].amount);
            removeElement(_index);
        } else {
            revert ClaimToken__TransactionError();
        }
    }

    function withdrawRevenue() public onlyOwner {
        uint bal = address(this).balance;
        payable(msg.sender).transfer(bal);
        emit RevenueCollected(msg.sender, bal);
    }

    receive() external payable {
        buyToken();
    }

    fallback() external payable {
        buyToken();
    }
}
