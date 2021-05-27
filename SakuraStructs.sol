//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
import "./SakuraPlan.sol";

contract SakuraStructs is SakuraPlan
{

struct Employee
{
    string name;
    string position;
    address paymentAddress;
    Plan employeePlan;
    bool isActive;

    //Role 0 = Normal
    //Role 1 = Admin
    //Role 2 = Owner
    uint8 role;
}

modifier isAdmin(Employee memory e) {
    require(e.role == 1);
    _;
}

modifier isOwner(Employee memory e)
{
    require(e.role == 2);
    _;
}


mapping(address => Employee) usernameToAddress;


}
