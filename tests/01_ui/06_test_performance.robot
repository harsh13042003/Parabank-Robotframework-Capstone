*** Settings ***
Library    RequestsLibrary
Library    DateTime

*** Variables ***
${BASE_URL}    https://parabank.parasoft.com/parabank

*** Test Cases ***
TC-038 Verify Home Page Response Time

    Create Session    bank    ${BASE_URL}

    ${start}=    Get Current Date    result_format=epoch

    ${response}=    GET On Session    bank    /

    ${end}=    Get Current Date    result_format=epoch

    ${time}=    Evaluate    ${end}-${start}

    Log To Console    Response Time = ${time}

    Should Be Equal As Integers    ${response.status_code}    200

    Should Be True    ${time} < 2