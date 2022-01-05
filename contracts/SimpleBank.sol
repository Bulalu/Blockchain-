pragma solidity 0.8.6;

// SPDX-License-Identifier: MIT

contract SimpleBank {
    uint8 private clientCount;
    address public owner;

    struct ClientInfo {
        uint balance;
        // check if client is enrolled
        bool enrolled;
    }
    mapping(address => ClientInfo) private clientInfo;

    // Log the event about a deposit being made by an address and its amount
    event LogDepositMade(address indexed accountAddress, uint amount);

    // Constructor is "payable" so it can receive the initial funding of 30, 
    // required to reward the first 3 clients
    constructor()  payable {
        require(msg.value >= 30 ether, "30 initial funding required");
        owner = msg.sender;
        clientCount = 0;
    }

    /// @notice Enroll a customer with the bank, 
    /// giving the first 3 of them 10 ether as reward
    /// @return The balance of the user after enrolling
    function enroll() public returns (uint) {
        if (clientCount < 3) {
            clientCount++;
            clientInfo[msg.sender].balance = 10 ether;
        }

        clientInfo[msg.sender].enrolled = true;

        return clientInfo[msg.sender].balance;
    }

     /// @notice Deposit ether into bank, requires method is "payable"
    /// @return The balance of the user after the deposit is made
    function deposit() public payable returns(uint){
        require(clientInfo[msg.sender].enrolled == true, "Client must be enrolled to deposit");
        clientInfo[msg.sender].balance  += msg.value;
        emit LogDepositMade(msg.sender, msg.value);
        return clientInfo[msg.sender].balance;
    }

    /// @notice Withdraw ether from bank
    /// @return The balance remaining for the user
    function withdraw(uint _amount) public returns(uint) {
        require( _amount <= clientInfo[msg.sender].balance, "Withdraw: You do not have enough balance");
        clientInfo[msg.sender].balance -= _amount;
        payable(address(this)).transfer(_amount);

        return clientInfo[msg.sender].balance;

    }

    /// @notice Just reads balance of the account requesting, so "constant"
    /// @return The balance of the user
    function balance() public view returns (uint) {
        return clientInfo[msg.sender].balance;
    }

    /// @return The balance of the Simple Bank contract
    function depositsBalance() public view returns (uint) {
        return address(this).balance;
    }

}