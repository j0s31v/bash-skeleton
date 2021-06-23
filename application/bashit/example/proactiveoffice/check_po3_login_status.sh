#!/bin/bash

source "$APP_DIR/perkins/scenario/proactiveoffice/requests.sh"

function scenario::check_po3_login_status::run {
  local -r _url_base=$1
  local -r _username=$2
  local -r _password=$3
  local -r _tmp_folder=$4
  local -r _cookie=$5
  local -r _max_execution_time=$6
  local -r _allow_redirect="allow_redirect" # $7

  io::title "RUNNING SCENARIO FOR $_url_base"

  req::set_variable "url_base"       "$_url_base"
  req::set_variable "username"       "$_username"
  req::set_variable "password"       "$_password"
  req::set_variable "tmp_folder"     "$_tmp_folder"
  req::set_variable "cookie"         "$_cookie"
  req::set_variable "max_exec_time"  "$_max_execution_time"
  req::set_variable "allow_redirect" "$_allow_redirect"

  req::po3_landingpage
  req::po3_login
  req::po3_dashboard
  req::po3_projects    
  req::po3_logout
  
}

