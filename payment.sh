#!/bin/bash
source ./common.sh
check_root_user
application=payment
app_setup
python_setup
deamon_reload



