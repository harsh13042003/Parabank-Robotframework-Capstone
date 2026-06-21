*** Settings ***
Resource    ../resources/locators.robot
Library     SeleniumLibrary

*** Keywords ***
Navigate To Transfer Funds Page

    Wait Until Element Is Visible    ${TRANSFER_LINK}    timeout=10s
    Click Link    ${TRANSFER_LINK}
    Sleep    4s
    Wait Until Element Is Visible    ${FROM_ACCOUNT_DROPDOWN}    timeout=15s

Select Accounts For Transfer
    Sleep    2s
    [Arguments]    ${from_index}    ${to_index}

    Wait Until Element Is Visible    ${FROM_ACCOUNT_DROPDOWN}    timeout=10s
    Select From List By Index        ${FROM_ACCOUNT_DROPDOWN}    ${from_index}
    Sleep    4s
    Wait Until Element Is Visible    ${TO_ACCOUNT_DROPDOWN}      timeout=10s
    Select From List By Index        ${TO_ACCOUNT_DROPDOWN}      ${to_index}

Select Accounts For Transfer By Value
    [Arguments]    ${from_value}    ${to_index}
    Sleep    4s
    Select From List By Value    ${FROM_ACCOUNT_DROPDOWN}    ${from_value}

    Wait Until Element Is Visible    ${TO_ACCOUNT_DROPDOWN}      timeout=10s
    Select From List By Index        ${TO_ACCOUNT_DROPDOWN}      ${to_index}

Click Transfer Button
    Wait Until Element Is Enabled    ${TRANSFER_BTN}    timeout=10s
    Click Button    ${TRANSFER_BTN}

Transfer Funds Successfully
    [Arguments]    ${amount}

    Wait Until Element Is Visible    ${TRANSFER_AMOUNT_TXT}    timeout=10s
    Input Text      ${TRANSFER_AMOUNT_TXT}    ${amount}


    Click Transfer Button
    Sleep    2s

Verify Transfer Success Message
    [Arguments]    ${expected_message}
    Wait Until Page Contains    ${expected_message}    timeout=20s

Select Accounts For Destination By Value
    [Arguments]    ${from_index}    ${to_value}

    Wait Until Element Is Visible    ${FROM_ACCOUNT_DROPDOWN}    timeout=10s
    Select From List By Index        ${FROM_ACCOUNT_DROPDOWN}    ${from_index}
    Sleep    4s
    Select From List By Value    ${TO_ACCOUNT_DROPDOWN}    ${to_value}


Verify Transaction Details Page Loaded
    Wait Until Page Contains    Transaction Details    timeout=10s

Verify Transaction Information Present
    [Arguments]    ${expected_text}
    Page Should Contain    ${expected_text}

Enter Transfer Amount
    [Arguments]    ${amount}
    Wait Until Element Is Visible    ${TRANSFER_AMOUNT_TXT}    timeout=10s
    Input Text                       ${TRANSFER_AMOUNT_TXT}    ${amount}

Select Same Account For Transfer

    Wait Until Element Is Visible    ${FROM_ACCOUNT_DROPDOWN}    timeout=15s


    Select From List By Index        ${FROM_ACCOUNT_DROPDOWN}    0
    ${account}=    Get Selected List Value    ${FROM_ACCOUNT_DROPDOWN}
    Sleep    4s
    Wait Until Element Is Visible    ${TO_ACCOUNT_DROPDOWN}      timeout=10s
    Wait Until Keyword Succeeds      5x    1s    Select From List By Value    ${TO_ACCOUNT_DROPDOWN}    ${account}

    RETURN    ${account}

Verify Transfer Successful
    [Arguments]    ${amount}
    Wait Until Page Contains    Transfer Complete!    timeout=10s
    Page Should Contain         has been transferred
    Page Should Contain         ${amount}