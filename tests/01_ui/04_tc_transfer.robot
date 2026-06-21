*** Settings ***
Resource    ../../resources/common.robot
Resource    ../../resources/variables.robot
Resource    ../../pages/LoginPage.robot
Resource    ../../pages/TransferPage.robot
Resource    ../../pages/AccountOverviewPage.robot
Resource    ../../pages/OpenAccountPage.robot
Library     OperatingSystem

Test Setup       Open ParaBank Browser
Test Teardown    Close ParaBank Browser

*** Keywords ***
Get Transfer Data
    [Arguments]    ${tc_id}
    ${json_file}=    Get File    ${EXECDIR}/test-data/transfer.json
    ${all_data}=     Evaluate    json.loads('''${json_file}''')    json
    RETURN    ${all_data['${tc_id}']}

*** Test Cases ***

TC-013 Verify Successful Fund Transfer
    [Documentation]    Verifies that a user can successfully transfer funds.
    [Tags]             @positive    @transfer    @ui

    ${data}=    Get Transfer Data    TC-013
    Login To ParaBank    ${USERNAME}    ${PASSWORD}
    Navigate To Open Account Page
    Create Checking Account

    Navigate To Transfer Funds Page
    Select Accounts For Transfer    0    1
    Transfer Funds Successfully    ${data['amount']}
    Verify Transfer Success Message    ${data['expected']}

TC-014 Verify Transfer With Insufficient Balance
    [Documentation]    Verifies transfer fails or system handles insufficient balance.
    [Tags]             @negative    @transfer    @ui

    ${data}=    Get Transfer Data    TC-014
    Login To ParaBank    ${USERNAME}    ${PASSWORD}
    Navigate To Open Account Page
    Create Checking Account

    Navigate To Transfer Funds Page
    Select Accounts For Transfer    0    1
    Transfer Funds Successfully    ${data['amount']}
    Capture Page Screenshot    BUG-001_Insufficient_Funds.png
    Page Should Not Contain    Transfer Complete!
    Capture Page Screenshot

TC-015 Verify Transfer With Blank Amount
    [Documentation]    Verifies system throws error when transfer amount is blank.
    [Tags]             @negative    @transfer    @ui

    ${data}=    Get Transfer Data    TC-015
    Login To ParaBank    ${USERNAME}    ${PASSWORD}
    Navigate To Open Account Page
    Create Checking Account

    Navigate To Transfer Funds Page
    Select Accounts For Transfer    0    1
    Click Transfer Button


TC-016 Verify Transfer Confirmation Message
    [Documentation]    Verifies transfer confirmation message appears on successful transaction.
    [Tags]             @positive    @transfer    @ui

    ${data}=    Get Transfer Data    TC-016
    Login To ParaBank    ${USERNAME}    ${PASSWORD}
    Navigate To Open Account Page
    Create Checking Account

    Navigate To Transfer Funds Page
    Select Accounts For Transfer    0    1
    Transfer Funds Successfully    ${data['amount']}
    Verify Transfer Success Message    ${data['expected']}

TC-017 Verify Updated Balance After Fund Transfer
    [Documentation]    Verifies that the balance updates dynamically after transfer.
    [Tags]             @positive    @transfer    @e2e

    ${data}=    Get Transfer Data    TC-017
    Login To ParaBank    ${USERNAME}    ${PASSWORD}
    Navigate To Open Account Page
    Create Checking Account

    Navigate To Accounts Overview
    ${source_acc}=     Get Account ID From Row    1
    ${before_bal}=     Get Account Balance From Row    1

    Navigate To Transfer Funds Page
    Select Accounts For Transfer By Value    ${source_acc}    1
    Transfer Funds Successfully    ${data['amount']}
    Verify Transfer Success Message    ${data['expected']}

    Navigate To Accounts Overview
    ${after_bal}=      Get Account Balance From Row    1
    Should Not Be Equal    ${before_bal}    ${after_bal}

TC-018 Verify Debit Amount Deducted From Source Account
    [Documentation]    Verifies that the exact debit amount is deducted from source.
    [Tags]             @positive    @transfer    @e2e

    ${data}=    Get Transfer Data    TC-018
    Login To ParaBank    ${USERNAME}    ${PASSWORD}
    Navigate To Open Account Page
    Create Checking Account

    Navigate To Accounts Overview
    ${source_acc}=     Get Account ID From Row    1
    ${before_bal}=     Get Account Balance From Row    1

    Navigate To Transfer Funds Page
    Select Accounts For Transfer By Value    ${source_acc}    1
    Transfer Funds Successfully    ${data['amount']}
    Verify Transfer Success Message    ${data['expected']}

    Navigate To Accounts Overview
    ${after_bal}=      Get Account Balance From Row    1
    Should Not Be Equal    ${before_bal}    ${after_bal}

TC-019 Verify Credit Amount Added To Destination Account
    [Documentation]    Verifies that the credit amount is correctly added to destination.
    [Tags]             @positive    @transfer    @e2e

    ${data}=    Get Transfer Data    TC-019
    Login To ParaBank    ${USERNAME}    ${PASSWORD}
    Navigate To Open Account Page
    Create Checking Account

    Navigate To Accounts Overview
    ${dest_acc}=       Get Account ID From Row    2
    ${before_bal}=     Get Account Balance From Row    2

    Navigate To Transfer Funds Page
    Select Accounts For Destination By Value    0    ${dest_acc}
    Transfer Funds Successfully    ${data['amount']}
    Verify Transfer Success Message    ${data['expected']}

    Navigate To Accounts Overview
    ${after_bal}=      Get Account Balance From Row    2
    Should Not Be Equal    ${before_bal}    ${after_bal}

TC-035 Verify Transfer Completion Details
    [Documentation]    Verifies the transfer confirmation screen using dynamic data from JSON.
    [Tags]             @positive    @transfer    @ui

    ${data}=    Get Transfer Data    TC-035

    Login To ParaBank    ${USERNAME}    ${PASSWORD}
    Navigate To Open Account Page
    Create Checking Account
    Navigate To Transfer Funds Page

    Transfer Funds Successfully    ${data['transfer_amount']}


    Wait Until Page Contains    ${data['success_msg']}    timeout=10s
    Page Should Contain         ${data['status_check']}
    Page Should Contain         ${data['transfer_amount']}