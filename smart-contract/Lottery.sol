// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

contract Lottery{
    // 1 : 1000000000000000000
    
    // manager create this contract
    address public manager;
    // array buyers 
    address payable[] public players;

    // set manager
    constructor(){
        manager = msg.sender;
    }

    // show balance in contract
    function getBalance() public view returns(uint256){
        return address(this).balance;
    }

    // buy lottery
    function buyLottery() public payable{
        require(msg.value == 1 ether, "Lottery is 1 Ether");
        // get address buyers in array
        players.push(payable(msg.sender));
    }
    
    // find length of array 
    function getLength() public view returns(uint256){
        return players.length;
    }

    // random function
    function randomNumber() public view returns(uint256){
        return uint256(keccak256(abi.encodePacked(block.difficulty, block.timestamp, players.length)));
    }

    // show address winner and index of address in players array
    // transfer to winnner
    function selectWinner() public{
        require(msg.sender == manager, "Unaothorizrd, you not manager");
        require(getLength() > 1, "Players is less than 2");

        // find index of random number
        uint256 pickRandom = randomNumber();

        // trasfert to winner
        address payable winner;

        // find index and find in array
        uint256 selectIndex = pickRandom % players.length;
        winner = players[selectIndex];
        winner.transfer(getBalance());

        // when transfer clear players
        players = new address payable[](0);

    }
}