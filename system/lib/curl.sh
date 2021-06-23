#!/bin/bash

if [[ ! -v __LIB_CURL_IS_LOADED ]]; then
  readonly __LIB_CURL_IS_LOADED=true
    
  add_exception IsNotValidCurlRequestException 1100 "Is Not Valid Curl Request"
  add_exception       FailCurlRequestException 1101 "Fail Curl Request"
  add_exception MaxCurlExcecutionTimeException 1102 "Max Curl Excecution Time"
fi

declare -g CURL_REQUESTS_STATUS="true"
declare -g CURL_LAST_REQUEST_STATUS="false"
declare -g CURL_LAST_URL_REQUEST=""
#declare -g CURL_COOKIE_FILE=$(tmp::cookie "$_tmp_folder") 

function curl::_create_curl_params() {

  # __create_curl_params "http://google.com" "output.html" "cookie.txt" "allow_redirects"
  local _url=$1
  local _output=$2
  local _cookie=$3
  local _follow_redirect="allow_redirects"
  local _connection_timeout=$CURL_TIMEOUT

  # curl www.google.com
  #   --compressed 
  # --header 'Connection: keep-alive'
  # --header "User-Agent: $CURL_USERAGENT"
  # --cookie  cookie.txt --cookie-jar cookie.txt 
  #   --location
  #   --write-out "%{http_code}"
  # --output lorem.txt
  #   --silent 
  
  if [[ -z $_output ]]; then
    local _output=$(tmp::html)
  fi

  # cookie
  if [[ -z $_cookie ]]; then
    local _cookie=$CURL_COOKIE_FILE
  fi

  # follow redirect
  if [[ "$_follow_redirect" == "allow_redirects" ]]; then
      local _follow_redirect="--location"
  fi
  
  CURL_LAST_URL_REQUEST="$_url"

  # use nameref for indirection
    _params=(
      $_url 
      --compressed 
      --location
      -H 'Connection: keep-alive' 
      -H "User-Agent: PERKINS/0.1.0" 
      --cookie "$_cookie"
      --cookie-jar "$_cookie" 
      --connect-timeout "$_connection_timeout"
      --max-time "$_connection_timeout"
      --write-out "%{http_code}"
      --output "$_output"
      --silent 
      --insecure
    )

  declare -p _params
}

function curl::get() {

  # url           outputfile    cookiefile      allow_redirects
  # "http://google.com"   "output.html"   "cookie.txt"    "allow_redirects"

  local _url=$1
  local _output=$2
  local _cookie=$3
  local _allow_redirects=$4

  local _params
  eval $(curl::_create_curl_params "$_url" "$_output" "$_cookie" "$_allow_redirects")

  curl "${_params[@]}"
}

function curl::post() {

  # url           data            outputfile    cookiefile    allow_redirects
  # "http://google.com"   "param1=lorem&param2=ipsum" "output.html"   "cookie.txt"  "allow_redirects"
  local _url=$1
  local _data=$2
  local _output=$3
  local _cookie=$4
  local _allow_redirects=$5

  local params
  eval $(curl::_create_curl_params "$_url" "$_output" "$_cookie" "$_allow_redirects")

  _params+=(
    -H 'Content-Type: application/x-www-form-urlencoded'
    --data "$_data"
  ) 

  curl "${_params[@]}"
  log::debug $(printf '%s ::**:: \n' "${_params[@]}")
}

function curl::post_json() {

  local _url=$1
  local _data=$2
  local _output=$3
  local _cookie=$4
  local _allow_redirects=$5

  local _params
  eval $(curl::_create_curl_params "$_url" "$_output" "$_cookie" "$_allow_redirects")

  _params+=(
    -X POST 
    -H 'Content-type: application/json' 
    --data "$_data" 
  )

  curl "${_params[@]}"
}

function curl::verify_http_code() {
  local _method=$1
  local _url=$2
  local _http_code=$3
  
  if (( $(echo "$_http_code >= 200 && $_http_code < 300" | bc) )); then
    local _status="success"
    CURL_LAST_REQUEST_STATUS="true"
  else
    local _status="error"
    CURL_REQUESTS_STATUS="false"
    CURL_LAST_REQUEST_STATUS="false"
  fi

  log::debug "req ${_method} ${_url} ${_http_code} ${_status}"
  if [[ $CURL_FAIL_ON_ERROR == "true" && $CURL_LAST_REQUEST_STATUS == "false" ]]; then
    throw $FailCurlRequestException
  fi
}

function curl::verify_valid_request() {

  if [[ "$(curl::is_valid_requests)" == "false" ]]; then
    log::error "request fail $CURL_LAST_URL_REQUEST"
    throw $IsNotValidCurlRequestException
  fi
}

function curl::validate_request() {
  local _method=$1
  local _url=$2
  local _http_code=$3

  curl::verify_http_code "$_method" "$_url" "$_http_code"
  curl::verify_valid_request
}

function curl::reset_request_status() {
  CURL_REQUESTS_STATUS="true"
}

function curl::is_valid_requests() {
  echo "$CURL_REQUESTS_STATUS"
}
