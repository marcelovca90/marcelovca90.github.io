#!/bin/bash

find . -type f -name "*.html" -exec bash -c "echo {} && cat {} | tidy -config tidy.cfg -o {}" \; > /dev/null 2>&1
