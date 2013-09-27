*** Settings ***

Library  Selenium2Library

Library  Accessibility.Image

*** Variables ***

${FF_PROFILE_DIR}  ${CURDIR}/profile
${ERROR_CROP_MARGIN}  50

*** Keywords ***

Open accessibility test browser
    [Documentation]  Open Firefox with a11y add-ons pre-installed.
    Open browser  about:  browser=firefox  ff_profile_dir=${FF_PROFILE_DIR}

Crop accessibility issue screenshot
    [Documentation]  Crops the given ``filename`` to
    ...              match the combined bounding box of the
    ...              elements matching the given ``locators``.
    ...
    ...              Requires at least two arguments
    ...              (``filename`` and at least one ``locator``).
    [Arguments]  ${filename}  @{ids}
    ${ids} =  Convert to string  ${ids}
    ${ids} =  Replace string using regexp  ${ids}  u'  '
    @{dimensions} =  Execute Javascript
    ...    return (function(){
    ...        var ids = ${ids}, i, target, box, offset = {};
    ...        var left = null, top = null, width = null, height = null;
    ...        for (i = 0; i <= ids.length; i++) {
    ...            if (i < ids.length) {
    ...                target = window.document.getElementById(ids[i]);
    ...            } else if (window.document.getElementsByClassName(
    ...                           'wave4tooltip').length > 0) {
    ...                target = window.document.getElementsByClassName(
    ...                    'wave4tooltip')[0];  /* WAVE Toolbar tip */
    ...            } else {
    ...                continue;
    ...            }
    ...            box = target.getBoundingClientRect();
    ...            offset.left = Math.round(box.left + window.pageXOffset);
    ...            offset.top = Math.round(box.top + window.pageYOffset);
    ...            if (left === null || width === null) {
    ...                width = box.width;
    ...            } else {
    ...                width = Math.max(
    ...                    left + width, offset.left + box.width
    ...                ) - Math.min(left, offset.left);
    ...            }
    ...            if (top === null || height === null) {
    ...                height = box.height;
    ...            } else {
    ...                height = Math.max(
    ...                    top + height, offset.top + box.height
    ...                ) - Math.min(top, offset.top);
    ...            }
    ...            if (left === null) { left = offset.left; }
    ...            else { left = Math.min(left, offset.left); }
    ...            if (top === null) { top = offset.top; }
    ...            else { top = Math.min(top, offset.top); }
    ...        }
    ...        return [Math.max(0, left - ${ERROR_CROP_MARGIN}),
    ...                Math.max(0, top - ${ERROR_CROP_MARGIN}),
    ...                Math.max(0, width + ${ERROR_CROP_MARGIN} * 2),
    ...                Math.max(height + ${ERROR_CROP_MARGIN} * 2)];
    ...    })();
    Crop image file  ${OUTPUT_DIR}  ${filename}  @{dimensions}

Capture and crop accessibility issue screenshot
    [Documentation]  Captures a page screenshot with the given ``filename`` and
    ...              crops it to match the combined bounding box of the
    ...              elements matching the given ``locators``.
    ...
    ...              Requires at least two arguments
    ...              (``filename`` and at least one ``locator``).
    [Arguments]  ${filename}  @{locators}
    Capture page screenshot  ${filename}
    Crop accessibility issue screenshot  ${filename}  @{locators}
