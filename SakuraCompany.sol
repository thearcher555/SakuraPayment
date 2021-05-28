//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
import "./SakuraStructs.sol";

contract SakuraCompany is SakuraStructs
{

uint256 billingPeriod;
uint256 idCount;
Employee[25] public companyRoster;
bool isOwnerSet = false;

//Feel free to send some Ether ;)
address contractOwnerAddress = 0xF187f54352ab7B807CB4966183b8d83A367f4D05;

//This function will run when the owner view is selected
//The first time the script is run, element 0 in the employees
//array will be set at the owner with premade data
//This 'employee' cannot be deleted, and the function
//will not run again as the 'isOwnerSet' variable will be true
function initContract(uint256 period) internal
{
    require(isOwnerSet == false);
    isOwnerSet = true;
    billingPeriod = period;
    idCount = 1;
    companyRoster[0] = Employee("Andrew Kurtiak", "CEO", idCount, contractOwnerAddress,Plan(1,0,0,0,100000,0,billingPeriod),true,2);
    idToEmployee[1] = companyRoster[0];
    idCount++;

    for (uint256 x = 1; x < companyRoster.length; x++) {
       companyRoster[x] = Employee("", "", 0, contractOwnerAddress, Plan(0, 0, 0, 0, 0, 0, billingPeriod), false, 0);
    }
}

// Returns -1 if no slot found, else returns first available slot
function findSlot() internal view returns(int) {
    int temp = -1;

    for (uint x = 1; x < companyRoster.length; x++) {
        if (companyRoster[x].isActive == false) {
            return int(x);
        }
    }
    return temp;
}

// Returns -1 if no slot found, else returns first index of added employee
function addEmployee(uint256 adminID, 
    string memory name, 
    string memory position, 
    uint8 wageType, 
    uint8 workerHours,
    uint8 payRate,
    uint32 commissionValue,
    uint128 salary,
    uint256 commissionRate) internal isAdmin(adminID) returns (int)
{
    int index = findSlot();
    if (index < 0) {
        return -1;
    }

    else {

    companyRoster[uint(index)] = Employee(name, position, idCount, contractOwnerAddress,
    Plan(wageType, workerHours, payRate, commissionValue, salary, commissionRate, billingPeriod),true,0);
    idToEmployee[idCount] = companyRoster[uint(index)];
    idCount++;
        return index;
    }
}

// fuuuuuuuuck it
function deleteEmployee(uint256 adminID, uint256 idToBeDeleted) internal isAdmin(adminID)
{
    idToEmployee[idToBeDeleted].isActive = false;
}

//TO DO
function isValid(uint256 id) internal returns (bool) {
}

// plan starts at 5th return val
// FIRST INT TO CHECK FOR VALIDITY
function getProfile(uint256 id) internal view returns (
    bool,
    string memory,
    string memory,
    uint256,
    address,
    uint8,
    uint8,
    uint8,
    uint32,
    uint128, 
    uint256,
    uint8) {
       
    return(true, idToEmployee[id].name, idToEmployee[id].position, idToEmployee[id].employeeID, idToEmployee[id].paymentAddress, 
    idToEmployee[id].employeePlan.wageType, idToEmployee[id].employeePlan.workerHours, idToEmployee[id].employeePlan.payRate,
    idToEmployee[id].employeePlan.commissionValue, idToEmployee[id].employeePlan.salary, idToEmployee[id].employeePlan.commissionRate, idToEmployee[id].role);
}

function getActiveEmployees() internal view returns (uint) {
    uint count = 0;

    for (uint x = 0; x < companyRoster.length; x++) {
        if (companyRoster[x].isActive == true) {
            count++;
        }
    }
    return count;
}


function setAdmin(uint256 adminID) internal isOwner(adminID)
{

}

//This function should never actually work in demo
function setNewOwner(uint256 adminID) internal isOwner(adminID)
{

}

/*
function setBillingPeriod(uint256 time, uint256 adminID) internal isAdmin(adminID) 
{
    billingPeriod = time;
    changeEmployeeBillingPeriod(e);
} */

/* 
function changeEmployeeBillingPeriod(uint256 adminID) internal isAdmin(adminID)
{
    for (uint8 a = 0; a < uint8(companyRoster.length); a++)
    {
       companyRoster[a].employeePlan.billingPeriod = billingPeriod; 
    }
} */


modifier isAdmin(uint256 id) {
    require(idToEmployee[id].role == 1 || idToEmployee[id].role == 2);
    _;
}

modifier isOwner(uint256 id) 
{
    require(idToEmployee[id].role == 2);
    _;
}


}