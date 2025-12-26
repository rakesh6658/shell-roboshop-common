#!/bin/bash
source ./common.sh
check_root_user
application=cart
app_setup
setup_nodejs
systemd_setup
print_total_time