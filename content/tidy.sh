#!/bin/bash

find . -maxdepth 1 -type f -name "*.html" -exec bash -c "cat {} | tidy -config tidy.cfg -o {}" \; > /dev/null 2>&1

