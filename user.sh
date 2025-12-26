#!/bin/bash
source ./common.sh
check_root_user
application=user
setup_nodejs
app_setup
deamon_reload
