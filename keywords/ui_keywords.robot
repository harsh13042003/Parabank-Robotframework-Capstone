*** Settings ***

Resource    ../pages/LoginPage.robot
Resource    ../pages/RegisterPage.robot
Resource    ../pages/OpenAccountPage.robot
Resource    ../pages/TransferPage.robot
Library     String

*** Keywords ***

User Login

    [Arguments]    ${username}    ${password}

    Login To ParaBank    ${username}    ${password}


User Registration

    [Arguments]
    ...    ${firstname}
    ...    ${lastname}
    ...    ${address}
    ...    ${city}
    ...    ${state}
    ...    ${zipcode}
    ...    ${phone}
    ...    ${ssn}
    ...    ${username}
    ...    ${password}

    Open Registration Page

    Fill Registration Form
    ...    ${firstname}
    ...    ${lastname}
    ...    ${address}
    ...    ${city}
    ...    ${state}
    ...    ${zipcode}
    ...    ${phone}
    ...    ${ssn}
    ...    ${username}
    ...    ${password}

    Submit Registration


Create New Checking Account

    Navigate To Open Account Page

    Create Checking Account

Create New Savings Account

    Navigate To Open Account Page

    Create Savings Account


Transfer Amount

    [Arguments]    ${amount}

    Navigate To Transfer Funds Page

    Transfer Funds Successfully    ${amount}

Generate Dynamic User Data
    [Documentation]    Utility keyword to generate random username and SSN for registration.
    ${random_num}=          Generate Random String    4    [NUMBERS]
    ${dynamic_username}=    Set Variable    harsh${random_num}
    ${dynamic_ssn}=         Set Variable    12345${random_num}

    RETURN    ${dynamic_username}    ${dynamic_ssn}