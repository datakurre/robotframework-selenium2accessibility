*** Settings ***

Library  Accessibility

*** Keywords ***

Check Colors
    ${ERRORS} =  Execute Async Javascript
    ...    return (function(callback) {
    ...        return window.colorchecker_run(callback);
    ...    })(arguments[0]);

    :FOR  ${index}  IN RANGE  ${ERRORS}
    \      Execute Javascript
    ...        return (function(){
    ...            window.colorchecker_show(${index}); return true;
    ...        })();
    \      Capture Color errors
#   \      Execute Javascript
#   ...        return (function(){
#   ...            window.colorchecker_clear(); return true;
#   ...        })();

Capture Color errors
    @{ids} =  Tag Contrast Checker errors
    ${keyword} =  Register keyword to run on failure  No operation
    :FOR  ${id}  IN  @{ids}
    \  Run keyword and ignore error  Capture color error  ${id}
    Register keyword to run on failure  ${keyword}

Capture Color error
    [Arguments]  ${id}
    Element should be visible  ${id}
    Capture and crop accessibility issue screenshot  ${id}.png  ${id}

Tag Contrast Checker errors
    [Documentation]  Tag each WAVE toolbar reported error with a unique id
    ...              and return the ids to ease access to the errors.
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
