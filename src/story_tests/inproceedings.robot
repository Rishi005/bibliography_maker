*** Settings ***
Resource  resource.robot
Suite Setup      Open And Configure Browser
Suite Teardown   Close Browser
Test Setup       Reset References

*** Test Cases ***
Inproceedings form displays all inproceedings fields
    Go To  ${HOME_URL}/add_reference?entry_type=inproceedings
    Get Element Count  input[name="citekey"]  ==  1
    Get Element Count  input[name="author"]  ==  1
    Get Element Count  input[name="title"]  ==  1
    Get Element Count  input[name="year"]  ==  1
    Get Element Count  input[name="booktitle"]  ==  1
    Get Element Count  input[name="editor"]  ==  1
    Get Element Count  input[name="pages"]  ==  1
    Get Element Count  input[name="publisher"]  ==  1
    Get Element Count  input[name="journal"]  ==  0

Submitting an inproceedings reference saves it
    Add Inproceedings  RobotInproceedings01  Saved Inproceedings  Proceedings Author  2024  Test Conference  Conference Editor  10-20  Test Publisher
    Get Url  ==  ${HOME_URL}/
    Get Text  body  *=  RobotInproceedings01
    Get Text  body  *=  Saved Inproceedings

Submitted inproceedings reference can be viewed on the app
    Add Inproceedings  RobotInproceedingsView01  Viewed Inproceedings  Viewed Proceedings Author  2025  View Conference  View Editor  30-40  View Publisher
    Go To  ${HOME_URL}
    Get Text  body  *=  RobotInproceedingsView01
    Get Text  body  *=  inproceedings
    Get Text  body  *=  Viewed Proceedings Author
    Get Text  body  *=  Viewed Inproceedings
    Get Text  body  *=  2025
    Get Text  body  *=  Booktitle: View Conference
    Get Text  body  *=  Editor: View Editor
    Get Text  body  *=  Pages: 30-40
    Get Text  body  *=  Publisher: View Publisher

Adding the same inproceedings reference twice does not create a duplicate
    Add Inproceedings  RobotInproceedingsDuplicate01  Duplicate Inproceedings  Duplicate Proceedings Author  2024  Duplicate Conference  Duplicate Editor  1-10  Duplicate Publisher
    Add Inproceedings  RobotInproceedingsDuplicate01  Duplicate Inproceedings  Duplicate Proceedings Author  2024  Duplicate Conference  Duplicate Editor  1-10  Duplicate Publisher
    Go To  ${HOME_URL}
    Get Element Count  li  ==  1
    Get Element Count  li strong  ==  1
    Get Text  body  *=  RobotInproceedingsDuplicate01

Adding two different inproceedings references saves and displays both
    Add Inproceedings  RobotInproceedingsDifferent01  First Inproceedings  First Proceedings Author  2024  First Conference  First Editor  1-10  First Publisher
    Add Inproceedings  RobotInproceedingsDifferent02  Second Inproceedings  Second Proceedings Author  2025  Second Conference  Second Editor  11-20  Second Publisher
    Go To  ${HOME_URL}
    Get Element Count  li  ==  2
    Get Text  body  *=  RobotInproceedingsDifferent01
    Get Text  body  *=  First Inproceedings
    Get Text  body  *=  RobotInproceedingsDifferent02
    Get Text  body  *=  Second Inproceedings

*** Keywords ***
Add Inproceedings
    [Arguments]  ${citekey}  ${title}  ${author}  ${year}  ${booktitle}  ${editor}  ${pages}  ${publisher}
    Go To  ${HOME_URL}/add_reference?entry_type=inproceedings
    Fill Text  [name="citekey"]  ${citekey}
    Fill Text  [name="author"]  ${author}
    Fill Text  [name="title"]  ${title}
    Fill Text  [name="year"]  ${year}
    Fill Text  [name="booktitle"]  ${booktitle}
    Fill Text  [name="editor"]  ${editor}
    Fill Text  [name="pages"]  ${pages}
    Fill Text  [name="publisher"]  ${publisher}
    Click  button >> text=Save
