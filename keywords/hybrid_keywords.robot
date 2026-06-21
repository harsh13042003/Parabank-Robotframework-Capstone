*** Settings ***
Resource    ../resources/locators.robot
Library     SeleniumLibrary

*** Keywords ***

Get Account Id And Balances From UI
    Click Link    Accounts Overview
    Wait Until Element Is Visible    xpath=(//*[@id='accountTable']//tr[1]/td[1]//a)[1]    15s

    ${account_id}=    Get Text       xpath=(//*[@id='accountTable']//tr[1]/td[1]//a)[1]
    ${balance}=       Get Text       xpath=(//*[@id='accountTable']//tr[1]/td[2])[1]

    Log To Console    \nAccount ID = ${account_id}
    Log To Console    UI Balance = ${balance}

    RETURN    ${account_id}    ${balance}

Transfer Funds From Source Account
    [Arguments]    ${amount}    ${source_account}

    Sleep    3s

    Wait Until Element Is Visible    fromAccountId    15s
    Wait Until Element Is Visible    toAccountId      15s

    Select From List By Value        fromAccountId    ${source_account}

    Sleep    4s

    Select From List By Index        toAccountId      1

    Input Text                       id=amount        ${amount}

    Click Button                     xpath=//input[@value='Transfer']

    Wait Until Page Contains         Transfer Complete!    20s