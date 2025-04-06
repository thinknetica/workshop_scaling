#!/bin/bash

exec siege -t 10S -b -d0 -c50 --no-parser --no-follow -f siege.txt ${@}


