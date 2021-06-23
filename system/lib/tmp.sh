#!/bin/bash

function tmp::file() {
  local _tmp_folder=$1
  local _template=$2

  if [[ -z $_tmp_folder ]]; then
    _tmp_folder=$TMP_DIR
  fi

  if [[ -z $_template ]]; then
    _template='file_XXXXXXXXXX'
  fi

  echo $(mktemp -t "$_template" --tmpdir="$_tmp_folder")
}

function tmp::html() {
  local -r _tmp_folder=$1
  
  echo $(tmp::file "$_tmp_folder" "request_XXXXXXXXXX.html")
}

function tmp::cookie() {
  local -r _tmp_folder=$1
  
  echo $(tmp::file "$_tmp_folder" "cookie_XXXXXXXXXX")
}

function tmp::folder() {
  local _name=$1
  local _tmp_folder=$2

  if [[ -z $_name ]]; then
    _name="folder"
  fi

  if [[ -z $_tmp_folder ]]; then
    _tmp_folder=$TMP_DIR
  fi

  echo $(mktemp -d -t $_name"_XXXXXXXXXX" --tmpdir="$_tmp_folder")
}
