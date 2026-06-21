*** Settings ***
Resource    ../resources/locators.robot
Library     SeleniumLibrary

*** Keywords ***
Login To ParaBank
    [Arguments]    ${username}    ${password}

    Input Text      ${LOGIN_USERNAME}    ${username}
    Input Password  ${LOGIN_PASSWORD}    ${password}
    Click Button    ${LOGIN_BUTTON}