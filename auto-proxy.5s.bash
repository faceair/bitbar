#!/usr/bin/env bash

if [ -n "$(networksetup -getairportnetwork en0 | cut -c 24- | grep Priate-ship)" ] || [ -n "$(ps -A | grep -m1 openvpn | awk '{print $4}' | grep Tunnelblick.app)" ]; then
  networksetup -setsocksfirewallproxystate Wi-Fi off
  printf "" > ~/.config/fish/conf.d/proxy.fish
else
  networksetup -setsocksfirewallproxy "Wi-Fi" 127.0.0.1 1080
  networksetup -setsocksfirewallproxystate Wi-Fi on
  printf "set -gx http_proxy socks5://127.0.0.1:1080\nset -gx https_proxy socks5://127.0.0.1:1080" > ~/.config/fish/conf.d/proxy.fish
fi
