cmake_minimum_required(VERSION 3.16)

project(UtilityBillSystem VERSION 1.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

add_executable(utility_bill_system
    main.cpp
    src/UtilityBill.cpp
    src/ElectricityBill.cpp
    src/WaterBill.cpp
    src/InternetBill.cpp
    src/BillingManager.cpp
)

target_include_directories(utility_bill_system PRIVATE include)

target_compile_options(utility_bill_system PRIVATE
    $<$<CXX_COMPILER_ID:GNU,Clang,AppleClang>:-Wall -Wextra -Wpedantic>
)
