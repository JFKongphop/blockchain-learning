// SPDX-License-Identifier: MIT

pragma solidity ^0.8.8;

contract Bank{
    // 15000000000000000000
    // create each wallet by mapping
    mapping (address => uint256) public _balances;
    uint _totalSupply;

    event Deposit(address indexed owner, uint amount);
    event Withdraw(address indexed owner, uint amount);
    event Transfer(address indexed from, address indexed to, uint amount);
    

    function deposit() public payable{
        // _balance += amount;
        _balances[msg.sender] += msg.value;
        _totalSupply += msg.value;
        emit Deposit(msg.sender, msg.value);
    } 

    function withdraw(uint amount) public payable{
        require(amount <= _balances[msg.sender], "Balance is not enough");
        payable(msg.sender).transfer(amount);
        _balances[msg.sender] -= amount;
        _totalSupply -= amount;

        emit Withdraw(msg.sender, amount);
    }

    function transferTo(address to, uint amount) public payable{
        require(amount <= _balances[msg.sender], "Balance is not enough");
        payable(to).transfer(amount);
        _balances[msg.sender] -= amount;
        _balances[to] += amount;

        emit Transfer(msg.sender, to, amount);
    }

    function getBalance() public view returns(uint){
        return _balances[msg.sender];
    }

    function getTotalSupply() public view returns(uint){
        return _totalSupply;
    }
}