#ifndef UTILITY_BILL_HPP
#define UTILITY_BILL_HPP

#include <string>

/**
 * Abstract base class for all utility bills.
 *
 * Common information is stored here while derived classes provide their own
 * charge calculation and service name.
 */
class UtilityBill {
public:
    UtilityBill(const std::string& billID,
                const std::string& customerName,
                const std::string& customerAddress,
                int billingMonth,
                int billingYear);
    virtual ~UtilityBill() = default;

    const std::string& getBillID() const;
    const std::string& getCustomerName() const;
    const std::string& getCustomerAddress() const;
    int getBillingMonth() const;
    int getBillingYear() const;

    bool setBillID(const std::string& billID);
    bool setCustomerName(const std::string& customerName);
    bool setCustomerAddress(const std::string& customerAddress);
    bool setBillingMonth(int billingMonth);
    bool setBillingYear(int billingYear);
    bool updateBillingPeriod(int billingMonth, int billingYear);

    virtual long long calculateTotalCharge() const = 0;
    virtual std::string getServiceType() const = 0;
    virtual void printDetails() const;

protected:
    static bool isValidText(const std::string& value);
    static bool isValidMonth(int month);
    static bool isValidYear(int year);

private:
    std::string billID_;
    std::string customerName_;
    std::string customerAddress_;
    int billingMonth_;
    int billingYear_;
};

#endif
