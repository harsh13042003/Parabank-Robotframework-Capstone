*** Settings ***
Resource    ../../resources/common.robot
Resource    ../../resources/variables.robot
Resource    ../../pages/LoginPage.robot
Resource    ../../pages/TransferPage.robot
Resource    ../../pages/AccountOverviewPage.robot
Resource    ../../pages/OpenAccountPage.robot

Library     OperatingSystem
Library     Collections

Test Setup       Open ParaBank Browser
Test Teardown    Close ParaBank Browser

*** Keywords ***
Get Transaction Data
    [Arguments]    ${tc_id}
    ${json_file}=    Get File    ${EXECDIR}/test-data/transaction.json
    ${all_data}=     Evaluate    json.loads('''${json_file}''')    json
    RETURN    ${all_data['${tc_id}']}

*** Test Cases ***

TC-020 Verify Transaction Appears After Fund Transfer
    [Documentation]    Verifies that a successful transfer appears in the account activity.
    [Tags]             @positive    @transaction    @ui

    ${data}=    Get Transaction Data    TC-020
    Login To ParaBank    ${USERNAME}    ${PASSWORD}
    Navigate To Open Account Page
    Create Checking Account

    Navigate To Transfer Funds Page
    Transfer Funds Successfully    ${data['amount']}

    Navigate To Accounts Overview
    Click Account Link From Row    1
    Verify Account Details Page Loaded
    Wait Until Page Contains    Transactions    timeout=10s

TC-021 Verify Transaction Details Page Displays Correct Information
    [Documentation]    Verifies that all required fields are present on the transaction details page.
    [Tags]             @positive    @transaction    @ui

    ${data}=    Get Transaction Data    TC-021
    Login To ParaBank    ${USERNAME}    ${PASSWORD}
    Navigate To Open Account Page
    Create Checking Account

    Navigate To Transfer Funds Page
    Transfer Funds Successfully    100

    Navigate To Accounts Overview
    Click Account Link From Row    1
    Verify Account Details Page Loaded
    Click First Transaction Link
    Verify Transaction Details Page Loaded

    FOR    ${label}    IN    @{data['labels']}
        Verify Transaction Information Present    ${label}
    END

TC-022 Verify Debit Transaction Type Is Displayed Correctly
    [Documentation]    Verifies the transaction type shows Debit appropriately.
    [Tags]             @positive    @transaction    @ui

    ${data}=    Get Transaction Data    TC-022
    Login To ParaBank    ${USERNAME}    ${PASSWORD}
    Navigate To Open Account Page
    Create Checking Account
    Navigate To Transfer Funds Page
    Transfer Funds Successfully    100

    Navigate To Accounts Overview
    Click Account Link From Row    1
    Click First Transaction Link
    Verify Transaction Details Page Loaded
    Verify Transaction Information Present    ${data['expected_type']}

TC-023 Verify Transaction Amount Is Displayed Correctly
    [Documentation]    Verifies the transaction details show the exact expected amount.
    [Tags]             @positive    @transaction    @ui

    ${data}=    Get Transaction Data    TC-023
    Login To ParaBank    ${USERNAME}    ${PASSWORD}
    Navigate To Open Account Page
    Create Checking Account

    Navigate To Accounts Overview
    Click Account Link From Row    1
    Click First Transaction Link
    Verify Transaction Details Page Loaded
    Verify Transaction Information Present    ${data['expected_amount']}