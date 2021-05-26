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
    bool isEmployer;
}

modifier isEmployer(Employee memory e) {
    require(e.isEmployer);
    _;
}


//Mapping of Employee to address???
mapping(address => Employee) usernameToAddress;


}
