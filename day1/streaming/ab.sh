#!/bin/bash

exec ab -n 100000 -t 10 -c 50 http://localhost:3000/sync/0



