from setuptools import setup, find_packages

setup(
    name="robotframework-selenium2accessibility",
    version='0.2.1.dev0',
    description="Robot Framework resources for automating accessibility tools",
    long_description=(open("README.rst").read() + "\n" +
                      open("CHANGES.txt").read()),
    # Get more strings from
    # http://pypi.python.org/pypi?%3Aaction=list_classifiers
    classifiers=[
        "Programming Language :: Python",
    ],
    keywords="",
    author="Asko Soukka",
    author_email="asko.soukka@iki.fi",
    url="https://github.com/datakurre/robotframework-selenium2accessibility/",
    license="GPL",
    packages=find_packages("src", exclude=["ez_setup"]),
    package_dir={"": "src"},
    include_package_data=True,
    zip_safe=False,
    install_requires=[
        "setuptools",
        "robotframework",
        "robotframework-selenium2library",
    ],
    extras_require={"docs": [
        "sphinxcontrib-robotdoc",
        "sphinx"
    ]},
)
