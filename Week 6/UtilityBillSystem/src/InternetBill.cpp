#include "InternetBill.hpp"

#include <iostream>

InternetBill::InternetBill(const std::string& billID,
                           const std::string& customerName,
                           const std::string& customerAddress,
                           int billingMonth,
                           int billingYear)
    : UtilityBill(billID, customerName, customerAddress, billingMonth, billingYear) {
}

long long InternetBill::calculateTotalCharge() const {
    return MONTHLY_FEE;
}

std::string InternetBill::getServiceType() const {
    return "Internet";
}

void InternetBill::printDetails() const {
    UtilityBill::printDetails();
    std::cout << "Monthly subscription fee: " << MONTHLY_FEE << " VND\n";
}
