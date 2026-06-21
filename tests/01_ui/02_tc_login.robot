*** Settings ***
Resource    ../../resources/common.robot
Resource    ../../resources/variables.robot
Resource    ../../pages/LoginPage.robot
Resource    ../../pages/RegisterPage.robot
Resource    ../../keywords/ui_keywords.robot
Library     OperatingSystem

Test Setup       Open ParaBank Browser
Test Teardown    Close ParaBank Browser

*** Keywords ***
Get Login Data
    [Arguments]    ${tc_id}
    ${json_file}=    Get File    ${EXECDIR}/test-data/login.json
    ${all_data}=     Evaluate    json.loads('''${json_file}''')    json
    RETURN    ${all_data['${tc_id}']}

*** Test Cases ***

TC-005 Verify Login With Valid Credentials
    [Documentation]    Creates a dynamic user, logs out, and verifies login success with new credentials.
    [Tags]             @positive    @login    @ui

    ${data}=    Get Login Data    TC-005
    ${dynamic_username}    ${dynamic_ssn}=    Generate Dynamic User Data

    Open Registration Page
    Fill Registration Form
    ...    ${data['fname']}    ${data['lname']}    ${data['street']}
    ...    ${data['city']}     ${data['state']}    ${data['zip']}
    ...    ${data['phone']}    ${dynamic_ssn}      ${dynamic_username}
    ...    ${data['password']}    ${data['password']}
    Submit Registration
    Wait Until Page Contains    Your account was created successfully.    timeout=10s
    Click Link    xpath=//a[text()='Log Out']
    Sleep    1s

    Login To ParaBank    ${dynamic_username}    ${data['password']}
    Wait Until Page Contains    ${data['expected']}    timeout=10s

TC-006 Verify Login With Invalid Credentials
    [Documentation]    Verifies that the system rejects invalid usernames or passwords.
    [Tags]             @negative    @login    @ui

    ${data}=    Get Login Data    TC-006
    Login To ParaBank    ${data['username']}    ${data['password']}
    Wait Until Page Contains    ${data['expected']}    timeout=10s

TC-007 Verify Login With Blank Username
    [Documentation]    Verifies error message when attempting to log in without a username.
    [Tags]             @negative    @login    @ui

    ${data}=    Get Login Data    TC-007
    Login To ParaBank    ${EMPTY}    ${data['password']}
    Wait Until Page Contains    ${data['expected']}    timeout=10s

TC-008 Verify Login With Blank Password
    [Documentation]    Verifies error message when attempting to log in without a password.
    [Tags]             @negative    @login    @ui

    ${data}=    Get Login Data    TC-008
    Login To ParaBank    ${data['username']}    ${EMPTY}
    Wait Until Page Contains    ${data['expected']}    timeout=10s