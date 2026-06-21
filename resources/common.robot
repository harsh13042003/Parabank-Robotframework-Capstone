*** Settings ***
Library    SeleniumLibrary
Resource   variables.robot

*** Keywords ***
Open ParaBank Browser
    Open Browser    ${BASE_URL}    ${BROWSER}
    Maximize Browser Window
    Set Selenium Timeout    20s

Close ParaBank Browser
    Close Browser