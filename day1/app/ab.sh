#!/bin/bash

exec ab -n 100000 -c 50 http://localhost:3000/sync_sleep/0




