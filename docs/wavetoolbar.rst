WAVE Toolbar library
====================

Usage
-----

Include keywords with::

    Library  Accessibility.WAVEToolbar

.. note::

   Currently, RIDE is unable to find keywords provided by this library when
   this library is imported with ``Library  Accessibility.WAVEToolbar``. This
   can be fixed by requiring the library with ``Resource
   Accessibility/wavetoolbar.robot``. (Currently all keywords are written as
   user keywords, but later they may be refactored into Python-keywords. If
   this happens, there will be backwards compatible wrappers available at
   ``wavetoolbar.robot``.)

Keywords
--------

.. robot_keywords::
   :source: Accessibility:wavetoolbar.robot
   :style: minimal

Source
------

.. robot_source::
   :source: Accessibility:wavetoolbar.robot
