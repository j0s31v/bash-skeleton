#!/bin/bash

function os::get_os_name() {
  if [[ -f /etc/debian_version ]]; then
    if (lsb_release -a 2>&1 | grep Debian > /dev/null 2>&1); then
      echo "DEBIAN"
      return 0
    elif ( lsb_release -a 2>&1 | grep Ubuntu > /dev/null 2>&1 ); then
      echo "UBUNTU"
      return 0
    fi
  fi
  echo "OTHER"  
}


function os::command_exists_or_die() {
  local -r cmd=$1

  if ! command -v $cmd &> /dev/null
  then
      error "COMMAND $cmd could not be found" 
  fi
}

function os::is_installed_package() {
  local -r _package=$1
echo ";;;; $_package"
  if [[ $(dpkg-query -W --showformat='${Status}\n' ${_package} | grep "install ok installed") == "install ok installed" ]]; then
    true
  else
    false
  fi
}
