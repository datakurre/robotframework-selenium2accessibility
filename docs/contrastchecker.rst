WCAG Contrast Checker library
=============================

:download:`View available keywords <contrastchecker.html>`.

Include keywords with::

   Resource  Accessibility/contrastchecker.robot

Example of use:

.. code-block:: robotframework

   *** Settings ***

   Resource  Accessibility/contrastchecker.robot

   Suite setup  Run keywords
   ...  Open accessibility test browser  Maximize Browser Window
   Suite teardown  Close all browsers

   *** Test Cases ***

   Test pages
       [Template]  Check color contrast
       http://www.plone.org/  contrast=6

   *** Keywords ***

   Check color contrast
       [Arguments]  ${url}  ${contrast}=0
       Should not exceed maximum color contrast issues  ${url}  ${contrast}

   Should not exceed maximum color contrast issues
       [Arguments]  ${url}  ${max}
       ${errors} =  Count color contrast issues  ${url}
       Should be true  ${errors} <= ${max}
       ...  WCAG Contrast checker reported ${errors} issue for ${url}

.. note::

   Currently all keywords are written as user keywords, but later they may be
   refactored into Python-keywords. If this happens, there will be backwards
   compatible wrappers available at ``contrastchecker.robot``.
