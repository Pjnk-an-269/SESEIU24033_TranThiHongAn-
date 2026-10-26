#include "BillingManager.hpp"
#include "ElectricityBill.hpp"
#include "InternetBill.hpp"
#include "WaterBill.hpp"

#include <cmath>
#include <iostream>
#include <limits>
#include <memory>
#include <stdexcept>
#include <string>

namespace {

void clearInputError() {
    std::cin.clear();
    std::cin.ignore(std::numeric_limits<std::streamsize>::max(), '\n');
}

int readInt(const std::string& prompt) {
    int value;
    while (true) {
        std::cout << prompt;
        if (std::cin >> value) {
            std::cin.ignore(std::numeric_limits<std::streamsize>::max(), '\n');
            return value;
        }
        std::cout << "Please enter a whole number.\n";
        clearInputError();
    }
}

double readNonNegativeDouble(const std::string& prompt, const std::string& unit) {
    double value;
    while (true) {
        std::cout << prompt;
        if (std::cin >> value && std::isfinite(value) && value >= 0.0) {
            std::cin.ignore(std::numeric_limits<std::streamsize>::max(), '\n');
            return value;
        }
        std::cout << "Consumption must be a non-negative number in " << unit << ".\n";
        clearInputError();
    }
}

std::string readNonEmptyLine(const std::string& prompt) {
    std::string value;
    while (true) {
        std::cout << prompt;
        std::getline(std::cin, value);
        if (!value.empty()) {
            return value;
        }
        std::cout << "This field cannot be empty.\n";
    }
}

void readCommonBillData(std::string& billID,
                        std::string& customerName,
                        std::string& customerAddress,
                        int& billingMonth,
                        int& billingYear) {
    billID = readNonEmptyLine("Bill ID: ");
    customerName = readNonEmptyLine("Customer name: ");
    customerAddress = readNonEmptyLine("Customer address: ");

    do {
        billingMonth = readInt("Billing month (1-12): ");
        if (billingMonth < 1 || billingMonth > 12) {
            std::cout << "Billing month must be from 1 to 12.\n";
        }
    } while (billingMonth < 1 || billingMonth > 12);

    do {
        billingYear = readInt("Billing year: ");
        if (billingYear < 1) {
            std::cout << "Billing year must be positive.\n";
        }
    } while (billingYear < 1);
}

void addElectricityBill(BillingManager& manager) {
    std::string billID, customerName, customerAddress;
    int month, year;
    readCommonBillData(billID, customerName, customerAddress, month, year);
    const double consumption = readNonNegativeDouble("Electricity consumption (kWh): ", "kWh");

    const auto bill = std::make_shared<ElectricityBill>(
        billID, customerName, customerAddress, month, year, consumption);
    std::cout << (manager.addBill(bill) ? "Electricity bill added successfully.\n"
                                        : "A bill with this ID already exists.\n");
}

void addWaterBill(BillingManager& manager) {
    std::string billID, customerName, customerAddress;
    int month, year;
    readCommonBillData(billID, customerName, customerAddress, month, year);
    const double consumption = readNonNegativeDouble("Water consumption (m3): ", "m3");

    const auto bill = std::make_shared<WaterBill>(
        billID, customerName, customerAddress, month, year, consumption);
    std::cout << (manager.addBill(bill) ? "Water bill added successfully.\n"
                                        : "A bill with this ID already exists.\n");
}

void addInternetBill(BillingManager& manager) {
    std::string billID, customerName, customerAddress;
    int month, year;
    readCommonBillData(billID, customerName, customerAddress, month, year);

    const auto bill = std::make_shared<InternetBill>(
        billID, customerName, customerAddress, month, year);
    std::cout << (manager.addBill(bill) ? "Internet bill added successfully.\n"
                                        : "A bill with this ID already exists.\n");
}

void printMenu() {
    std::cout << "\n========== UTILITY BILL MANAGEMENT SYSTEM ==========\n"
              << "1. Add Electricity Bill\n"
              << "2. Add Water Bill\n"
              << "3. Add Internet Bill\n"
              << "4. Print Monthly Report\n"
              << "0. Exit\n"
              << "=====================================================\n";
}

} // namespace

int main() {
    BillingManager manager;
    int choice;

    do {
        printMenu();
        choice = readInt("Choose an option: ");

        try {
            switch (choice) {
                case 1:
                    addElectricityBill(manager);
                    break;
                case 2:
                    addWaterBill(manager);
                    break;
                case 3:
                    addInternetBill(manager);
                    break;
                case 4: {
                    const int month = readInt("Report month (1-12): ");
                    const int year = readInt("Report year: ");
                    manager.printMonthlyReport(month, year);
                    break;
                }
                case 0:
                    std::cout << "Goodbye!\n";
                    break;
                default:
                    std::cout << "Invalid option. Please choose from 0 to 4.\n";
                    break;
            }
        } catch (const std::exception& exception) {
            std::cout << "Error: " << exception.what() << '\n';
        }
    } while (choice != 0);

    return 0;
}
