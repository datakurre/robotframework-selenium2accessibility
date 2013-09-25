*** Settings ***

Library  Accessibility
Library  String

*** Keywords ***

Check URL for WAVE accessibility errors
    [Documentation]  Open the given URL and check it for accessibility errors.
    [Arguments]  ${URL}
    Go to  ${URL}
    Check WAVE accessibility errors

Check WAVE accessibility errors
    [Documentation]  Check the current page for accessibility errors
    Show WAVE errors, features and alerts
    ${errors} =  Get WAVE errors
    ${found} =  Convert to boolean  ${errors}
    Run keyword if  ${found}  Log WAVE errors  ${errors}
    ${url} =  Get location
    Should be equal  ${errors}  ${EMPTY}  Wave reported errors for ${url}
    Hide WAVE errors, features and alerts

Log WAVE errors
    [Documentation]  Tag the current test with *Accessibility issues*-tag,
    ...              try to take screenshots of each given accessibility issue
    ...              and append the errors into the current test log.
    [Arguments]  ${errors}
    Set tags  Accessibility issues
    Capture page screenshot
    Capture WAVE errors
    Log  ${errors}  level=ERROR

Get WAVE errors
    [Documentation]  Extract and return the found WAVE Toolbar errors from the
    ...              currently open page.
    ${source} =  Get source
    ${source} =  Replace string  ${source}  \n  ${EMPTY}
    ${source} =  Replace string  ${source}  "  \n
    ${source} =  Get lines matching regexp  ${source}  ^ERROR:.*
    [return]  ${source}

Show WAVE errors, features and alerts
    [Documentation]  Activate WAVE Toolbar's *Show WAVE errors, features and alerts*
    ...              action.
    Execute Javascript
    ...    return (function(){ window.wave_viewIcons(); return true; })();

Hide WAVE errors, features and alerts
    [Documentation]  Disable WAVE Toolbar's *Show WAVE errors, features and alerts*
    ...              action.
    Execute Javascript
    ...    return (function(){ window.wave_viewReset(); return true; })();

Capture WAVE errors
    [Documentation]  Try to take a screen capture of each currently visible
    ...              WAVE toolbar reported error.
    @{ids} =  Tag WAVE errors
    ${keyword} =  Register keyword to run on failure  No operation
    :FOR  ${id}  IN  @{ids}
    \  Run keyword and ignore error  Capture WAVE error  ${id}
    Register keyword to run on failure  ${keyword}

Tag WAVE errors
    [Documentation]  Tag each WAVE toolbar reported error with a unique id
    ...              and return the ids to ease access to the errors.
    ${errors} =  Execute Javascript
    ...    return (function(){
    ...        var i, id, ids = [], errors = Array.filter(
    ...            document.getElementsByClassName("wave4tip"),
    ...            function(el) { return el.alt.match(/^ERROR.*/) !== null; }
    ...        );
    ...        for (i=0; i < errors.length; i++) {
    ...            id = 'wave-error-' + (new Date().getTime()).toString();
    ...            id = id + i.toString();
    ...            errors[i].id = id;
    ...            ids.push(id);
    ...        }
    ...        return ids;
    ...    })();
    [Return]  ${errors}

Capture WAVE error
    [Documentation]  Try to take a screen capture of a currently visible
    ...              WAVE toolbar reported error tagged with the given id.
    [Arguments]  ${id}
    Element should be visible  id=${ID}
    Mouse over  ${id}
    Element should be visible  css=.wave4tooltip
    Capture and crop accessibility issue screenshot  ${id}.png  ${id}
