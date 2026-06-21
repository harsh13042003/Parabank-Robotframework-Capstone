*** Settings ***
Resource    ../../resources/common.robot
Resource    ../../resources/variables.robot
Resource    ../../pages/LoginPage.robot
Resource    ../../pages/OpenAccountPage.robot
Resource    ../../pages/AccountOverviewPage.robot
Resource    ../../keywords/api_keywords.robot
Resource    ../../resources/locators.robot
Library     OperatingSystem
Library     Collections

Test Setup       Open ParaBank Browser
Test Teardown    Close ParaBank Browser

*** Keywords ***
Get API Validation Data
    [Arguments]    ${tc_id}
    ${json_file}=    Get File    ${EXECDIR}/test-data/api_validation.json
    ${all_data}=     Evaluate    json.loads('''${json_file}''')    json
    RETURN    ${all_data['${tc_id}']}

*** Test Cases ***

TC-024 Verify Account Details Returned By API
    [Documentation]    Fetches account ID from UI and validates its details via API.
    [Tags]             @positive    @api    @hybrid

    ${data}=    Get API Validation Data    TC-024
    Login To ParaBank    ${USERNAME}    ${PASSWORD}

    Navigate To Accounts Overview
    ${account_id}=    Get Account ID From Row    1

    ${response}=    Get Account Details API    ${account_id}
    Should Be Equal As Integers    ${response.status_code}    ${data['status_code']}

    ${body}=    Set Variable    ${response.json()}

    FOR    ${key}    IN    @{data['expected_keys']}
        Dictionary Should Contain Key    ${body}    ${key}
    END

    ${api_id}=    Convert To Integer    ${body}[id]
    ${ui_id}=     Convert To Integer    ${account_id}
    Should Be Equal As Integers    ${api_id}    ${ui_id}

TC-025 Verify Newly Created Account Exists In API Response
    [Documentation]    Creates an account in UI and verifies its existence via API.
    [Tags]             @positive    @api    @hybrid

    ${data}=    Get API Validation Data    TC-025
    Login To ParaBank    ${USERNAME}    ${PASSWORD}

    Navigate To Open Account Page
    Create Checking Account
    ${account_id}=    Get New Account ID

    ${response}=    Get Account Details API    ${account_id}
    Should Be Equal As Integers    ${response.status_code}    ${data['status_code']}

    ${body}=    Set Variable    ${response.json()}
    ${api_id}=    Convert To Integer    ${body}[id]
    ${ui_id}=     Convert To Integer    ${account_id}
    Should Be Equal As Integers    ${api_id}    ${ui_id}

TC-026 Verify Account Type Returned By API
    [Documentation]    Validates the account type created via UI matches API response.
    [Tags]             @positive    @api    @hybrid

    ${data}=    Get API Validation Data    TC-026
    Login To ParaBank    ${USERNAME}    ${PASSWORD}

    Navigate To Open Account Page
    Create Checking Account
    ${account_id}=    Get New Account ID

    ${response}=    Get Account Details API    ${account_id}
    ${body}=    Set Variable    ${response.json()}
    Should Be Equal    ${body}[type]    ${data['expected_type']}

TC-027 Verify Account Details Format For Newly Created Account
    [Documentation]    Verifies API response schema for a newly created account.
    [Tags]             @positive    @api    @hybrid

    ${data}=    Get API Validation Data    TC-027
    Login To ParaBank    ${USERNAME}    ${PASSWORD}

    Navigate To Open Account Page
    Create Checking Account
    ${account_id}=    Get New Account ID

    ${response}=    Get Account Details API    ${account_id}
    ${body}=    Set Variable    ${response.json()}

    FOR    ${key}    IN    @{data['expected_keys']}
        Dictionary Should Contain Key    ${body}    ${key}
    END

TC-028 Verify Account Balance Through API
    [Documentation]    Verifies that the API returns a valid balance format.
    [Tags]             @positive    @api    @hybrid

    ${data}=    Get API Validation Data    TC-028
    Login To ParaBank    ${USERNAME}    ${PASSWORD}

    Navigate To Accounts Overview
    ${account_id}=    Get Account ID From Row    1

    ${response}=    Get Account Details API    ${account_id}
    ${body}=    Set Variable    ${response.json()}

    ${api_balance}=    Set Variable    ${body}[balance]
    Should Not Be Equal    ${api_balance}    ${None}

TC-029 Verify API Response Status Code
    [Documentation]    Strictly validates the HTTP status code of the endpoint.
    [Tags]             @positive    @api

    ${data}=    Get API Validation Data    TC-029
    Login To ParaBank    ${USERNAME}    ${PASSWORD}

    Navigate To Accounts Overview
    ${account_id}=    Get Account ID From Row    1

    ${response}=    Get Account Details API    ${account_id}
    Should Be Equal As Integers    ${response.status_code}    ${data['expected_status']}

TC-030 Verify API Response Time Is Within Acceptable Limit
    [Documentation]    Performance check for the Account Details API.
    [Tags]             @positive    @api    @performance

    ${data}=    Get API Validation Data    TC-030
    Login To ParaBank    ${USERNAME}    ${PASSWORD}

    Navigate To Accounts Overview
    ${account_id}=    Get Account ID From Row    1

    ${response}=    Get Account Details API    ${account_id}
    ${response_time}=    Set Variable    ${response.elapsed.total_seconds()}

    Should Be True    ${response_time} < ${data['max_time_seconds']}

    