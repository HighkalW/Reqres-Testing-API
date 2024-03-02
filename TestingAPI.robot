*** Settings ***
Library           RequestsLibrary
Library           Collections

*** Variables ***
${BASE_URL}            https://reqres.in
${CREATE_USER_ENDPOINT}    /api/users
${HEADERS}             Content-Type=application/json

*** Test Cases ***
Positive Case: Create User
    [Documentation]    Test creating a user with valid data
    ${user_data}=    Create Dictionary    name=John    job=developer
    ${response}=    Post Request    ${BASE_URL}${CREATE_USER_ENDPOINT}    data=${user_data}    headers=${HEADERS}
    Check Response    ${response}    201
    Validate User ID    ${response}

Negative Case: Missing Request Body Fields
    [Documentation]    Test creating a user with missing required fields
    ${response}=    Post Request    ${BASE_URL}${CREATE_USER_ENDPOINT}    data={}    headers=${HEADERS}
    Check Response    ${response}    400
    ${error_message}=    Get Error Message    ${response}
    Should Contain    ${error_message}    name
    Should Contain    ${error_message}    job

Negative Case: Missing Response
    [Documentation]    Test expecting a response that does not match the actual response
    ${response}=    Post Request    ${BASE_URL}${CREATE_USER_ENDPOINT}    data={"name": "John", "job": "developer"}    headers=${HEADERS}
    Check Response    ${response}    500

Negative Case: Response Not Equals with Request
    [Documentation]    Test expecting a response that does not match the request data
    ${response}=    Post Request    ${BASE_URL}${CREATE_USER_ENDPOINT}    data={"name": "John", "job": "developer"}    headers=${HEADERS}
    ${response_id}=    Get Response Attribute    ${response}    id
    ${response_name}=    Get Response Attribute    ${response}    name
    Should Not Be Equal    ${response_name}    John
    Should Not Be Equal    ${response_id}    123  # Assuming 123 is a fake ID

*** Keywords ***
Create User
    [Arguments]    ${url}    ${data}
    ${headers}=    Create Dictionary    Content-Type    application/json
    ${response}=    Post Request    ${url}    data=${data}    headers=${headers}
    [Return]    ${response}

Check Response
    [Arguments]    ${response}    ${expected_status_code}
    Should Be Equal As Numbers    ${response.status_code}    ${expected_status_code}

Get Error Message
    [Arguments]    ${response}
    ${json_response}=    To JSON    ${response.content}
    ${error_message}=    Get From Dictionary    ${json_response}    error
    [Return]    ${error_message}

Get Response Attribute
    [Arguments]    ${response}    ${attribute}
    ${json_response}=    To JSON    ${response.content}
    ${value}=    Get From Dictionary    ${json_response}    ${attribute}
    [Return]    ${value}

Validate User ID
    [Arguments]    ${response}
    ${json_response}=    To JSON    ${response.content}
    Dictionary Should Contain Key    ${json_response}    id
