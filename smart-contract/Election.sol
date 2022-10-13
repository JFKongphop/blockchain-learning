// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

contract Election {

    struct Candidate {
        string name;
        uint voteCount;
    }

    struct Voter {
        bool isRegister; // register status
        bool isVoted; // vote only one time
        uint256 voteIndex; // number of candidate
    }

    // array of candidate
    Candidate [] public candidates;

    address public manager;
    // use mapping connect with struct and get status in this
    mapping(address => Voter) public voter;

    constructor() {
        manager = msg.sender;
    }

    modifier onlyManager {
        require(msg.sender == manager, "You can't Manager");
        _;
    }

    // add candidates
    function addCandidates(string memory name) onlyManager public{
        // set candidate to array
        candidates.push(Candidate(name, 0));
    }

    // register and prepare to vote
    function register(address person) onlyManager public {
        // change bool in voter when register to true
        voter[person].isRegister =  true;
    }

    // vote index
    function vote(uint256 index) public {
        require(voter[msg.sender].isRegister, "You cannot vote, please register");
        // check bool vote before vote
        require(!voter[msg.sender].isVoted, "You are Elected");

        // vote index
        voter[msg.sender].voteIndex = index;

        // cannot second time
        voter[msg.sender].isVoted = true;

        // vote score 
        candidates[index].voteCount += 1;
    } 
}