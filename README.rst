Robot Framework Accessibility Testing Libraries
===============================================

This package bundles various Firefox-extensions for web site accessibility
checking with some glue and pre-baked `Robot Framework`_ keyword libraries to
enable automated accessibility regression testing with Selenium_.

This package will not replace human made accessibility auditions. Nor will
passing automated accessibility checks mean that your site is accessible.

Once your site has been audited on accessibility, however, these tools could
help you to detect regression in accessibility with automated and continuously
integrated accessibility tests.

(This package includes a Firefox profile with unmodified `WAVE Toolbar`_ and
unmodified `WCAG Contrast checker`_ extensions pre-installed. WAVE toolbar, its
interface elements, design elements, functionality, and underlying code are (c)
WebAIM.)

.. _Robot Framework: http://robotframework.org/
.. _Selenium: http://pypi.python.org/pypi/robotframework-selenium2library/
.. _WAVE Toolbar: http://wave.webaim.org/toolbar/
.. _WCAG Contrast checker: https://addons.mozilla.org/en-US/firefox/addon/wcag-contrast-checker/

.. note::

   WCAG Contrast checker is currently configured to run the check
   always for WCAG 2.0 level AA. This could be made optional later.


Installation
------------

.. code:: robotframework

   $ pip install robotframework-selenium2accessibility


Example test
------------

.. code:: robotframework

   *** Settings ***

   Resource  Accessibility/wavetoolbar.robot
   Resource  Accessibility/contrastchecker.robot

   Suite setup  Run keywords
   ...  Open accessibility test browser  Maximize Browser Window
   Suite teardown  Close all browsers

   *** Test Cases ***

   Test single page
        [Documentation]  Single page test could interact with the target
        ...              app as much as required and end with triggering
        ...              the accessibility scan.
        Go to  http://www.plone.org/
        Check WAVE accessibility errors

   Test multiple pages
       [Documentation]  Template based test can, for example, take a list
       ...              of URLs and perform accessibility scan for all
       ...              of them. While regular test would stop for the
       ...              first failure, template based test will just jump
       ...              to the next URL (but all failures will be reported).
       [Template]  Check both WAVE and color contrast
       http://www.plone.org/  wave=0  contrast=6
       http://www.drupal.org/  wave=0  contrast=5
       http://www.joomla.org/  wave=0  contrast=9
       http://www.wordpress.org/  wave=1  contrast=5

   *** Keywords ***

   Check both WAVE and color contrast
       [Arguments]  ${url}  ${wave}=0  ${contrast}=0
       Should not exceed maximum WAVE errors  ${url}  ${wave}
       Should not exceed maximum color contrast issues  ${url}  ${contrast}

   Should not exceed maximum WAVE errors
       [Arguments]  ${url}  ${max}
       ${errors} =  Count WAVE accessibility errors  ${url}
       Should be true  ${errors} <= ${max}
       ...  WAVE Toolbar reported ${errors} errors for ${url}

   Should not exceed maximum color contrast issues
       [Arguments]  ${url}  ${max}
       ${errors} =  Count color contrast issues  ${url}
       Should be true  ${errors} <= ${max}
       ...  WCAG Contrast checker reported ${errors} issue for ${url}


Running
-------

.. code:: bash

    $ pybot demo.robot

`Read the docs for more detailed information. <https://robotframework-selenium2accessibility.readthedocs.org/>`_
