#ifndef WATER_BILL_HPP
#define WATER_BILL_HPP

#include "UtilityBill.hpp"

class WaterBill : public UtilityBill {
public:
    static constexpr long long RATE_PER_CUBIC_METER = 10000;

    WaterBill(const std::string& billID,
              const std::string& customerName,
              const std::string& customerAddress,
              int billingMonth,
              int billingYear,
              double consumptionCubicMeters);

    double getConsumptionCubicMeters() const;
    bool setConsumptionCubicMeters(double consumptionCubicMeters);

    long long calculateTotalCharge() const override;
    std::string getServiceType() const override;
    void printDetails() const override;

private:
    double consumptionCubicMeters_;
};

#endif
