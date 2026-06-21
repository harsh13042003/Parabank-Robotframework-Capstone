*** Settings ***
Resource    ../../resources/common.robot
Resource    ../../resources/variables.robot
Resource    ../../pages/LoginPage.robot
Resource    ../../pages/TransferPage.robot
Library     OperatingSystem
Library     Collections

Test Setup       Open ParaBank Browser
Test Teardown    Close ParaBank Browser

*** Keywords ***
Get Negative Data
    [Arguments]    ${tc_id}
    ${json_file}=    Get File    ${EXECDIR}/test-data/negative.json
    ${all_data}=     Evaluate    json.loads('''${json_file}''')    json
    RETURN    ${all_data['${tc_id}']}

*** Test Cases ***

TC-036 Verify Application Behavior With Invalid Inputs
    [Documentation]    Verifies system throws an internal error for invalid amount formats.
    [Tags]             @negative    @transfer    @ui

    ${data}=    Get Negative Data    TC-036
    Login To ParaBank    ${USERNAME}    ${PASSWORD}

    Navigate To Transfer Funds Page

    Enter Transfer Amount    ${data['invalid_amount']}
    Click Transfer Button

    Wait Until Page Contains    ${data['error_msg_1']}    timeout=10s
    Page Should Contain         ${data['error_msg_2']}

TC-037 Verify Transfer Between Same Source And Destination Account
    [Documentation]    Verifies application behavior (or defect) when transferring to the same account.
    [Tags]             @negative    @transfer    @ui

    ${data}=    Get Negative Data    TC-037
    Login To ParaBank    ${USERNAME}    ${PASSWORD}

    Navigate To Transfer Funds Page

    ${account}=    Select Same Account For Transfer

    Enter Transfer Amount    ${data['amount']}
    Click Transfer Button

    Wait Until Page Contains    from account #${account}        timeout=10s
    Wait Until Page Contains    to account #${account}          timeout=10s
    Capture Page Screenshot    BUG-002_transfer_Between_Same_Account_Funds.png
    Wait Until Page Contains    ${data['success_msg']}          timeout=20s
