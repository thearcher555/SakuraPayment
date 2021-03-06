//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.5.16;

//Contract to handle the payment of an employee
contract SakuraPlan
{


//Structure to hold information to calculate payment of an employee
struct Plan
{
    // 0 = Hourly 
    // 1 = Salarieds
    // 2 = Comission
    // 3 = Contactor
    uint8 wageType;
    uint32 workerHours;
    uint32 payRate;
    uint32 commissionValue;
    uint128 salary;
    uint256 commissionRate;
    uint256 billingPeriod;
}


//Function to calculate amount due to employee at end of billing period
//@param _employeePlan 
//@returns paymentAmount
function _calculateTotalPayment(Plan storage _employeePlan) view internal returns(uint256)
{

    uint256 paymentAmount;

    if (_employeePlan.wageType == 0)
    {
        paymentAmount = uint256(_employeePlan.workerHours * _employeePlan.payRate);
    }

    else if (_employeePlan.wageType == 1)
    {
        paymentAmount = uint256((_employeePlan.billingPeriod/31536000)*_employeePlan.salary);
    }

    else if (_employeePlan.wageType == 2)
    {
        paymentAmount = uint256(((_employeePlan.billingPeriod/31536000)*_employeePlan.salary) + (_employeePlan.commissionValue * _employeePlan.commissionRate));
    }

    else if (_employeePlan.wageType == 3)
    {
        paymentAmount = uint256(_employeePlan.salary);
    }


return paymentAmount;

}


/** 
Function to calculate the net payment of an employee
@param _employeePlan
@returns paymentToEmployee, paymentForTax, paymentForSavings, paymentForBenefits
function _calculateNetPayment(Plan memory _employeePlan) pure internal returns(uint128,uint128,uint128,uint128)
{
    uint128 netPayment = _calculateTotalPayment(_employeePlan);
} **/

}