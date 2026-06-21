*** Settings ***
Resource    ../../resources/common.robot
Resource    ../../pages/RegisterPage.robot
Resource    ../../keywords/ui_keywords.robot
Library     OperatingSystem

Test Setup       Open ParaBank Browser
Test Teardown    Close ParaBank Browser

*** Keywords ***
Get Register Data
    [Arguments]    ${tc_id}
    ${json_file}=    Get File    ${EXECDIR}/test-data/register.json
    ${all_data}=     Evaluate    json.loads('''${json_file}''')    json
    RETURN    ${all_data['${tc_id}']}

*** Test Cases ***
TC-001 Verify User Registration With Valid Details
    [Documentation]    Verifies successful registration with dynamic valid data from JSON.
    [Tags]             @registration    @positive    @ui    @smoke

    ${data}=    Get Register Data    TC-001

    ${dynamic_username}    ${dynamic_ssn}=    Generate Dynamic User Data

    Open Registration Page

    Fill Registration Form
    ...    ${data['fname']}    ${data['lname']}    ${data['street']}
    ...    ${data['city']}     ${data['state']}    ${data['zip']}
    ...    ${data['phone']}    ${dynamic_ssn}      ${dynamic_username}
    ...    ${data['password']}    ${data['confirm']}

    Submit Registration
    Wait Until Page Contains    ${data['expected']}    timeout=10s

TC-002 Verify Registration With Mandatory Fields Left Blank
    [Documentation]    Verifies that system throws error when required fields are blank.
    [Tags]             @registration    @negative    @ui

    Open Registration Page
    Submit Registration
    Verify All Mandatory Field Errors

TC-003 Verify Registration With Mismatched Password And Confirm Password
    [Documentation]    Verifies error when password and confirm password do not match from JSON.
    [Tags]             @registration    @negative    @ui


    ${data}=    Get Register Data    TC-003
    ${dynamic_username}    ${dynamic_ssn}=    Generate Dynamic User Data

    Open Registration Page

    Fill Registration Form
    ...    ${data['fname']}    ${data['lname']}    ${data['street']}
    ...    ${data['city']}     ${data['state']}    ${data['zip']}
    ...    ${data['phone']}    ${dynamic_ssn}      ${dynamic_username}
    ...    ${data['password']}    ${data['confirm']}

    Submit Registration
    Wait Until Page Contains    ${data['expected']}    timeout=10s


TC-004 Verify Registration Fails With Already Existing Username
    [Documentation]    Verifies that a user cannot register with a username that is already taken.
    [Tags]             @negative    @registration

    ${data}=    Get Register Data    TC-004
    ${dynamic_username}    ${dynamic_ssn}=    Generate Dynamic User Data

    Open Registration Page
    Fill Registration Form
    ...    ${data['fname']}    ${data['lname']}    ${data['street']}
    ...    ${data['city']}     ${data['state']}    ${data['zip']}
    ...    ${data['phone']}    ${dynamic_ssn}      ${dynamic_username}
    ...    ${data['password']}    ${data['confirm']}
    Submit Registration

    Wait Until Page Contains    Your account was created successfully.    15s

    Click Link    xpath=//a[text()='Log Out']
    Sleep    1s

    Open Registration Page
    Fill Registration Form
    ...    ${data['fname']}    ${data['lname']}    ${data['street']}
    ...    ${data['city']}     ${data['state']}    ${data['zip']}
    ...    ${data['phone']}    ${dynamic_ssn}      ${dynamic_username}
    ...    ${data['password']}    ${data['confirm']}
    Submit Registration

