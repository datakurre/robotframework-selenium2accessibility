WAVE Toolbar library
====================

:download:`View available keywords <wavetoolbar.html>`.

Include keywords with::

   Resource  Accessibility/wavetoolbar.robot

Example of use:

.. code-block:: robotframework

   *** Settings ***

   Resource  Accessibility/wavetoolbar.robot

   Suite setup  Run keywords
   ...  Open accessibility test browser  Maximize Browser Window
   Suite teardown  Close all browsers

   *** Test Cases ***

   Test pages
       [Template]  Check WAVE
       http://www.plone.org/  wave=0

   *** Keywords ***

   Check WAVE
       [Arguments]  ${url}  ${wave}=0
       Should not exceed maximum WAVE errors  ${url}  ${wave}

   Should not exceed maximum WAVE errors
       [Arguments]  ${url}  ${max}
       ${errors} =  Count WAVE accessibility errors  ${url}
       Should be true  ${errors} <= ${max}
       ...  WAVE Toolbar reported ${errors} errors for ${url}

.. note::

   Currently all keywords are written as user keywords, but later they may be
   refactored into Python-keywords. If this happens, there will be backwards
   compatible wrappers available at ``wavetoolbar.robot``.
