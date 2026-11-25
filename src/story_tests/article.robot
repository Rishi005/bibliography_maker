*** Settings ***
Resource  resource.robot
Suite Setup      Open And Configure Browser
Suite Teardown   Close Browser
Test Setup       Reset References

*** Test Cases ***
Article form displays all article fields
    Go To  ${HOME_URL}/add_reference?entry_type=article
    Get Element Count  input[name="citekey"]  ==  1
    Get Element Count  input[name="author"]  ==  1
    Get Element Count  input[name="title"]  ==  1
    Get Element Count  input[name="year"]  ==  1
    Get Element Count  input[name="journal"]  ==  1
    Get Element Count  input[name="volume"]  ==  1
    Get Element Count  input[name="pages"]  ==  1
    Get Element Count  input[name="publisher"]  ==  0

Submitting an article reference saves it
    Go To  ${HOME_URL}/add_reference?entry_type=article
    Fill Text  [name="citekey"]  RobotArticle01
    Fill Text  [name="author"]  Article Author
    Fill Text  [name="title"]  Saved Article
    Fill Text  [name="year"]  2024
    Fill Text  [name="journal"]  Test Journal
    Fill Text  [name="volume"]  12
    Fill Text  [name="pages"]  34-45
    Click  button >> text=Save
    Get Url  ==  ${HOME_URL}/
    Get Text  body  *=  RobotArticle01
    Get Text  body  *=  Saved Article

Submitted article reference can be viewed on the app
    Go To  ${HOME_URL}/add_reference?entry_type=article
    Fill Text  [name="citekey"]  RobotArticleView01
    Fill Text  [name="author"]  Viewed Article Author
    Fill Text  [name="title"]  Viewed Article
    Fill Text  [name="year"]  2025
    Fill Text  [name="journal"]  View Journal
    Fill Text  [name="volume"]  7
    Fill Text  [name="pages"]  100-112
    Click  button >> text=Save
    Go To  ${HOME_URL}
    Get Text  body  *=  RobotArticleView01
    Get Text  body  *=  article
    Get Text  body  *=  Viewed Article Author
    Get Text  body  *=  Viewed Article
    Get Text  body  *=  2025
    Get Text  body  *=  Journal: View Journal
    Get Text  body  *=  Volume: 7
    Get Text  body  *=  Pages: 100-112

Adding the same article twice does not create a duplicate
    Add Article  RobotArticleDuplicate01  Duplicate Article  Duplicate Author  2024  Duplicate Journal  1  1-10
    Add Article  RobotArticleDuplicate01  Duplicate Article  Duplicate Author  2024  Duplicate Journal  1  1-10
    Go To  ${HOME_URL}
    Get Element Count  li  ==  1
    Get Element Count  li strong  ==  1
    Get Text  body  *=  RobotArticleDuplicate01

Adding two different articles saves and displays both
    Add Article  RobotArticleDifferent01  First Article  First Article Author  2024  First Journal  1  1-10
    Add Article  RobotArticleDifferent02  Second Article  Second Article Author  2025  Second Journal  2  11-20
    Go To  ${HOME_URL}
    Get Element Count  li  ==  2
    Get Text  body  *=  RobotArticleDifferent01
    Get Text  body  *=  First Article
    Get Text  body  *=  RobotArticleDifferent02
    Get Text  body  *=  Second Article

*** Keywords ***
Add Article
    [Arguments]  ${citekey}  ${title}  ${author}  ${year}  ${journal}  ${volume}  ${pages}
    Go To  ${HOME_URL}/add_reference?entry_type=article
    Fill Text  [name="citekey"]  ${citekey}
    Fill Text  [name="author"]  ${author}
    Fill Text  [name="title"]  ${title}
    Fill Text  [name="year"]  ${year}
    Fill Text  [name="journal"]  ${journal}
    Fill Text  [name="volume"]  ${volume}
    Fill Text  [name="pages"]  ${pages}
    Click  button >> text=Save
