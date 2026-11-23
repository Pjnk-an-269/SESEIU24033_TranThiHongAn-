# Library Resource Management System — iOS App

A complete SwiftUI implementation of the Library Resource Management System design. The project targets iOS 17 or later and uses only system frameworks.

## Run the included Xcode project

1. Open `LibraryResourceManagementApp.xcodeproj` in Xcode.
2. Select the `LibraryResourceManagementApp` scheme and an iPhone simulator running iOS 17 or later.
3. Press **Run** (⌘R). No signing team or external package is required for the simulator.

The project file is configured with an iOS 17 deployment target. The six Swift source files are already included in the app target.

## Create a new project and add these files

1. In Xcode, choose **File → New → Project → iOS → App**.
2. Set **Interface** to **SwiftUI**, **Language** to **Swift**, and the deployment target to **iOS 17.0** or later.
3. Remove the generated `ContentView.swift` and generated `App` entry point from the target (or replace their contents). There must be only one `@main` app type and one `ContentView` declaration.
4. Drag the supplied `Models.swift`, `LibraryManager.swift`, `LibraryViewModel.swift`, `ContentView.swift`, `ResourceDetailView.swift`, and `LibraryEquipmentApp.swift` into the project navigator. Select **Copy items if needed** and ensure the app target is checked.
5. Choose an iOS 17+ simulator and press **Run** (⌘R).

## Source layout

- `Models.swift` defines `AccessMode`, `BookLoanCategory`, `LibraryResourceError`, the `AccessControlling` and `FeeCalculating` protocols, the `LibraryResource` base class and its three subclasses, and `ResourceSummary`.
- `LibraryManager.swift` owns the resource registry and mediates search, fee calculation, access requests, and returns.
- `LibraryViewModel.swift` provides the observable sample data and search state.
- `ContentView.swift` renders the searchable collection and status badges.
- `ResourceDetailView.swift` displays common and type-specific details, duration-based fee estimates, actions, success feedback, and validation alerts.
- `LibraryEquipmentApp.swift` is the SwiftUI application entry point.

## Sample data and fee rules

The collection contains eight resources: available standard and short-term books, a borrowed book, an in-library-only journal, a loanable journal, a digital license with free slots, a full digital license, and an expired digital license. Sample loans and digital sessions are initialized through the same validated model methods used by the buttons.

Standard books have a 14-day loan term; short-term/reference books have a 3-day term. Printed-book loans use a CU 20 refundable deposit and CU 1 per overdue day. Loanable journals use a 7-day loan term, a CU 10 refundable deposit, and CU 1.50 per overdue day. In-library journal use costs CU 0.50 per session. Digital access costs CU 0.50 per user per requested day. CU means campus currency units. Digital access requires an active license and an available licensed user slot.

## Screenshot checklist

1. **Main screen:** launch the app and capture the resource list with the visible badges, including Available, Borrowed, In-Library Only, slot count, Full, and Expired. Scroll slightly if needed to show the lower digital items.
2. **Successful borrowing and fee estimate:** open `BOOK-001 — Swift Programming: The Big Nerd Ranch Guide`, set **Requested / actual duration** to **16 days**, then capture the estimate showing a CU 20 refundable deposit, CU 2 late penalty, and CU 22 estimated total. Tap **Borrow Book** and capture the success confirmation.
3. **Rejected action:** open `JOURNAL-001 — Journal of Mobile Computing`, tap **Borrow Issue**, and capture the **Action Rejected** alert. This demonstrates the in-library-only validation. To show the other access rule instead, open `DIGITAL-003 — Digital Thesis Repository` or `DIGITAL-002 — IEEE Xplore Research Archive` and tap **Access Online**; the expired or full license is rejected with the same alert.

On the Simulator, use **File → Save Screen** (or ⌘S in Simulator) to save a screenshot. Name the files clearly, for example `01-library-list.png`, `02-fee-and-borrow-success.png`, and `03-invalid-action-alert.png`.

## Validation behavior

State-changing properties are externally read-only. `beginAccess(on:mode:)` validates the chosen access mode and availability before changing `activeAccessCount`; `endAccess()` rejects returns when no session exists. Errors conform to `LocalizedError` and are displayed in an English alert. The app uses in-memory sample data and does not connect to authentication, persistence, payment processing, or a library backend.
