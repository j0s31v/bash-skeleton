  #!/bin/bash

function str::trim() {
  local -r _str=$1
  
  echo "$_str" | xargs
}

function str::remove_prefix() {
  local -r _preffix=$1
  local _str=$2
  
  _str=$(str::trim "$_str")
  echo "${_str#$_prefix}"
}

function str::remove_suffix() {
  local -r _suffix=$1
  local _str=$2
  
  _str=$(str::trim "$_str")
  echo "${_str%$_suffix}"
}

function str::upper() {
  local -r _str=$1
  
  echo "$_str" | awk '{print toupper($0)}'
}
                                                                                                                        
function str::lower() {
  local -r _str=$1
  
  echo "$_str" | awk '{print tolower($0)}'
}

function str::repeat() {
  local -r _chr=$1
  local -r _times=$2

  for ((n=0;n<$_times;n++))
  do
    printf "${_chr}"
  done
}

function str::len() {
  local -r _str=$1

  echo ${#_str}
}
