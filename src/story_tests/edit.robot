*** Settings ***
Resource  resource.robot
Suite Setup      Open And Configure Browser
Suite Teardown   Close Browser
Test Setup       Reset References

*** Test Cases ***
Edit link is shown for each reference
    Add Reference  RobotEditLink  Book Title  Book Author  2001  Book Publisher
    Go To  ${HOME_URL}
    Get Element Count  li >> a >> text=Edit  ==  1

Edit page is prefilled with the book values
    Add Reference  RobotEditPrefill  Original Title  Original Author  2010  Original Publisher
    Go To  ${HOME_URL}
    Click  li >> a >> text=Edit
    Get Url  *=  /edit_reference/
    Get Property  [name="citekey"]  value  ==  RobotEditPrefill
    Get Property  [name="title"]  value  ==  Original Title
    Get Property  [name="author"]  value  ==  Original Author
    Get Property  [name="year"]  value  ==  2010
    Get Property  [name="publisher"]  value  ==  Original Publisher

Editing a book updates it on the front page
    Add Reference  RobotEditBook  Original Title  Original Author  2010  Original Publisher
    Go To  ${HOME_URL}
    Click  li >> a >> text=Edit
    Fill Text  [name="title"]  Updated Title
    Fill Text  [name="publisher"]  Updated Publisher
    Click  button >> text=Save
    Get Url  ==  ${HOME_URL}/
    Get Text  body  *=  Updated Title
    Get Text  body  *=  Updated Publisher
    ${body}=  Get Text  body
    Should Not Contain  ${body}  Original Title

Edit page does not allow changing the entry type
    Add Reference  RobotEditType  Some Title  Some Author  2000  Some Publisher
    Go To  ${HOME_URL}
    Click  li >> a >> text=Edit
    Get Element Count  select[name="entry_type"]  ==  0
    Click  button >> text=Save
    Get Text  body  *=  (book)

Edit page is prefilled for article-specific fields
    Add Article  RobotEditArticle  Article Title  Article Author  2020  Original Journal  5  10-20
    Go To  ${HOME_URL}
    Click  li >> a >> text=Edit
    Get Property  [name="journal"]  value  ==  Original Journal
    Get Property  [name="volume"]  value  ==  5
    Get Property  [name="pages"]  value  ==  10-20
    Fill Text  [name="journal"]  Updated Journal
    Click  button >> text=Save
    Get Text  body  *=  Journal: Updated Journal
    Get Text  body  *=  (article)

Edit page is prefilled for inproceedings-specific fields
    Add Inproceedings  RobotEditInproc  Proc Title  Proc Author  2021  Orig Booktitle  Orig Editor  1-10  Orig Publisher
    Go To  ${HOME_URL}
    Click  li >> a >> text=Edit
    Get Property  [name="booktitle"]  value  ==  Orig Booktitle
    Get Property  [name="editor"]  value  ==  Orig Editor
    Get Property  [name="pages"]  value  ==  1-10
    Get Property  [name="publisher"]  value  ==  Orig Publisher
    Fill Text  [name="booktitle"]  Updated Booktitle
    Click  button >> text=Save
    Get Text  body  *=  Booktitle: Updated Booktitle
    Get Text  body  *=  (inproceedings)

Cancel on edit page does not save changes
    Add Reference  RobotEditCancel  Cancel Title  Cancel Author  2015  Cancel Publisher
    Go To  ${HOME_URL}
    Click  li >> a >> text=Edit
    Fill Text  [name="title"]  Changed Title
    Click  a >> text=Cancel
    Get Url  ==  ${HOME_URL}/
    Get Text  body  *=  Cancel Title
    ${body}=  Get Text  body
    Should Not Contain  ${body}  Changed Title

Editing a nonexistent reference shows an error
    Go To  ${HOME_URL}/edit_reference/999999
    Get Text  body  *=  Not Found

Server-side validation rejects empty required field on edit
    Add Reference  RobotEditValid  Title  Author  2000  Publisher
    Go To  ${HOME_URL}
    Click  li >> a >> text=Edit
    Evaluate JavaScript  [name="author"]  el => el.removeAttribute('required')
    Fill Text  [name="author"]  ${EMPTY}
    Click  button >> text=Save
    Get Text  body  *=  Author is required
    Get Url  *=  /edit_reference/

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