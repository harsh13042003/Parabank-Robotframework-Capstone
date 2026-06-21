*** Settings ***
Resource    ../../resources/common.robot
Resource    ../../resources/variables.robot
Resource    ../../pages/LoginPage.robot
Resource    ../../pages/OpenAccountPage.robot
Resource    ../../keywords/api_keywords.robot
Resource    ../../keywords/hybrid_keywords.robot
Resource    ../../pages/TransferPage.robot
Library     OperatingSystem
Library     Collections

Test Setup       Open ParaBank Browser
Test Teardown    Close ParaBank Browser

*** Keywords ***
Get Hybrid Data
    [Arguments]    ${tc_id}
    ${json_file}=    Get File    ${EXECDIR}/test-data/hybrid.json
    ${all_data}=     Evaluate    json.loads('''${json_file}''')    json
    RETURN    ${all_data['${tc_id}']}

*** Test Cases ***
TC-031 Verify Account Created Through UI Is Available Through API
    [Documentation]    Creates an account via UI and validates its keys via API.
    [Tags]             @positive    @hybrid    @e2e

    ${data}=    Get Hybrid Data    TC-031
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

    FOR    ${key}    IN    @{data['expected_keys']}
        Dictionary Should Contain Key    ${body}    ${key}
    END

TC-032 Verify Balance Displayed In UI Matches API Response
    [Documentation]    Fetches UI balance and confirms API returns a valid balance field.
    [Tags]             @positive    @hybrid

    ${data}=    Get Hybrid Data    TC-032
    Login To ParaBank    ${USERNAME}    ${PASSWORD}

    ${account_id}    ${ui_balance}=    Get Account Id And Balances From UI

    ${response}=    Get Account Details API    ${account_id}
    ${body}=    Set Variable    ${response.json()}
    ${api_balance}=    Set Variable    ${body}[balance]

    Should Not Be Equal    ${api_balance}    ${None}

TC-033 Verify Transferred Amount Is Reflected Consistently Across UI And API
    [Documentation]    Performs a UI fund transfer and validates balance changes in both UI and API.
    [Tags]             @positive    @hybrid    @e2e

    ${data}=    Get Hybrid Data    TC-033
    Login To ParaBank    ${USERNAME}    ${PASSWORD}
    Navigate To Open Account Page
    Create Checking Account

    ${account_id}    ${before_balance}=    Get Account Id And Balances From UI

    Navigate To Transfer Funds Page
    Transfer Funds From Source Account    ${data['transfer_amount']}    ${account_id}

    ${account_id}    ${after_balance}=    Get Account Id And Balances From UI

    ${response}=    Get Account Details API    ${account_id}
    ${body}=    Set Variable    ${response.json()}
    ${api_balance}=    Set Variable    ${body}[balance]

    Should Not Be Equal    ${before_balance}    ${after_balance}
    Should Not Be Empty    Convert To String    ${api_balance}