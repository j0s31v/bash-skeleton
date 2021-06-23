#!/bin/bash

if [[ ! -v __LIB_CURL_IS_LOADED ]]; then
  source "${SYS_DIR}/lib/curl.sh"

  add_exception "RequestMaxExecutionTimeException" 1050 "Max execution request time"

fi

declare -g -A __REQUESTS_DATA_URL=()
declare -g -A __REQUESTS_DATA_METHOD=()
declare -g -A __REQUESTS_DATA_ENLAPSED_TIME=()
declare -g -A __REQUESTS_DATA_HTTP_CODE=()
declare -g -A __REQUESTS_DATA_HTML_PATH=()

function req::_save_req_info() {
  local -r _url=$1
  local -r _method=$2
  local -r _enlapsed_time=$3
  local -r _http_code=$4
  local -r _html_path=$5

  local _index=${#__REQUESTS_DATA_URL[@]}
  __REQUESTS_DATA_URL[$_index]="$_url"
  __REQUESTS_DATA_METHOD[$_index]="$_method"
  __REQUESTS_DATA_ENLAPSED_TIME[$_index]="$_enlapsed_time"
  __REQUESTS_DATA_HTTP_CODE[$_index]="$_http_code"
  __REQUESTS_DATA_HTML_PATH[$_index]="$_html_path"
  
  echo $_index  
}

function req::set_variable() {
  local -r _name=$1
  local -r _value=$2

  declare -g -r __request_$_name=$_value
}

function req::get() {
  local -r _uri=$1
  local _cookie=$2
  local _tmp_folder=$3
  local _allow_redirect=$4 

  [[ -z "$_cookie" ]] && _cookie="$__request_cookie"
  [[ -z "$_tmp_folder" ]] && _tmp_folder="$__request_tmp_folder"
  [[ -z "$_allow_redirect" ]] && _allow_redirect="$__request_allow_redirect"

  time::add_timer "_request" >/dev/null
  req::_print_request "$_uri" "$__request_url_base" "GET" 

  local           _url="$(req::_create_url $_uri)"
  local   _output_file="$(tmp::html $_tmp_folder)"
  local     _http_code="$(curl::get "$_url" "$_output_file" "$_cookie" $_allow_redirect)"
  local _enlapsed_time="$(time::enlapsed "$_request")"
  local         _index="$(req::_save_req_info "$_url" "$_enlapsed_time" "$_http_code")"
  
  curl::validate_request "GET" "$_url" "$_http_code"
  req::_save_req_info "$_url" "GET" "$_enlapsed_time" "$_http_code" >/dev/null
  req::_print_response "$_index" "$_http_code"
  if (( _enlapsed_time >= __request_max_exec_time )); then
    throw $RequestMaxExecutionTimeException
  fi
}

function req::post() {
  local -r _uri=$1
  local _data=$2
  local _cookie=$3
  local _tmp_folder=$4
  local _allow_redirect=$5

  [[ -z "$_cookie" ]] && _cookie="$__request_cookie"
  [[ -z "$_tmp_folder" ]] && _tmp_folder="$__request_tmp_folder"
  [[ -z "$_allow_redirect" ]] && _allow_redirect="$__request_allow_redirect"
  [[ -z "$_data" ]] && _data=$__request_data

  time::add_timer "_request" >/dev/null
  req::_print_request "$_uri" "$__request_url_base" "POST" 

  local           _url="$(req::_create_url "$_uri")"
  local   _output_file=$(tmp::html "$_tmp_folder")
  local     _http_code=$(curl::post "$_url" "$_data" "$_output_file" "$_cookie" "$_allow_redirect")
  local _enlapsed_time=$(time::enlapsed "_request")
  local         _index=$(req::_save_req_info "$_url" "$_enlapsed_time" "$_http_code")
  
  req::set_variable "data" # flush data 
  curl::validate_request "POST" "$_url" "$_http_code"
  req::_save_req_info "$_url" "POST" "$_enlapsed_time" "$_http_code" "$_output_file" >/dev/null 
  req::_print_response "$_index" "$_http_code"

  if (( _enlapsed_time >= __request_max_exec_time )); then
    throw $RequestMaxExecutionTimeException
  fi
}


function req::_print_request() {
  local -r _uri=$1
  local -r _host=$2
  local -r _method=$3

  io::newline
  io::writeln "${ORANGE}$_method${NC} $_uri"
  io::writeln "${BLUE}Host:${NC} $_host"
}

function req::_print_response() {
  local -r _index=$1
  local -r _http_code=$2

  local _enlapsed_time=${__REQUESTS_DATA_ENLAPSED_TIME[$_index]}
  io::writeln "${GREEN}HTTP/1.1 $_http_code $(req::_http_status $_http_code)${NC}"
  io::writeln "${BLUE}Enlapsed Time:${NC} $_enlapsed_time"
}

function req::_http_status() {
  local -r _http_code=$1

  case $_http_code in
    100) echo "CONTINUE";;
    101) echo "SWITCHING_PROTOCOLS";;
    102) echo "PROCESSING";;
    103) echo "EARLY_HINTS";;
    200) echo "OK";;
    201) echo "CREATED";;
    202) echo "ACCEPTED";;
    203) echo "NON_AUTHORITATIVE_INFORMATION";;
    204) echo "NO_CONTENT";;
    205) echo "RESET_CONTENT";;
    206) echo "PARTIAL_CONTENT";;
    207) echo "MULTI_STATUS";;
    208) echo "ALREADY_REPORTED";;
    226) echo "IM_USED";;
    300) echo "MULTIPLE_CHOICES";;
    301) echo "MOVED_PERMANENTLY";;
    302) echo "FOUND";;
    303) echo "SEE_OTHER";;
    304) echo "NOT_MODIFIED";;
    305) echo "USE_PROXY";;
    306) echo "RESERVED";;
    307) echo "TEMPORARY_REDIRECT";;
    308) echo "PERMANENTLY_REDIRECT";;
    400) echo "BAD_REQUEST";;
    401) echo "UNAUTHORIZED";;
    402) echo "PAYMENT_REQUIRED";;
    403) echo "FORBIDDEN";;
    404) echo "NOT_FOUND";;
    405) echo "METHOD_NOT_ALLOWED";;
    406) echo "NOT_ACCEPTABLE";;
    407) echo "PROXY_AUTHENTICATION_REQUIRED";;
    408) echo "REQUEST_TIMEOUT";;
    409) echo "CONFLICT";;
    410) echo "GONE";;
    411) echo "LENGTH_REQUIRED";;
    412) echo "PRECONDITION_FAILED";;
    413) echo "REQUEST_ENTITY_TOO_LARGE";;
    414) echo "REQUEST_URI_TOO_LONG";;
    415) echo "UNSUPPORTED_MEDIA_TYPE";;
    416) echo "REQUESTED_RANGE_NOT_SATISFIABLE";;
    417) echo "EXPECTATION_FAILED";;
    418) echo "I_AM_A_TEAPOT";;
    421) echo "MISDIRECTED_REQUEST";;
    422) echo "UNPROCESSABLE_ENTITY";;
    423) echo "LOCKED";;
    424) echo "FAILED_DEPENDENCY";;
    425) echo "RESERVED_FOR_WEBDAV_ADVANCED_COLLECTIONS_EXPIRED_PROPOSAL";;
    426) echo "UPGRADE_REQUIRED";;
    428) echo "PRECONDITION_REQUIRED";;
    429) echo "TOO_MANY_REQUESTS";;
    431) echo "REQUEST_HEADER_FIELDS_TOO_LARGE";;
    451) echo "UNAVAILABLE_FOR_LEGAL_REASONS";;
    500) echo "INTERNAL_SERVER_ERROR";;
    501) echo "NOT_IMPLEMENTED";;
    502) echo "BAD_GATEWAY";;
    503) echo "SERVICE_UNAVAILABLE";;
    504) echo "GATEWAY_TIMEOUT";;
    505) echo "VERSION_NOT_SUPPORTED";;
    506) echo "VARIANT_ALSO_NEGOTIATES_EXPERIMENTAL";;
    507) echo "INSUFFICIENT_STORAGE";;
    508) echo "LOOP_DETECTED";;
    510) echo "NOT_EXTENDED";;
    511) echo "NETWORK_AUTHENTICATION_REQUIRED";;
  esac
}

function req::_create_url() {
  local  _uri=$1

  local _base="${__request_url_base%/}"
  _uri="${_uri#/}"

  echo "$_base/$_uri"
}
