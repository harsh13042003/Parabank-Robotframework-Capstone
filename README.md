# ParaBank Robot Framework Automation Capstone

## Project Overview
Automation testing framework developed for ParaBank using Robot Framework, Python, SeleniumLibrary and RequestsLibrary.

## Framework Features
- UI Testing
- API Testing
- Hybrid Testing
- Page Object Model (POM)
- Data Driven Testing
- Allure Reporting
- Screenshot Evidence
- Defect Tracking

## Tech Stack
- Robot Framework
- Python
- SeleniumLibrary
- RequestsLibrary
- Allure Report

## Test Summary
- Total Test Cases: 37
- Passed: 35
- Failed: 2
- Pass Rate: 94.59%


## 📂 Project Structure

```text
project/
├── config/                 # Environment & Browser settings (YAML)
├── pages/                  # Page Object classes mapping UI elements
├── resources/              # Common keywords, locators, and variables
├── test-data/              # JSON files containing test data
├── tests/                  # Execution suites
│   ├── 01_ui/              # Pure UI test cases (Register, Login, Transfer, etc.)
│   ├── api/                # API endpoint validations
│   ├── hybrid/             # End-to-End Hybrid (UI + API) scenarios
│   └── negative/           # Negative edge-case testing
├── log/                    # Output logs, screenshots, and Allure data
├── Jenkinsfile             # Jenkins CI/CD pipeline code
└── README.md               # You are reading it right now!



## Execution

Run all tests:

```bash
robot tests/