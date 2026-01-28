#!/bin/bash

# Dừng script nếu có lệnh lỗi
set -e

# Di chuyển tới thư mục chứa file ovpn
cd "$HOME/Downloads"

# Import config OpenVPN
openvpn3 config-import --config profile-userlocked.ovpn

# Start session OpenVPN
openvpn3 session-start --config profile-userlocked.ovpn

# Hiển thị danh sách session
openvpn3 sessions-list
