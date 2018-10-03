*** Settings ***
Library         SeleniumLibrary
Library         DateTime
Test Setup      Setup Browser and Selenium
Test Teardown   Close Browser


*** Variables ***
${URL}        http://localhost:5000
${BROWSER}    Firefox
${TIMEOUT}    4.0

*** Keywords ***
Setup Browser and Selenium
  Set Selenium Timeout        15 seconds
  Open Browser                ${URL}    browser=${BROWSER}
  Instrument Browser

Instrument Browser
  Execute Javascript          instrumentBrowser(window)

Wait For Testability Ready
  Sleep                       0.05 seconds
  Log To Console              Wait For Testability Ready: Waiting
  Execute Async Javascript    var cb = arguments[arguments.length - 1]; window.testability.when.ready(function() {cb()});
  Log To Console              Wait For Testability Ready: Done

Click And Verify
  [Arguments]   ${id}    ${duration}
  Log To Console              Click ${id}
  ${start}=   Get Time        epoch
  Click Element               id:${id}
  Wait For Testability Ready
  ${end}=   Get Time        epoch
  ${diff}=  Subtract Date From Date   ${end}  ${start}
  Should Be True              not ${diff} < ${duration}

*** Test Cases ***
Test Fetch
  Click And Verify            fetch-button          ${TIMEOUT}

Test Timeout
  Click And Verify            shorttimeout-button   ${TIMEOUT}

Test XHR
  Click and Verify            xhr-button            ${TIMEOUT}

Test transition
  Click and Verify            transition-button     ${TIMEOUT}

Test Animation
  Click and Verify            animate-button        ${TIMEOUT}