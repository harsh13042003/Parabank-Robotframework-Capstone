*** Variables ***

${LOGIN_USERNAME}         name=username
${LOGIN_PASSWORD}         name=password
${LOGIN_BUTTON}           xpath=//input[@value='Log In']

${REGISTER_LINK}          xpath=//a[text()='Register']
${OPEN_ACCOUNT_LINK}      xpath=//a[text()='Open New Account']
${TRANSFER_LINK}          xpath=//a[text()='Transfer Funds']

${ACCOUNT_TYPE_DROPDOWN}  id=type
${OPEN_NEW_ACCOUNT_BTN}   xpath=//input[@value='Open New Account']
${NEW_ACCOUNT_ID}         id=newAccountId

${TRANSFER_AMOUNT_TXT}      id=amount
${FROM_ACCOUNT_DROPDOWN}    id=fromAccountId
${TO_ACCOUNT_DROPDOWN}      id=toAccountId
${TRANSFER_BTN}             xpath=//input[@value='Transfer']