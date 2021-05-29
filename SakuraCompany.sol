//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
import "./SakuraStructs.sol";

contract SakuraCompany is SakuraStructs
{

uint256 billingPeriod;
uint256 idCount;
Employee[25] public companyRoster;

//Feel free to send some Ether ;)
address contractOwnerAddress = 0xF187f54352ab7B807CB4966183b8d83A367f4D05;


//This function will run when the owner view is selected
//The first time the script is run, element 0 in the employees
//array will be set at the owner with premade data
//This 'employee' cannot be deleted, and the function
//will not run again as the 'isOwnerSet' variable will be true
constructor (uint256 period) 
{
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

// Returns false if no slot found or access is denied, else returns true is employee is pushed
function addEmployee(uint256 adminID, 
    string memory name, 
    string memory position, 
    uint8 wageType, 
    uint8 workerHours,
    uint8 payRate,
    uint32 commissionValue,
    uint128 salary,
    uint256 commissionRate) internal returns (bool)
{
    int index = findSlot();
    if(isAdmin(adminID) == false)
    {
        return false;
    }

    if (index < 0) {
        return false;
    }

    companyRoster[uint(index)] = Employee(name, position, idCount, contractOwnerAddress,
    Plan(wageType, workerHours, payRate, commissionValue, salary, commissionRate, billingPeriod),true,0);
    idToEmployee[idCount] = companyRoster[uint(index)];
    idCount++;

        return true;
    
}

//Sets employee's isActive to false
//This will then exclude them from the display
//If employee array is full, the next add call will overwrite employee data
function deleteEmployee(uint256 adminID, uint256 idToBeDeleted) internal returns(bool)
{
    bool canRun = (isAdmin(adminID) && isValid(idToBeDeleted));

    if (canRun)
    {
        idToEmployee[idToBeDeleted].isActive = false;
    }

    return (canRun);
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
    uint32,
    uint32,
    uint32,
    uint128, 
    uint256,
    uint8) {
       
       bool temp = isValid(id);

       if (temp)
       {
            return(temp, idToEmployee[id].name, idToEmployee[id].position, idToEmployee[id].employeeID, idToEmployee[id].paymentAddress, 
         idToEmployee[id].employeePlan.wageType, idToEmployee[id].employeePlan.workerHours, idToEmployee[id].employeePlan.payRate,
         idToEmployee[id].employeePlan.commissionValue, idToEmployee[id].employeePlan.salary, idToEmployee[id].employeePlan.commissionRate, idToEmployee[id].role);
       }

       else 
       {
        return(temp, "", "", 0, contractOwnerAddress,0, 0, 0,0, 0, 0, 0);
       }
    
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


/** 
function setAdmin(uint256 adminID) internal 
{

}

//This function should never actually work in demo
function setNewOwner(uint256 adminID) internal 
{

}
**/

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


//@returns isAdmin, isValid
function isAdmin(uint256 id) view internal returns(bool){

    bool valid = isValid(id);

    if(valid)
    {
        if (idToEmployee[id].role == 1 || idToEmployee[id].role == 2)
        {
            return (true);
        }

    }

    return (false);
}

//@returns isOwner, isValid
function isOwner(uint256 id) view internal returns(bool)
{

    bool valid = isValid(id);

    if(valid)
    {
        if (idToEmployee[id].role == 2)
        {
            return (true);
        }
    }
    return (false);
}

//This function acts as a modifier, anything calling it should break if returns false
function isValid(uint256 id) internal view returns (bool) 
{
    for (uint a = 0; a < companyRoster.length; a++)
    {
        if(companyRoster[a].employeeID == id && companyRoster[a].isActive == true)
        {
            return true;
        }
    }
   
   return false;
}


//ANNOYING SET FUNCTIONS
function setName(uint256 adminID, uint256 id, string memory _name) internal returns(bool)
{
    if (isAdmin(adminID) == false || isValid(id) == false)
    {
        return false;
    }

    idToEmployee[id].name = _name;
    return true;
}

function setPosition(uint256 adminID, uint256 id, string memory _position) internal returns(bool)
{
    if (isAdmin(adminID) == false || isValid(id) == false)
    {
        return false;
    }

    idToEmployee[id].position = _position;
    return true;
}


function setAddress(uint256 adminID, uint256 id, address _paymentAddress) internal returns(bool)
{
    if (isAdmin(adminID) == false || isValid(id) == false)
    {
        return false;
    }

    idToEmployee[id].paymentAddress = _paymentAddress;
    return true;
}


function setWageType(uint256 adminID, uint256 id, uint8 _wageType) internal returns(bool)
{
    if (isAdmin(adminID) == false || isValid(id) == false)
    {
        return false;
    }

    idToEmployee[id].employeePlan.wageType = _wageType;
    return true;
}


function setWorkerHours(uint256 adminID, uint256 id, uint32 _workerHours) internal returns(bool)
{
    if (isAdmin(adminID) == false || isValid(id) == false)
    {
        return false;
    }

    idToEmployee[id].employeePlan.workerHours = _workerHours;
    return true;
}

function setPayRate(uint256 adminID, uint256 id, uint32 _payRate) internal returns(bool)
{
    if (isAdmin(adminID) == false || isValid(id) == false)
    {
        return false;
    }

    idToEmployee[id].employeePlan.payRate = _payRate;
    return true;
}

function setCommissionValue(uint256 adminID, uint256 id, uint32 _commissionValue) internal returns(bool)
{
    if (isAdmin(adminID) == false || isValid(id) == false)
    {
        return false;
    }

    idToEmployee[id].employeePlan.commissionValue = _commissionValue;
    return true;
}

function setSalary(uint256 adminID, uint256 id, uint128 _salary) internal returns(bool)
{
    if (isAdmin(adminID) == false || isValid(id) == false)
    {
        return false;
    }

    idToEmployee[id].employeePlan.salary = _salary;
    return true;
}

function setCommissionRate(uint256 adminID, uint256 id, uint256 _commissionRate) internal returns(bool)
{
    if (isAdmin(adminID) == false || isValid(id) == false)
    {
        return false;
    }

    idToEmployee[id].employeePlan.commissionRate = _commissionRate;
    return true;
}





}