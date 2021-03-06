*** Settings ***
Documentation   Test cases for bugs found
Suite Setup     Internal Suite Setup
Suite Teardown  Internal Suite Teardown
Library         SeleniumLibrary  plugins=${CURDIR}/../src/SeleniumTestability;False;80 seconds;True
Library         Timer
Resource        resources.robot

*** Test Cases ***
Verify Timeout in execute_script
  [Documentation]   WebDriverWait will fail if selenium timeout is lower then wait passed to it
  [Tags]            skipci
  Start Timer  ${TEST NAME}
  Click Element  id:longfetch-button
  Wait For Testability Ready  error_on_timeout=YES
  Stop Timer  ${TEST NAME}
  Verify Single Timer  42 seconds   40 seconds  ${TEST NAME}


Verify EventFiringWebElement conversion
  [Documentation]   WebElement != EventFiringWebElement
  [Tags]            skipci
  ${elem}=   Get WebElement    id:shorttimeout-result
  Wait Until Element Contains    ${elem}    not executed


*** Keywords ***

Internal Suite Setup
  Set Selenium Timeout      1 second
  Setup Test Environment   ${FF}    ${URL}
  ${TIMEOUT}=   Get Selenium Timeout
  Set Suite Variable    ${ORIG_TIMEOUT}     ${TIMEOUT}


Internal Suite Teardown
  [Documentation]  Final teardown
  Set Selenium Timeout      ${ORIG_TIMEOUT}
  Teardown Test Environment
