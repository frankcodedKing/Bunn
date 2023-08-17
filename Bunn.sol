// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Bunn {
    string public name = "Ugwuokemba";
    string public symbol = "BUNN";
    uint8 public decimals = 18;
    uint256 public totalSupply;
    address public owner;

    // mapping of the balace of addresses
    // This keeps track of how many tokens each person has.
    mapping(address => uint256) public balanceOf;

    // This helps people give permission to others to spend their tokens.
    //    token holdr         spender    amountAllowed         
    mapping(address => mapping(address => uint256)) public allowance;


    // event listeners that tell us when sth happens
    event Transfer(address indexed from, address indexed to, uint256 amount);
    event Approval(address indexed owner, address indexed spender, uint256 amount);

     constructor() {
        owner = msg.sender;
        balanceOf[msg.sender] = totalSupply;
        mint(msg.sender, 1009e18);
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    //  using address(0) as the sender's address in the transfer event indicates that 
    // the tokens are not being transferred from any existing address

    function mint(address to, uint256 amount) internal {
        require(to != address(0), "Erc20 mint to address 0");
        totalSupply += amount;
        balanceOf[to] += amount;
        emit Transfer(address(0), to, amount );      
    }

    function transfer(address to, uint256  amount) external returns (bool){
        return _transfer(msg.sender, to, amount);
    }

    function _transfer(address from, address to, uint256 amount) private returns (bool){
        require(to != address(0), "Invalid address");
        require(balanceOf[from] >= amount, "Insufficient balance");
        balanceOf[msg.sender] -= amount;
        balanceOf[to] += amount;
        emit Transfer(msg.sender, to, amount);
        return true;
    }

    function approve( address spender, uint256 amount) external  returns (bool){
        require(spender != address(0), "Invalid address");
        allowance[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    } 

    function transferFrom(address from, address to, uint256 amount) external returns (bool){
        uint256 currentBalance = allowance[from][msg.sender];
        require(currentBalance >= amount,"Erc20 transfer amount must exceed allowance" );
        allowance[from][msg.sender]= currentBalance - amount;
        emit Approval(from, to, amount);
        return _transfer(msg.sender, to, amount);
    }

    function burn(uint256 amount) public onlyOwner {
        require(balanceOf[owner] >= amount, "Insufficient balance");
        balanceOf[owner] -= amount;
        totalSupply -= amount;
        emit Transfer(owner, address(0), amount);
        }

}
