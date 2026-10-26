#include "UtilityBill.hpp"

#include <iomanip>
#include <iostream>
#include <stdexcept>

UtilityBill::UtilityBill(const std::string& billID,
                         const std::string& customerName,
                         const std::string& customerAddress,
                         int billingMonth,
                         int billingYear)
    : billingMonth_(1), billingYear_(1) {
    if (!setBillID(billID) || !setCustomerName(customerName) ||
        !setCustomerAddress(customerAddress) || !updateBillingPeriod(billingMonth, billingYear)) {
        throw std::invalid_argument("Invalid common bill information.");
    }
}

const std::string& UtilityBill::getBillID() const {
    return billID_;
}

const std::string& UtilityBill::getCustomerName() const {
    return customerName_;
}

const std::string& UtilityBill::getCustomerAddress() const {
    return customerAddress_;
}

int UtilityBill::getBillingMonth() const {
    return billingMonth_;
}

int UtilityBill::getBillingYear() const {
    return billingYear_;
}

bool UtilityBill::setBillID(const std::string& billID) {
    if (!isValidText(billID)) {
        return false;
    }
    billID_ = billID;
    return true;
}

bool UtilityBill::setCustomerName(const std::string& customerName) {
    if (!isValidText(customerName)) {
        return false;
    }
    customerName_ = customerName;
    return true;
}

bool UtilityBill::setCustomerAddress(const std::string& customerAddress) {
    if (!isValidText(customerAddress)) {
        return false;
    }
    customerAddress_ = customerAddress;
    return true;
}

bool UtilityBill::setBillingMonth(int billingMonth) {
    if (!isValidMonth(billingMonth)) {
        return false;
    }
    billingMonth_ = billingMonth;
    return true;
}

bool UtilityBill::setBillingYear(int billingYear) {
    if (!isValidYear(billingYear)) {
        return false;
    }
    billingYear_ = billingYear;
    return true;
}

bool UtilityBill::updateBillingPeriod(int billingMonth, int billingYear) {
    if (!isValidMonth(billingMonth) || !isValidYear(billingYear)) {
        return false;
    }
    billingMonth_ = billingMonth;
    billingYear_ = billingYear;
    return true;
}

void UtilityBill::printDetails() const {
    std::cout << "Bill ID: " << billID_ << '\n'
              << "Service: " << getServiceType() << '\n'
              << "Customer: " << customerName_ << '\n'
              << "Address: " << customerAddress_ << '\n'
              << "Billing period: " << billingMonth_ << '/' << billingYear_ << '\n'
              << "Total charge: " << calculateTotalCharge() << " VND\n";
}

bool UtilityBill::isValidText(const std::string& value) {
    return !value.empty();
}

bool UtilityBill::isValidMonth(int month) {
    return month >= 1 && month <= 12;
}

bool UtilityBill::isValidYear(int year) {
    return year >= 1;
}
