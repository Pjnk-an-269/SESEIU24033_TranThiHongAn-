#ifndef INTERNET_BILL_HPP
#define INTERNET_BILL_HPP

#include "UtilityBill.hpp"

class InternetBill : public UtilityBill {
public:
    static constexpr long long MONTHLY_FEE = 200000;

    InternetBill(const std::string& billID,
                 const std::string& customerName,
                 const std::string& customerAddress,
                 int billingMonth,
                 int billingYear);

    long long calculateTotalCharge() const override;
    std::string getServiceType() const override;
    void printDetails() const override;
};

#endif
