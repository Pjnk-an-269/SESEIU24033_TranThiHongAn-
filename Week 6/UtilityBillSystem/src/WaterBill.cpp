#include "WaterBill.hpp"

#include <cmath>
#include <iostream>
#include <stdexcept>

WaterBill::WaterBill(const std::string& billID,
                     const std::string& customerName,
                     const std::string& customerAddress,
                     int billingMonth,
                     int billingYear,
                     double consumptionCubicMeters)
    : UtilityBill(billID, customerName, customerAddress, billingMonth, billingYear),
      consumptionCubicMeters_(0.0) {
    if (!setConsumptionCubicMeters(consumptionCubicMeters)) {
        throw std::invalid_argument("Water consumption cannot be negative.");
    }
}

double WaterBill::getConsumptionCubicMeters() const {
    return consumptionCubicMeters_;
}

bool WaterBill::setConsumptionCubicMeters(double consumptionCubicMeters) {
    if (consumptionCubicMeters < 0.0 || !std::isfinite(consumptionCubicMeters)) {
        return false;
    }
    consumptionCubicMeters_ = consumptionCubicMeters;
    return true;
}

long long WaterBill::calculateTotalCharge() const {
    return static_cast<long long>(std::llround(consumptionCubicMeters_ * RATE_PER_CUBIC_METER));
}

std::string WaterBill::getServiceType() const {
    return "Water";
}

void WaterBill::printDetails() const {
    UtilityBill::printDetails();
    std::cout << "Consumption: " << consumptionCubicMeters_ << " m3\n"
              << "Rate: " << RATE_PER_CUBIC_METER << " VND/m3\n";
}
