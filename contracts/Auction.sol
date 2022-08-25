// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract Auction {

    address payable public seller;
    uint public highestBid;
    address public highestBidder;
    mapping(address => uint) public bids;
    uint public endTime;
    bool public started;
    bool public ended;

    constructor (uint initialBid) {
    
    seller = payable(msg.sender);
    highestBid = initialBid;
    }

    function start(uint x) external {
        require(!started, "started");
        require(msg.sender == seller, "not seller");

        started = true;
        endTime = block.timestamp + (x * 1 days);

    }

    function bid() external payable {

        require(started, "Auction hasn't started");
        require(block.timestamp < endTime, "Auction has ended");
        require(msg.value > highestBid, "Your bid is less than the highest, please increase it");

        if (highestBidder != address(0)) {
            bids[highestBidder] += highestBid;
        }

        highestBidder = msg.sender;
        highestBid = msg.value;
    }

    function withdraw() external {

        uint bal = bids[msg.sender];
        bids[msg.sender] = 0;
        payable(msg.sender).transfer(bal);
    }

    function end() external {
        
        require(started, "not started");
        require(block.timestamp >= endTime, "It is not yet time to end the auction");
        require(!ended, "The auction has already been ended");

        ended = true;
    }
    // Improve
    function takeEarnings() public {
        require(msg.sender == seller, "You are not allowed to take the earnings");
        seller.transfer(address(this).balance);
    }
}
