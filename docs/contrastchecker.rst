WCAG Contrast Checker library
=============================

Usage
-----

Include keywords with::

    Library  Accessibility.ContrastChecker

.. note::

   Currently, RIDE is unable to find keywords provided by this library when
   this library is imported with ``Library  Accessibility.ContrastChecker``.
   This can be fixed by requiring the library with ``Resource
   Accessibility/contrastchecker.robot``. (Currently all keywords are written
   as user keywords, but later they may be refactored into Python-keywords. If
   this happens, there will be backwards compatible wrappers available at
   ``contrastchecker.robot``.)

Keywords
--------

.. robot_keywords::
   :source: Accessibility:contrastchecker.robot

Source
------

.. robot_source::
   :source: Accessibility:contrastchecker.robot
