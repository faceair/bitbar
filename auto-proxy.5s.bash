#!/usr/bin/env bash

if [ ! -f /tmp/disable_bitbar_auto_proxy ]; then
  networksetup -setsocksfirewallproxy "Wi-Fi" 127.0.0.1 1080
  networksetup -setsocksfirewallproxystate Wi-Fi on
  echo -e "set -gx http_proxy socks5://127.0.0.1:1080\nset -gx https_proxy socks5://127.0.0.1:1080" > ~/.config/fish/conf.d/proxy.fish
  echo "✈️| bash=/usr/bin/touch param1=/tmp/disable_bitbar_auto_proxy terminal=false"
else
  networksetup -setsocksfirewallproxystate Wi-Fi off
  echo "" > ~/.config/fish/conf.d/proxy.fish
  echo "❕| bash=/bin/rm param1=/tmp/disable_bitbar_auto_proxy terminal=false"
fi
