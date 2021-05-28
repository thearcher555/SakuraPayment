//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
import "./SakuraPlan.sol";

contract SakuraStructs is SakuraPlan
{

struct Employee
{
    string name;
    string position;
    uint256 employeeID;
    address paymentAddress;
    Plan employeePlan;
    bool isActive;

    //Role 0 = Normal
    //Role 1 = Admin
    //Role 2 = Owner
    uint8 role;
}


// goat
mapping(uint256 => Employee) public idToEmployee;


}
