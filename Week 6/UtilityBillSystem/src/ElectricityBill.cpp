#include "ElectricityBill.hpp"

#include <cmath>
#include <iostream>
#include <stdexcept>

ElectricityBill::ElectricityBill(const std::string& billID,
                                 const std::string& customerName,
                                 const std::string& customerAddress,
                                 int billingMonth,
                                 int billingYear,
                                 double consumptionKWh)
    : UtilityBill(billID, customerName, customerAddress, billingMonth, billingYear),
      consumptionKWh_(0.0) {
    if (!setConsumptionKWh(consumptionKWh)) {
        throw std::invalid_argument("Electricity consumption cannot be negative.");
    }
}

double ElectricityBill::getConsumptionKWh() const {
    return consumptionKWh_;
}

bool ElectricityBill::setConsumptionKWh(double consumptionKWh) {
    if (consumptionKWh < 0.0 || !std::isfinite(consumptionKWh)) {
        return false;
    }
    consumptionKWh_ = consumptionKWh;
    return true;
}

long long ElectricityBill::calculateTotalCharge() const {
    return static_cast<long long>(std::llround(consumptionKWh_ * RATE_PER_KWH));
}

std::string ElectricityBill::getServiceType() const {
    return "Electricity";
}

void ElectricityBill::printDetails() const {
    UtilityBill::printDetails();
    std::cout << "Consumption: " << consumptionKWh_ << " kWh\n"
              << "Rate: " << RATE_PER_KWH << " VND/kWh\n";
}
