*** Settings ***

Library  Accessibility
Library  String

*** Keywords ***

Check WAVE accessibility errors
    [Documentation]  Check the current page for accessibility errors (or
    ...              open the optional ``url`` before check). Then fail if any
    ...              accessibility errors were detected by WAVE Toolbar.
    ...
    ...              Optional keyword arguments:
    ...
    ...              * ``url``, which opens the given ``url`` before \
    ...                performing WAVE Toolbar's accessibility analysis
    ...
    ...              * ``log``, which briefly logs all accessibility errors \
    ...                detected by WAVE Toolbar
    ...
    ...              * ``capture``, which does its best to capture cropped \
    ...                page screenshots of all accessibility errors detected \
    ...                by WAVE Toolbar
    [Arguments]      ${url}=${EMPTY}  ${log}=${EMPTY}  ${capture}=${EMPTY}
    ${is_url} =  Convert to boolean  ${url}
    ${is_log} =  Convert to boolean  ${log}
    ${is_capture} =  Convert to boolean  ${capture}

    Run keyword if  ${is_url}  Go to  ${url}

    Show WAVE errors, features and alerts
    ${errors} =  Get WAVE errors
    Run keyword if  ${is_log}  Log WAVE errors if any  ${errors}  ${is_capture}
    Hide WAVE errors, features and alerts

    ${url} =  Get location
    Should be equal  ${errors}  ${EMPTY}
    ...    WAVE Toolbar reported errors for ${url}

Count WAVE accessibility errors
    [Documentation]  Check the current page for accessibility errors (or
    ...              open the optional ``url`` before check). Then count and
    ...              return the number of accessibility errors detected by
    ...              WAVE Toolbar.
    ...
    ...              Optional keyword arguments:
    ...
    ...              * ``url``, which opens the given ``url`` before \
    ...                performing WAVE Toolbar's accessibility analysis
    ...
    ...              * ``log``, which briefly logs all accessibility errors \
    ...                detected by WAVE Toolbar
    ...
    ...              * ``capture``, which does its best to capture cropped \
    ...                page screenshots of all accessibility errors detected \
    ...                by WAVE Toolbar
    [Arguments]      ${url}=${EMPTY}  ${log}=${EMPTY}  ${capture}=${EMPTY}
    ${is_url} =  Convert to boolean  ${url}
    ${is_log} =  Convert to boolean  ${log}
    ${is_capture} =  Convert to boolean  ${capture}

    Run keyword if  ${is_url}  Go to  ${url}

    Show WAVE errors, features and alerts
    ${errors} =  Get WAVE errors
    Run keyword if  ${is_log}  Log WAVE errors if any  ${errors}  ${is_capture}
    Hide WAVE errors, features and alerts

    ${length} =  Get line count  ${errors}
    [return]  ${length}

Show WAVE errors, features and alerts
    [Documentation]  Activate WAVE Toolbar's
    ...              *Show WAVE errors, features and alerts*
    ...              -action.
    Execute Javascript
    ...    return (function(){ window.wave_viewIcons(); return true; })();

Hide WAVE errors, features and alerts
    [Documentation]  Disable WAVE Toolbar's
    ...              *Show WAVE errors, features and alerts*
    ...              -action.
    Execute Javascript
    ...    return (function(){ window.wave_viewReset(); return true; })();

Log WAVE errors if any
    [Documentation]  Run keyword *Log WAVE errors* when length of required
    ...              argument ``errors`` is greater than zero.
    ...
    ...              Optional keyword arguments:
    ...
    ...              * ``capture``, which does its best to capture cropped \
    ...                page screenshots of all accessibility errors detected \
    ...                by WAVE Toolbar
    [Arguments]  ${errors}  ${capture}=${EMPTY}
    ${found} =  Convert to boolean  ${errors}
    Run keyword if  ${found}  Log WAVE errors  ${errors}  ${capture}

Log WAVE errors
    [Documentation]  Tag the current test with *Accessibility issues*-tag,
    ...              try to take screenshots of each given accessibility issue
    ...              and append the errors into the current test log.
    [Arguments]  ${errors}  ${capture}=${EMPTY}
    Set tags  Accessibility issues
    Capture page screenshot
    Run keyword if  ${capture}  Capture visible WAVE errors
    Log  ${errors}  level=ERROR

Get WAVE errors
    [Documentation]  Extract and return accessibility errors detected by
    ...              WAVE Toolbar.
    ...
    ...              This keyword requires that
    ...              WAVE errors, features and alerts
    ...              are visible when this keyword is being called.
    ${source} =  Get source
    ${source} =  Replace string  ${source}  \n  ${EMPTY}
    ${source} =  Replace string  ${source}  "  \n
    ${source} =  Get lines matching regexp  ${source}  ^ERROR:.*
    [return]  ${source}

Capture visible WAVE errors
    [Documentation]  Try to take a cropped screen capture of each currently
    ...              visible WAVE toolbar reported error.
    ...
    ...              This keyword requires that
    ...              WAVE errors, features and alerts
    ...              are visible when this keyword is being called.
    @{ids} =  Tag visible WAVE errors
    ${keyword} =  Register keyword to run on failure  No operation
    :FOR  ${id}  IN  @{ids}
    \  Run keyword and ignore error  Capture visible WAVE error  ${id}
    Register keyword to run on failure  ${keyword}

Tag visible WAVE errors
    [Documentation]  Tag each WAVE toolbar reported error with a unique id
    ...              and return the ids to ease access to the errors.
    ...
    ...              This keyword requires that
    ...              WAVE errors, features and alerts
    ...              are visible when this keyword is being called.
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

Capture visible WAVE error
    [Documentation]  Try to take a screen capture of a currently visible
    ...              WAVE toolbar reported error tagged with the given id.
    ...
    ...              This keyword requires that
    ...              WAVE errors, features and alerts
    ...              are visible when this keyword is being called.
    [Arguments]  ${id}
    Element should be visible  id=${ID}
    Mouse over  ${id}
    Element should be visible  css=.wave4tooltip
    Capture and crop accessibility issue screenshot  ${id}.png  ${id}
