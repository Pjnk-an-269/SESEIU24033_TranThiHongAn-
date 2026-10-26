#include "BillingManager.hpp"

#include <iostream>
#include <stdexcept>

bool BillingManager::addBill(const std::shared_ptr<UtilityBill>& bill) {
    if (!bill || hasBillID(bill->getBillID())) {
        return false;
    }
    bills_.push_back(bill);
    return true;
}

bool BillingManager::hasBillID(const std::string& billID) const {
    for (const auto& bill : bills_) {
        if (bill->getBillID() == billID) {
            return true;
        }
    }
    return false;
}

std::vector<std::shared_ptr<UtilityBill>> BillingManager::getBillsForMonth(int month, int year) const {
    std::vector<std::shared_ptr<UtilityBill>> monthlyBills;
    for (const auto& bill : bills_) {
        if (bill->getBillingMonth() == month && bill->getBillingYear() == year) {
            monthlyBills.push_back(bill);
        }
    }
    return monthlyBills;
}

long long BillingManager::getTotalChargeForMonth(int month, int year) const {
    long long total = 0;
    for (const auto& bill : getBillsForMonth(month, year)) {
        total += bill->calculateTotalCharge();
    }
    return total;
}

void BillingManager::printMonthlyReport(int month, int year) const {
    if (month < 1 || month > 12 || year < 1) {
        throw std::invalid_argument("Invalid billing period.");
    }

    const auto monthlyBills = getBillsForMonth(month, year);
    std::cout << "\n========== MONTHLY UTILITY BILL REPORT ==========" << '\n'
              << "Billing period: " << month << '/' << year << '\n'
              << "Number of bills: " << monthlyBills.size() << "\n\n";

    if (monthlyBills.empty()) {
        std::cout << "No bills found for this period.\n";
    } else {
        for (const auto& bill : monthlyBills) {
            bill->printDetails();
            std::cout << "-----------------------------------------------\n";
        }
    }

    std::cout << "Grand total: " << getTotalChargeForMonth(month, year) << " VND\n"
              << "=================================================\n";
}
