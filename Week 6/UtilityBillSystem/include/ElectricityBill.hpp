#ifndef ELECTRICITY_BILL_HPP
#define ELECTRICITY_BILL_HPP

#include "UtilityBill.hpp"

class ElectricityBill : public UtilityBill {
public:
    static constexpr long long RATE_PER_KWH = 2500;

    ElectricityBill(const std::string& billID,
                    const std::string& customerName,
                    const std::string& customerAddress,
                    int billingMonth,
                    int billingYear,
                    double consumptionKWh);

    double getConsumptionKWh() const;
    bool setConsumptionKWh(double consumptionKWh);

    long long calculateTotalCharge() const override;
    std::string getServiceType() const override;
    void printDetails() const override;

private:
    double consumptionKWh_;
};

#endif
