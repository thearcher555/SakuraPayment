//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.5.16;
import "./SakuraStructs.sol";

contract SakuraCompany is SakuraStructs
{

uint256 billingPeriod;
uint256 idCount;
uint256 totalPaid;
uint256 totalPaidBillingPeriod;
Employee[25] companyRoster;

//Feel free to send some Ether ;)
address payable contractOwnerAddress;


//This method will run as the contract is deployed for the first time
//It will initialize the array of employees to a blank employee
//Index 0 of the array will instead point to the owner which cannot be
//marked for deletion. Id count is incremented each time an employee is created
constructor() public
{
    contractOwnerAddress = address(uint160(0xF187f54352ab7B807CB4966183b8d83A367f4D05));
    billingPeriod = 2 weeks;
    idCount = 1;
    totalPaid = 0;
    totalPaidBillingPeriod = 0;
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
    uint256 commissionRate) public returns (bool)
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
function deleteEmployee(uint256 adminID, uint256 idToBeDeleted) public returns(bool)
{
    bool canRun = (isAdmin(adminID) && isValid(idToBeDeleted));

    if (canRun)
    {
        idToEmployee[idToBeDeleted].isActive = false;
    }

    return (canRun);
}


/*
// plan starts at 5th return val
// FIRST INT TO CHECK FOR VALIDITY
function getProfile(uint256 id) public view returns (
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
    
} */

function getEmployeeName(uint256 access, uint256 id) public view returns (bool, string memory) {

    bool canRun = isValid(id) && ((id == access) || (isAdmin(access)));

    if (canRun) {
        return(canRun, idToEmployee[id].name);
    }

    return(false, "null");
}

function getEmployeePosition(uint256 access, uint256 id) public view returns (bool, string memory) {

    bool canRun = isValid(id) && ((id == access) || (isAdmin(access)));

    if (canRun) {
        return(canRun, idToEmployee[id].position);
    }

    return(false, "null");
}

function getEmployeeID(uint256 access, uint256 id) public view returns (bool, uint256) {

    bool canRun = isValid(id) && ((id == access) || (isAdmin(access)));

    if (canRun) {
        return(canRun, idToEmployee[id].employeeID);
    }
    return(false, 0);
}

function getEmployeePaymentAddress(uint256 access, uint256 id) public view returns (bool, address payable) {

    bool canRun = isValid(id) && ((id == access) || (isAdmin(access)));

    if (canRun) {
        return(canRun, idToEmployee[id].paymentAddress);
    }

    return(false, 0xF187f54352ab7B807CB4966183b8d83A367f4D05);
}

function getEmployeeWageType(uint256 access, uint256 id) public view returns (bool, uint8) {

    bool canRun = isValid(id) && ((id == access) || (isAdmin(access)));
    if (canRun) {
        return(canRun, idToEmployee[id].employeePlan.wageType);
    }
    return(false, 10);
}

function getEmployeeWorkerHours(uint256 access, uint256 id) public view returns (bool, uint32) {

    bool canRun = isValid(id) && ((id == access) || (isAdmin(access)));

    if (canRun) {
        return(canRun, idToEmployee[id].employeePlan.workerHours);
    }

    return(false, 1);
}

function getEmployeePayRate(uint256 access, uint256 id) public view returns (bool, uint32) {

    bool canRun = isValid(id) && ((id == access) || (isAdmin(access)));

    if (canRun) {
        return(canRun, idToEmployee[id].employeePlan.payRate);
    }

    return(false, 1);
}

function getEmployeeComissionValue(uint256 access, uint256 id) public view returns (bool, uint32) {

    bool canRun = isValid(id) && ((id == access) || (isAdmin(access)));

    if (canRun) {
        return(canRun, idToEmployee[id].employeePlan.commissionValue);
    }

    return(false, 1);
}

function getEmployeeSalary(uint256 access, uint256 id) public view returns (bool, uint128) {

    bool canRun = isValid(id) && ((id == access) || (isAdmin(access)));

    if (canRun) {
        return(canRun, idToEmployee[id].employeePlan.salary);
    }

    return(false, 1);
}

function getEmployeeComissionRate(uint256 access, uint256 id) public view returns (bool, uint256) {

    bool canRun = isValid(id) && ((id == access) || (isAdmin(access)));

    if (canRun) {
        return(canRun, idToEmployee[id].employeePlan.commissionRate);
    }

    return(false, 1);
}

function getEmployeeRole(uint256 access, uint256 id) public view returns (bool, uint8) {

    bool canRun = isValid(id) && ((id == access) || (isAdmin(access)));

    if (canRun) {
        return(canRun, idToEmployee[id].role);
    }

    return(false, 1);
}

//Returns number of active employees for JS to display
function getActiveEmployees() public view returns (uint) {
    uint count = 0;

    for (uint x = 0; x < companyRoster.length; x++) {
        if (companyRoster[x].isActive == true) {
            count++;
        }
    }
    return count;
}


//Sets a new admin given the adminID isAdmin and newId isValid
//@return function success
function setAdmin(uint256 adminID, uint256 id) public returns(bool)
{
    bool canRun = isAdmin(adminID);

    if(canRun)
    {
        if (idToEmployee[id].role == 0)
        {
            idToEmployee[id].role = 1;
        }

        else 
        {
            canRun = false;
        }
    }

    return (canRun);
}

//Removes an admin's permission from idtoBeDeleted given the adminID isAdmin
//@return function success
function removeAdmin(uint256 adminID, uint256 idtoBeDeleted) public returns(bool) {
    bool canRun = (isAdmin(adminID) && isAdmin(idtoBeDeleted) && !isOwner(idtoBeDeleted));

    if (canRun) {
        idToEmployee[idtoBeDeleted].role = 0;
    }

    return canRun;
}



//This function should never actually work in demo
//Intended to set a new owner, changing the current owner
/*
function setNewOwner(uint256 adminID, uint256 newOwner) public returns(bool)
{
    bool canRun = isValid(newOwner) && isOwner(adminID) && (adminID != newOwner);

    if (false)
    {
        idToEmployee[adminID].role = 1;
        idToEmployee[newOwner].role = 2;
        return (canRun);
    }

    return (false);

} */


//Function takes in new billing period and sets all employees to billing period
function setBillingPeriod(uint256 time, uint256 adminID) public 
{
    if (isAdmin(adminID))
    {
    billingPeriod = time;
    changeEmployeeBillingPeriod(adminID);
    }
} 

//Helper method for setBillingPeriod
function changeEmployeeBillingPeriod(uint256 adminID) public
{

    if (isAdmin(adminID))
    {
        for (uint8 a = 0; a < uint8(companyRoster.length); a++)
        {
            companyRoster[a].employeePlan.billingPeriod = billingPeriod; 
        }

    }
}


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

function resetPlan(Employee storage i) internal {
    
    // resets hourly workers
    if (i.employeePlan.wageType == 0)
    {
        i.employeePlan.workerHours = 0;
    }

    // resets commission workers
    else if (i.employeePlan.wageType == 2)
    {
        i.employeePlan.commissionValue = 0;
    }

    // reset contractor 
    if (i.employeePlan.wageType == 3)
    {
        i.employeePlan.salary = 0;
    }

}

// this function gets the total the company must pay out to its employees in the current billing period
function getCompanyPayTotal(uint256 ownerID) public returns(bool, uint256) {
    uint256 total = 0;

    bool canRun = isOwner(ownerID);

    if(canRun) {

    for (uint256 x = 0; x < companyRoster.length; x++) {
        if (companyRoster[x].isActive == true) {
            total += _calculateTotalPayment(companyRoster[x].employeePlan);
            resetPlan(companyRoster[x]);
        }
    }
    }
    return (canRun, total);
}


function pay(uint256 ownerID) public returns(bool) {
    uint256 total;
    bool bol;
    (bol, total) = getCompanyPayTotal(ownerID);
    bool canRun = (bol && (address(this).balance > total));

    if (canRun) {
        for (uint256 x = 0; x < companyRoster.length; x++) {
            bool sent = companyRoster[x].paymentAddress.send(_calculateTotalPayment(companyRoster[x].employeePlan));
            require(sent, "Failed to send Ether");
        }
    }
    return canRun;
}



//ANNOYING SET FUNCTIONS
function setName(uint256 adminID, uint256 id, string memory _name) public returns(bool)
{
    if (isAdmin(adminID) == false || isValid(id) == false)
    {
        return false;
    }

    idToEmployee[id].name = _name;
    return true;
}

function setPosition(uint256 adminID, uint256 id, string memory _position) public returns(bool)
{
    if (isAdmin(adminID) == false || isValid(id) == false)
    {
        return false;
    }

    idToEmployee[id].position = _position;
    return true;
}


function setAddress(uint256 adminID, uint256 id, address payable _paymentAddress) public returns(bool)
{
    if (isAdmin(adminID) == false || isValid(id) == false)
    {
        return false;
    }

    idToEmployee[id].paymentAddress = _paymentAddress;
    return true;
}


function setWageType(uint256 adminID, uint256 id, uint8 _wageType) public returns(bool)
{
    if (isAdmin(adminID) == false || isValid(id) == false)
    {
        return false;
    }

    idToEmployee[id].employeePlan.wageType = _wageType;
    return true;
}


function setWorkerHours(uint256 adminID, uint256 id, uint32 _workerHours) public returns(bool)
{
    if (isAdmin(adminID) == false || isValid(id) == false)
    {
        return false;
    }

    idToEmployee[id].employeePlan.workerHours = _workerHours;
    return true;
}

function setPayRate(uint256 adminID, uint256 id, uint32 _payRate) public returns(bool)
{
    if (isAdmin(adminID) == false || isValid(id) == false)
    {
        return false;
    }

    idToEmployee[id].employeePlan.payRate = _payRate;
    return true;
}

function setCommissionValue(uint256 adminID, uint256 id, uint32 _commissionValue) public returns(bool)
{
    if (isAdmin(adminID) == false || isValid(id) == false)
    {
        return false;
    }

    idToEmployee[id].employeePlan.commissionValue = _commissionValue;
    return true;
}

function setSalary(uint256 adminID, uint256 id, uint128 _salary) public returns(bool)
{
    if (isAdmin(adminID) == false || isValid(id) == false)
    {
        return false;
    }

    idToEmployee[id].employeePlan.salary = _salary;
    return true;
}

function setCommissionRate(uint256 adminID, uint256 id, uint256 _commissionRate) public returns(bool)
{
    if (isAdmin(adminID) == false || isValid(id) == false)
    {
        return false;
    }

    idToEmployee[id].employeePlan.commissionRate = _commissionRate;
    return true;
}


function getEmployeePay(uint256 user, uint256 id) view public returns (uint256, bool) {
    bool canRun = isValid(id) && ((id == user) || (isAdmin(user)));
    
    if (canRun) {
        return(_calculateTotalPayment(idToEmployee[id].employeePlan), true);
    }

    return (0, false);
}


}