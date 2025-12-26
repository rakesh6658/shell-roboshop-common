#!/bin/bash
source ./common.sh
check_root_user
application=cart
setup_nodejs
app_setup
deamon_reload