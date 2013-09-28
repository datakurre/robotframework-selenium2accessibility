*** Settings ***

Library  Accessibility

*** Keywords ***

Check color contrast issues
    [Documentation]  Check the current page for color contrast issues (or
    ...              open the optional ``url`` before check). Then fail if any
    ...              color contrast issues were detected by WCAG Contrast
    ...              checker.
    ...
    ...              Optional keyword arguments:
    ...
    ...              * ``url``, which opens the given ``url`` before \
    ...                performing WCAG Contrast checker analysis.
    ...
    ...              * ``capture``, which does its best to capture cropped \
    ...                page screenshots of all accessibility errors detected \
    ...                by WCAG Contrast checker.
    [Arguments]      ${url}=${EMPTY}  ${capture}=${EMPTY}
    ${is_url} =  Convert to boolean  ${url}
    ${is_capture} =  Convert to boolean  ${capture}

    Run keyword if  ${is_url}  Go to  ${url}

    ${errors} =  Get Contrast Checker error count
    Run keyword if  ${is_capture}  Capture contrast Checker errors

    ${url} =  Get location
    Should be true  ${errors} < 2
    ...  WCAG Contrast checker reported ${errors} issues for ${url}
    Should be true  ${errors} < 1
    ...  WCAG Contrast checker reported ${errors} issue for ${url}

Count color contrast issues
    [Documentation]  Check the current page for color contrast issues (or
    ...              open the optional ``url`` before check). Then count and
    ...              return the number of color contrast issues detected by
    ...              WCAG Contrast checker.
    ...
    ...              Optional keyword arguments:
    ...
    ...              * ``url``, which opens the given ``url`` before \
    ...                performing WCAG Contrast checker analysis.
    ...
    ...              * ``capture``, which does its best to capture cropped \
    ...                page screenshots of all accessibility errors detected \
    ...                by WCAG Contrast checker.
    [Arguments]      ${url}=${EMPTY}  ${capture}=${EMPTY}
    ${is_url} =  Convert to boolean  ${url}
    ${is_capture} =  Convert to boolean  ${capture}

    Run keyword if  ${is_url}  Go to  ${url}

    ${errors} =  Get Contrast Checker error count
    Run keyword if  ${is_capture}  Capture contrast Checker errors

    [return]  ${errors}

Get Contrast Checker error count
    [Documentation]  Execute WCAG Contrast checker analysis for the current
    ...              page and return the detected errors count.
    ${errors} =  Execute Async Javascript
    ...    return (function(callback) {
    ...        return window.colorchecker_run(callback);
    ...    })(arguments[0]);
    [return]  ${errors}

Capture Contrast Checker errors
    [Documentation]  Execute WCAG Contrast checker analysis for the current
    ...              page and try to take screenshots of each detected issue.
    ${errors} =  Get Contrast Checker error count
    :FOR  ${index}  IN RANGE  ${errors}
    \      Show Contrast Checker error  ${index}
    Capture page screenshot

    @{ids} =  Tag visible contrast checker errors

    ${keyword} =  Register keyword to run on failure  No operation
    :FOR  ${id}  IN  @{ids}
    \  Run keyword and ignore error
    ...    Capture tagged Contrast Checker error  ${id}
    Register keyword to run on failure  ${keyword}

    Hide Contrast Checker errors

Show Contrast Checker error
    [Documentation]  After WCAG Contrast checker analysis, highlight the
    ...              issue with the given ``index``.
    [Arguments]  ${index}
    Execute Javascript
    ...    return (function(){
    ...        window.colorchecker_show(${index});
    ...        return true;
    ...    })();

Hide Contrast Checker errors
    [Documentation]  Hide all WCAG Contrast checker highlights.
    Execute Javascript
    ...    return (function(){
    ...        window.colorchecker_clear();
    ...        return true;
    ...    })();

Capture tagged Contrast Checker error
    [Documentation]  After WCAG Contrast checker error have been tagged,
    ...              try to capture visible error with the given ``id``.
    [Arguments]  ${id}
    Element should be visible  ${id}
    Capture and crop accessibility issue screenshot  ${id}.png  ${id}

Tag visible Contrast Checker errors
    [Documentation]  Tag each visible WCAG Contrast checker highlighted
    ...              error with a unique id and return the ids to ease
    ...              access to the errors.
    ${errors} =  Execute Javascript
    ...    return (function(){
    ...        var i, id, ids = [], errors = Array.filter(
    ...            document.getElementsByClassName("bioContrast"),
    ...            function(el) { return true; }
    ...        );
    ...        for (i=0; i < errors.length; i++) {
    ...            id = 'color-error-' + (new Date().getTime()).toString();
    ...            id = id + i.toString();
    ...            errors[i].id = id;
    ...            ids.push(id);
    ...        }
    ...        return ids;
    ...    })();
    [Return]  ${errors}
