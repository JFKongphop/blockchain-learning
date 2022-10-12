// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

contract Testament {

    // when deploy that set private
    address public _manager; // manager address
    mapping (address => address) _heir; // address owner with heir
    mapping (address => uint256) _balance; // adress owner with 
    
    // log event when 
    // indexed is show all activites in this contract of this addres
    event Create(address indexed owner, address indexed heir, uint256 amount);
    event Report(address indexed owner, address indexed heir, uint256 amount);

    // who is deploy that is manager
    constructor(){
        _manager = msg.sender; 
    }

    // owner create testament
    // if want to set owner must set heir address
    function create(address heir) public payable{
        // deposit to set and prepare to this testament contract
        require(msg.value > 0, "Please deposit money more than zero");
        // use only one time cannot deposit more
        require(_balance[msg.sender] <= 0, "Already testament exist"); 
        
        // set address owner and heir
        _heir[msg.sender] = heir;
        
        // set address owner with their deposit money
        _balance[msg.sender] = msg.value;

        emit Create(msg.sender, heir, msg.value);
    }


    // check testament data
    function getTestament(address owner) public view returns(address heir, uint amount){
        // first show address heir | second show balance in contract both of its call by owner address in mapping
        return (_heir[owner], _balance[owner]);
    }

    // report owner death 
    function reportOfDeath(address owner) public {
        // report only manage
        require(msg.sender == _manager, "Unauthorized, you not manager");
        // check treasure that used to set testament
        require(_balance[owner] > 0, "No testament");

        emit Report(owner, _heir[owner], _balance[owner]);

        // tranfer treasure to heir 
        // read back to front 
        // send treasure from owner to heir address that call by owner address
        payable(_heir[owner]).transfer(_balance[owner]);

        // clear balance and address heir
        _balance[owner] = 0;
        _heir[owner] = address(0);

    }
}