*** Settings ***
Resource    ../resources/locators.robot
Library     SeleniumLibrary

*** Keywords ***
Open Registration Page
    Click Link    ${REGISTER_LINK}    
    Wait Until Page Contains    Signing up is easy!    timeout=10s

Fill Registration Form
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
    ...    ${repassword}


    Input Text    id=customer.firstName         ${firstname}
    Input Text    id=customer.lastName          ${lastname}
    Input Text    id=customer.address.street    ${address}
    Input Text    id=customer.address.city      ${city}
    Input Text    id=customer.address.state     ${state}
    Input Text    id=customer.address.zipCode   ${zipcode}
    Input Text    id=customer.phoneNumber       ${phone}
    Input Text    id=customer.ssn               ${ssn}
    Input Text    id=customer.username          ${username}
    Input Text    id=customer.password          ${password}
    Input Text    id=repeatedPassword           ${repassword}

Submit Registration
    Click Button    xpath=//input[@value='Register']


Verify All Mandatory Field Errors
    Wait Until Page Contains    First name is required.    timeout=5s
    Page Should Contain    Last name is required.
    Page Should Contain    Address is required.
    Page Should Contain    City is required.
    Page Should Contain    State is required.
    Page Should Contain    Zip Code is required.
    Page Should Contain    Social Security Number is required.
    Page Should Contain    Username is required.
    Page Should Contain    Password is required.