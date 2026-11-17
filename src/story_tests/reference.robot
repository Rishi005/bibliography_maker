*** Settings ***
Resource  resource.robot
Suite Setup      Open And Configure Browser
Suite Teardown   Close Browser
Test Setup       Reset References

*** Test Cases ***
Submitting a reference saves and displays it
    Go To   ${HOME_URL}/add_reference
    Fill Text   [name="citekey"]    RobotTest01
    Fill Text   [name="title"]  Test Book
    Fill Text   [name="author"] Test Author
    Fill Text   [name="year"]   2017
    Fill Text   [name="publisher"]  Test Publisher
    Click  button >> text=Add book
    #Wont go through yet as we cant see the references, but can fix later
    Get Text  body  *=  RobotTest01
    

Empty inputs are denied
    Go To  ${HOME_URL}/add_reference
    Click       button >> text=Add book
    Get Element Count    input:invalid    ==    5
