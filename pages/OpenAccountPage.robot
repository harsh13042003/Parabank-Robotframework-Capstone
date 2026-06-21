*** Settings ***
Resource    ../resources/locators.robot
Library     SeleniumLibrary

*** Keywords ***
Navigate To Open Account Page
    Sleep    4s
    Click Link    ${OPEN_ACCOUNT_LINK}
    Wait Until Element Is Visible    ${ACCOUNT_TYPE_DROPDOWN}    timeout=15s

Create Checking Account
    Wait Until Element Is Visible    ${ACCOUNT_TYPE_DROPDOWN}    timeout=15s
    Select From List By Value        ${ACCOUNT_TYPE_DROPDOWN}    0

    ${selected}=    Get Selected List Value    ${ACCOUNT_TYPE_DROPDOWN}
    Sleep    4s
    Click Button    ${OPEN_NEW_ACCOUNT_BTN}
    Sleep    2s

    Wait Until Page Contains         Account Opened!             timeout=20s
    Wait Until Element Is Visible    ${NEW_ACCOUNT_ID}           timeout=20s

Create Savings Account
    Wait Until Element Is Visible    ${ACCOUNT_TYPE_DROPDOWN}    timeout=15s
    Select From List By Value        ${ACCOUNT_TYPE_DROPDOWN}    1
    Sleep    4s
    Click Button    ${OPEN_NEW_ACCOUNT_BTN}

    Wait Until Page Contains         Account Opened!             timeout=20s
    Wait Until Element Is Visible    ${NEW_ACCOUNT_ID}           timeout=20s

Get New Account ID
    Wait Until Element Is Visible    ${NEW_ACCOUNT_ID}           timeout=20s

    ${account_id}=    Get Text       ${NEW_ACCOUNT_ID}

    RETURN    ${account_id}

Verify Account Opened Successfully
    Wait Until Page Contains    Account Opened!    timeout=10s
    Element Should Be Visible    id=newAccountId
    Page Should Contain          Congratulations, your account is now open.