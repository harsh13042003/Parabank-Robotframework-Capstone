*** Settings ***
Library    RequestsLibrary
Library    Collections
Library    SeleniumLibrary

*** Keywords ***

Get Session Headers
    [Documentation]    Extracts the active JSESSIONID from the browser to authenticate API calls.
    ${cookie}=    Get Cookie    JSESSIONID

    ${headers}=    Create Dictionary
    ...    Cookie=JSESSIONID=${cookie.value}

    RETURN    ${headers}

Get Account Details API
    [Arguments]    ${account_id}
    [Documentation]    Fetches account details from ParaBank API using the authenticated session.

    ${headers}=    Get Session Headers

    ${response}=    GET
    ...    https://parabank.parasoft.com/parabank/services_proxy/bank/accounts/${account_id}
    ...    headers=${headers}
    ...    verify=${False}

    RETURN    ${response}

*** Keywords ***
Get Request With Auth
    [Arguments]    ${endpoint}
    Create Session    parabank_session    https://parabank.parasoft.com    disable_warnings=True
    ${response}=    GET On Session    parabank_session    ${endpoint}    expected_status=any
    RETURN    ${response}