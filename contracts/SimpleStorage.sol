pragma solidity ^0.6.0;

// SPDX-License-Identifier: MIT

contract SimpleStorage {

    uint public number;
    address owner;

    constructor()  public {
        owner = msg.sender;
    }
    mapping(address => uint) public storenum;

    function storeNumber( uint _num) public {
        number = _num;
        storenum[msg.sender] = number;
    }
    function getNumber() public view returns(uint) {
        return number;
    }

    function getNumberByAddress(address _address) public view returns(uint) {
        return storenum[_address];
    }

    function resetNumber() public {
        require (msg.sender == owner, "Sender must be an admin");
        number = 0;
    }
}