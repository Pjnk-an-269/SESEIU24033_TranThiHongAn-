#ifndef BILLING_MANAGER_HPP
#define BILLING_MANAGER_HPP

#include "UtilityBill.hpp"

#include <memory>
#include <vector>

class BillingManager {
public:
    bool addBill(const std::shared_ptr<UtilityBill>& bill);
    bool hasBillID(const std::string& billID) const;
    std::vector<std::shared_ptr<UtilityBill>> getBillsForMonth(int month, int year) const;
    long long getTotalChargeForMonth(int month, int year) const;
    void printMonthlyReport(int month, int year) const;

private:
    std::vector<std::shared_ptr<UtilityBill>> bills_;
};

#endif
