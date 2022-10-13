// SPDX-License-Identifier: MIT

pragma solidity ^0.8.8;

contract Bank{
    // create each wallet by mapping
    mapping (address => uint256) public _balances;
    uint _totalSupply;

    function deposit() public payable{
        // _balance += amount;
        _balances[msg.sender] += msg.value;
        _totalSupply += msg.value;
    } 

    function withdraw(uint amount) public payable{
        require(amount <= _balances[msg.sender], "Balance is not enough");
        payable(msg.sender).transfer(amount);
        _balances[msg.sender] -= amount;
        _totalSupply -= amount;
    }

    function getBalance() public view returns(uint){
        return _balances[msg.sender];
    }

    function getTotalSupply() public view returns(uint){
        return _totalSupply;
    }
}
