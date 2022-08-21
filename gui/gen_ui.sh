#!/bin/bash
#
# Temporary compile UI code generator - TODO Write Makefile
#
python3 -m PyQt5.uic.pyuic -x form.ui -o ui/form.py
