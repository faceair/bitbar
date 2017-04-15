#!/usr/bin/env ruby

# fork from https://github.com/matryer/bitbar-plugins/blob/master/Dev/Homebrew/brew-services.10m.rb

#--- User parameters ----------------------------------------------------------

BAR_COLORS = true

#--- Script internals ---------------------------------------------------------

require 'pathname'

SCRIPT_PATH = Pathname.new($0).realpath()
DOCKER = "/usr/local/bin/docker"
DOCKER_LINK = "https://www.docker.com/"

REFRESH = "---\nRefresh | refresh=true"

if BAR_COLORS
  DARK_MODE=`defaults read -g AppleInterfaceStyle 2> /dev/null`.strip
  RESET_COLOR = DARK_MODE == 'Dark' ? "\e[37m" : "\e[30m"
else
  RESET_COLOR = "\e[37m"
end

if !File.exist?(DOCKER)
  puts [
    "Docker not installed | color=red",
    "---",
    "Install Docker... | href=#{DOCKER_LINK}",
    REFRESH,
  ].join("\n")
  exit(1)
end

def green(string)
  "\e[1m\e[32m#{string}#{RESET_COLOR}"
end

def container(command, name)
  "bash=\"#{DOCKER}\"" \
    + " param1=#{command} param2=\"#{name}\"" \
    + " terminal=false refresh=true"
end

def menu(name, status)
  if status.start_with?("Up")
    [
      "#{name} | color=#4FFF50",
      "--Restart | #{container("restart", name)}",
      "--Stop | #{container("stop", name)}",
      "-----",
      "--State: #{status}"
    ]
  else
    [
      name,
      "--Start | #{container("start", name)}",
      "--Remove | #{container("rm", name)}",
      "-----",
      "--State: #{status}",
    ]
  end
end

def plural(count)
  count <= 1 ? "#{count} containers" : "#{count} containers"
end

output = `#{DOCKER} ps -a --format "{{.Names}}|{{.Status}}"`.split("\n")

CONTAINERS = output && output.reduce({started: 0, menus: []}) do |acc, line|
  name, status = line.split('|')
  acc[:started] += 1 if status.start_with?("Up")
  acc[:menus] += menu(name, status)
  acc
end

started = CONTAINERS[:started]
menus = CONTAINERS[:menus].join("\n")

title = ""
if started != 0 && BAR_COLORS
  title = green(started)
elsif started != 0
  title = started
end

puts """
🐳#{title}
---
#{menus}
---
#{REFRESH}
"""
