# Vehicle Rental Management System

A Swift command-line demonstration of a vehicle rental system. It uses only the Swift standard library and Foundation.

## Run

```sh
swift run vehicle-rental
```

The demo creates five vehicles (cars, motorcycles, and an electric bicycle) and two customers. It lists fleet and customer information, rents three vehicle types, prints rental receipts and history, returns a vehicle, demonstrates contact and vehicle updates, and shows rejected rental operations.

## Design

- `Vehicle` is the shared superclass for `Car`, `Motorcycle`, and `ElectricBicycle`. `VehicleRentalSystem` stores heterogeneous vehicles and calls `rentalCostCents(forDays:)`; Swift dynamic dispatch applies the selected subtype's pricing policy.
- `Customer` stores identity and contact details plus rental IDs. `Rental` links a customer to a vehicle and records the duration, fixed cost at checkout, start date, return date, and status.
- `VehicleRentalSystem` owns the fleet, customer register, and rental records. It performs lookups, uniqueness checks, availability checks, and rental/return transitions.
- Mutable business data uses `private(set)` properties and validated update methods. The system exposes operations rather than allowing callers to set availability, pricing, or contact properties directly.

## Pricing policies

- Car: daily rate × rental days + a one-time service charge.
- Motorcycle: (daily rate + engine-category surcharge) × rental days. Categories are light (up to 150 cc, no surcharge), standard (151–500 cc, $5/day), and heavy (over 500 cc, $10/day).
- Electric bicycle: daily rate × rental days + a one-time battery service fee.

Prices are stored as integer cents to avoid floating-point currency arithmetic. Rental duration must be a positive whole number of days. The total is captured when a rental begins, so later price updates do not change its receipt.

## Main classes and relationships

| Class | Responsibility | Relationships |
| --- | --- | --- |
| `Vehicle` | Common vehicle identity, rate, and availability | Superclass of the three vehicle types |
| `Car` | Seats, service charge, car cost policy | Is a `Vehicle` |
| `Motorcycle` | Engine capacity/category and surcharge cost policy | Is a `Vehicle` |
| `ElectricBicycle` | Battery range, service fee, e-bike cost policy | Is a `Vehicle` |
| `Customer` | Customer contact information and rental references | Has many rental IDs |
| `Rental` | Rental duration, cost, status, and participating entities | References one `Customer` and one `Vehicle` |
| `VehicleRentalSystem` | Fleet, customer, and rental operations | Owns collections of vehicles, customers, and rentals |

## Requirements covered

- Vehicle add, listing, detail display, common and subtype-specific updates, and availability checks.
- Customer registration, lookup, contact updates, and rental history.
- Rental creation, positive duration validation, subtype-specific pricing, returns, status updates, and availability transitions.
- Invalid IDs, duplicate IDs, wrong vehicle types, unavailable vehicles, invalid durations, and duplicate returns produce descriptive errors.
