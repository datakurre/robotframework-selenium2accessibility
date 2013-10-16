#!/bin/sh
LIBDOC="python -m robot.libdoc -F REST"

$LIBDOC --name="Accessibility" Accessibility/accessibility.robot docs/accessibility.html
$LIBDOC --name="WaveToolbar" Accessibility/wavetoolbar.robot docs/wavetoolbar.html
$LIBDOC --name="ContrastChecker" Accessibility/contrastchecker.robot docs/contrastchecker.html

