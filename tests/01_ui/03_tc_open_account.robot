*** Settings ***
Resource    ../../resources/common.robot
Resource    ../../resources/variables.robot
Resource    ../../pages/LoginPage.robot
Resource    ../../pages/AccountOverviewPage.robot
Resource    ../../pages/OpenAccountPage.robot
Library     OperatingSystem

Test Setup       Open ParaBank Browser
Test Teardown    Close ParaBank Browser

*** Keywords ***
Get Open Account Data
    [Arguments]    ${tc_id}
    ${json_file}=    Get File    ${EXECDIR}/test-data/open_account.json
    ${all_data}=     Evaluate    json.loads('''${json_file}''')    json
    RETURN    ${all_data['${tc_id}']}

*** Test Cases ***

TC-009 Verify Creation Of CHECKING Account
    [Documentation]    Verifies that a user can successfully open a CHECKING account.
    [Tags]             @positive    @openaccount    @ui

    ${data}=    Get Open Account Data    TC-009
    Login To ParaBank    ${USERNAME}    ${PASSWORD}

    Navigate To Open Account Page
    Create Checking Account

    Wait Until Page Contains    ${data['expected_message']}    timeout=10s

TC-010 Verify Creation Of SAVINGS Account
    [Documentation]    Verifies that a user can successfully open a SAVINGS account.
    [Tags]             @positive    @openaccount    @ui

    ${data}=    Get Open Account Data    TC-010
    Login To ParaBank    ${USERNAME}    ${PASSWORD}

    Navigate To Open Account Page
    Create Savings Account

    Wait Until Page Contains    ${data['expected_message']}    timeout=10s

TC-011 Verify Account Number Generation After Account Creation
    [Documentation]    Verifies that a valid account ID is generated upon account creation.
    [Tags]             @positive    @openaccount    @ui

    Login To ParaBank    ${USERNAME}    ${PASSWORD}
    Navigate To Open Account Page
    Create Checking Account

    ${account_id}=    Get New Account ID
    Should Not Be Empty    ${account_id}

TC-012 Verify Account Appears In Accounts Overview
    [Documentation]    Verifies that the newly created account is listed in the Accounts Overview page.
    [Tags]             @positive    @openaccount    @ui    @e2e

    Login To ParaBank    ${USERNAME}    ${PASSWORD}
    Navigate To Open Account Page
    Create Checking Account

    ${account_id}=    Get New Account ID
    Navigate To Accounts Overview

    Verify Account Exists In Overview    ${account_id}

TC-034 Verify Account Opened Page Elements after account creation
    [Documentation]    Verifies that the success message and account ID are visible after opening an account.
    [Tags]             @positive    @ui

    Login To ParaBank    ${USERNAME}    ${PASSWORD}
    Navigate To Open Account Page
    Create Checking Account

    Verify Account Opened Successfully