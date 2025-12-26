#!/bin/bash
source ./common.sh
check_root_user
application=payment
app_setup
python_setup
systemd_setup
print_total_time



