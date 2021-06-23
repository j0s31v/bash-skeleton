#!/bin/bash

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
SYS_DIR="$DIR/../../"

source "$SYS_DIR/lib/str.sh"
source "$SYS_DIR/lib/io.sh"
source "$SYS_DIR/lib/colors.sh"

colors::colorized

source "$SYS_DIR/lib/tmp.sh"
source "$SYS_DIR/lib/curl.sh"


readonly CURL_REQUESTS_STATUS="true"
readonly CURL_LAST_REQUEST_STATUS="true"
declare -g CURL_LAST_URL_REQUEST=""
readonly CURL_COOKIE="${TMP_DIR}/curl/curl_helper_cookie.txt"
readonly CURL_TIMEOUT=30
readonly CURL_USERAGENT="CURL/AGENT"
readonly CURL_FAIL_ON_ERROR="true"

curl::get "http://google.com"
#curl::post
#curl::post_json
#curl::verify_http_code
#curl::verify_valid_request
#curl::validate_request
#curl::reset_request_status
#curl::is_valid_requests