*** Settings ***
Library  Browser

*** Variables ***
${SERVER}     localhost:5001
${DELAY}      500ms
${HOME_URL}   http://${SERVER}
${RESET_URL}  http://${SERVER}/reset_db
${BROWSER}    chromium
${HEADLESS}   false

*** Keywords ***
Open And Configure Browser
    IF  $HEADLESS == 'true'
        New Browser  browser=${BROWSER}  headless=True
    ELSE
        New Browser  browser=${BROWSER}  headless=False  slowMo=${DELAY}
    END
    New Context
    New Page  about:blank

Reset References
    Go To  ${RESET_URL}

Add Reference
    [Arguments]  ${citekey}  ${title}  ${author}  ${year}  ${publisher}
    Go To  ${HOME_URL}/add_reference
    Fill Text  [name="citekey"]  ${citekey}
    Fill Text  [name="title"]  ${title}
    Fill Text  [name="author"]  ${author}
    Fill Text  [name="year"]  ${year}
    Fill Text  [name="publisher"]  ${publisher}
    Click  button >> text=Add book
