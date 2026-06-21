*** Settings ***
Resource    ../resources/locators.robot
Library    SeleniumLibrary

*** Keywords ***

Navigate To Accounts Overview

    Click Link    Accounts Overview


Verify Account Exists In Overview

    [Arguments]    ${account_id}

    Wait Until Page Contains
    ...    ${account_id}
    ...    10s

Get Account ID From Row
    [Arguments]    ${row_number}
    Wait Until Element Is Visible    xpath=//*[@id='accountTable']/tbody/tr[${row_number}]/td[1]    timeout=10s
    ${acc_id}=    Get Text           xpath=//*[@id='accountTable']/tbody/tr[${row_number}]/td[1]
    RETURN    ${acc_id}

Get Account Balance From Row
    [Arguments]    ${row_number}
    Wait Until Element Is Visible    xpath=//*[@id='accountTable']/tbody/tr[${row_number}]/td[2]    timeout=10s
    ${balance}=    Get Text          xpath=//*[@id='accountTable']/tbody/tr[${row_number}]/td[2]
    RETURN    ${balance}

Click Account Link From Row
    [Arguments]    ${row_number}
    ${locator}=    Set Variable    xpath=//*[@id='accountTable']/tbody/tr[${row_number}]/td[1]/a
    Wait Until Element Is Visible    ${locator}    timeout=10s
    Click Element    ${locator}

Verify Account Details Page Loaded
    Wait Until Page Contains    Account Details    timeout=10s
    Wait Until Page Contains    Account Activity   timeout=10s

Click First Transaction Link
    Wait Until Element Is Visible    xpath=(//*[@id='transactionTable']/tbody/tr/td[2]/a)[1]    timeout=15s
    Click Element    xpath=(//*[@id='transactionTable']/tbody/tr/td[2]/a)[1]

