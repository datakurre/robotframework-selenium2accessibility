# -*- coding: utf-8 -*-
import os.path

from robot.libraries.BuiltIn import BuiltIn


class Accessibility(object):
    """This library provides a few Robot Framework resources for executing
    automated analyzes with the Firefox add-on.

    """
    def __init__(self):
        self.import_Accessibility_resources()

    def import_Accessibility_resources(self):
        """Import Accessibility user keywords.
        """
        BuiltIn().import_resource('Accessibility/accessibility.robot')


class WAVEToolbar(object):
    """WAVE is an accessibility analyzing service and Firefox add-on created by
    WebAIM. This library provides a few Robot Framework resources for executing
    automated analyzes with the Firefox add-on.

    """
    def __init__(self):
        self.import_WAVEToolbar_resources()

    def import_WAVEToolbar_resources(self):
        """Import WAVEToolbar user keywords.
        """
        BuiltIn().import_resource('Accessibility/wavetoolbar.robot')


class ContrastChecker(object):
    """This library provides a few Robot Framework resources for executing
    automated analyzes with the Firefox add-on.

    """
    def __init__(self):
        self.import_ContrastChecker_resources()

    def import_ContrastChecker_resources(self):
        """Import ContrastChecker user keywords.
        """
        BuiltIn().import_resource('Accessibility/contrastchecker.robot')


class Image:
    def crop_image_file(self, output_dir, filename, left, top, width, height):
        """Crop the saved image with given filename for the given dimensions.
        """
        from PIL import Image

        img = Image.open(os.path.join(output_dir, filename))
        box = (int(left), int(top), int(left + width), int(top + height))

        area = img.crop(box)

        with open(os.path.join(output_dir, filename), 'wb') as output:
            area.save(output, 'png')

