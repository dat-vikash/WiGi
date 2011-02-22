#!/usr/bin/env python
from setuptools import setup, find_packages

#simplejson is needed for tornado. If running python 2.6, simplejson is already included.
required_modules = [
	"sqlalchemy >=0.6.1",
	"tornado>=1.1.1",	
	"pycurl",
	"pyyaml",
]

setup(
	name="wigi",
	version="0.1",
	description="provides web extension of wigi system",
	author="Vikash Dat",
	author_email="dat.vikash@gmail.com",
	dependency_links = ["http://github.com/downloads/facebook/tornado"],
	packages=find_packages(),
	install_requires=required_modules,
)
