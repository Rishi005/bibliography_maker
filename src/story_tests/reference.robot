*** Settings ***
Resource  resource.robot
Suite Setup      Open And Configure Browser
Suite Teardown   Close Browser
Test Setup       Reset References

*** Test Cases ***
Submitting a reference saves and displays it
    Go To   ${HOME_URL}/add_reference?entry_type=book
    Fill Text   [name="citekey"]    RobotTest01
    Fill Text   [name="title"]  Test Book
    Fill Text   [name="author"]  Test Author
    Fill Text   [name="year"]   2017
    Fill Text   [name="publisher"]  Test Publisher
    Click  button >> text=Save
    Get Text  body  *=  RobotTest01
    

Empty inputs are denied
    Go To  ${HOME_URL}/add_reference?entry_type=book
    Click       button >> text=Save
    Get Element Count    input:invalid    ==    4


Empty reference list is shown when there are no references
    Go To  ${HOME_URL}
    Get Text  body  *=  No references found.

Added references are listed on the front page
    Add Reference  RobotView01  First Book  First Author  2001  First Publisher
    Add Reference  RobotView02  Second Book  Second Author  2002  Second Publisher
    Go To  ${HOME_URL}
    Get Text  body  *=  RobotView01
    Get Text  body  *=  First Book
    Get Text  body  *=  First Author
    Get Text  body  *=  2001
    Get Text  body  *=  First Publisher
    Get Text  body  *=  RobotView02
    Get Text  body  *=  Second Book
    Get Element Count  li  ==  2

Front page has a link to the add reference form
    Go To  ${HOME_URL}
    Click  a >> text=Add a new reference
    Get Url  ==  ${HOME_URL}/add_reference

Cancel on the type selection page returns to the front page
    Go To  ${HOME_URL}/add_reference
    Click  a >> text=Cancel
    Get Url  ==  ${HOME_URL}/
    Get Text  body  *=  No references found.

Cancel on the reference form returns to the front page without saving
    Go To  ${HOME_URL}/add_reference?entry_type=book
    Fill Text  [name="citekey"]  RobotCancel01
    Fill Text  [name="title"]  Cancelled Book
    Fill Text  [name="author"]  Cancel Author
    Fill Text  [name="year"]  2020
    Fill Text  [name="publisher"]  Cancel Publisher
    Click  a >> text=Cancel
    Get Url  ==  ${HOME_URL}/
    Get Text  body  *=  No references found.
