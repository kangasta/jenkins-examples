*** Settings ***
Library             OperatingSystem
Library             SeleniumLibrary
Suite Setup         Check URL and open browser
Suite Teardown      Close browser

*** Variables ***
${BROWSER}          headlesschrome
${BROWSER_OPTIONS}  ${EMPTY}
${URL}              ${EMPTY}
${WAIT_PAGE_LOAD}   5 seconds

*** Tasks ***
Capture Screenshot
    Skip if  not $URL  msg=Target URL not specified
    Go to  ${URL}
    Sleep  ${WAIT_PAGE_LOAD}
    Capture Page Screenshot

*** Keywords ***
Open browser defined by environment
    ${browser_options}=  Get Environment Variable    BROWSER_OPTIONS    ${BROWSER_OPTIONS}
    ${browser}=  Get Environment Variable    BROWSER    ${BROWSER}
    Open browser    browser=${browser}    options=${browser_options}
    Set Screenshot Directory  ${OUTPUT DIR}${/}${browser}_screenshots

Check URL and open browser
    Skip if  not $URL  msg=Target URL not specified
    Open browser defined by environment
