//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
import "./SakuraStructs.sol";

contract SakuraCompany is SakuraStructs
{

uint256 billingPeriod;
Employee[25] public companyRoster;
bool isOwnerSet = false;

//Feel free to send some Ether ;)
address contractOwnerAddress = 0xF187f54352ab7B807CB4966183b8d83A367f4D05;

//This function will run when the owner view is selected
//The first time the script is run, element 0 in the employees
//array will be set at the owner with premade data
//This 'employee' cannot be deleted, and the function
//will not run again as the 'isOwnerSet' variable will be true
function setAsOwner() internal
{
require(isOwnerSet == false);
isOwnerSet = true;
Plan memory ownerPlan = Plan(1,0,0,0,100000,0,billingPeriod);
Employee  memory contractOwner = Employee("Andrew Kurtiak", "CEO", contractOwnerAddress,ownerPlan,true,2);
companyRoster[0] = contractOwner;
}

function addEmployee(Employee memory e, Employee memory h) internal isAdmin(e)
{

}

function deleteEmployee(Employee memory e, string memory name, string memory position) internal isAdmin(e)
{

    
    for (uint8 a = 1; a < uint8(companyRoster.length); a++)
    {
       if (keccak256(abi.encodePacked(position, name)) == keccak256(abi.encodePacked(companyRoster[a].position, companyRoster[a].name)))
       {
           companyRoster[a].isActive = false;
       }
    }
}

function displayEmployees() internal view
{

}

function setAdmin(Employee memory e) internal isOwner(e)
{

}

//This function should never actually work in demo
function setNewOwner(Employee memory e) internal isOwner(e)
{

}

function setBillingPeriod(uint256 time, Employee memory e) internal isAdmin(e) 
{
    billingPeriod = time;
    changeEmployeeBillingPeriod(e);
}

function changeEmployeeBillingPeriod(Employee memory e) internal isAdmin(e)
{
    for (uint8 a = 0; a < uint8(companyRoster.length); a++)
    {
       companyRoster[a].employeePlan.billingPeriod = billingPeriod; 
    }
}





}