#!/bin/bash

if [[ ! -v __LIB_SLACK_IS_LOADED ]]; then
  readonly __LIB_SLACK_IS_LOADED=true

  # NECESITA PLUGIN WEBHOOK PARA FUNCIONAR
  declare -g -A __LIB_SLACK_ATTACH_MESSAGES=()
fi

function slack::send::message() {
  local -r _channel=$1
  local -r _message=$2
  
  local _json=$(slack::_json_message "$_channel" "$_message" | jq -c)

  slack::_curl_post "$_json"
}

function slack::attach() {
  local -r _message=$1

  local _index=${#__LIB_SLACK_ATTACH_MESSAGES[@]}
  __LIB_SLACK_ATTACH_MESSAGES[$_index]="$_message"
}

function slack::send::attach() {
  local -r _channel=$1
  local -r _title=$2
  local -r _level=$3
  local -r _message=$4

  local _attachment=""
  local _color=$(slack::_color_by_level $_level)

  for ((_index=0;_index<${#__LIB_SLACK_ATTACH_MESSAGES[@]};_index++))
  do
    local _item=${__LIB_SLACK_ATTACH_MESSAGES[$_index]}
    _attachment+="${_item}\n"
  done
  slack::_reset_attach

  local _json=$(slack::_json_attach "$_channel" "$_color" "$_message" "$_title" "$_attachment" | jq -c)

  slack::_curl_post "$_json"
}

function slack::_json_message() {
  local -r _channel=$1
  local -r _message=$2

  local _username=$SLACK_SENDER_NAME
  local _usericon=$SLACK_SENDER_ICON

  cat <<EOF
    {
        "channel": "$_channel",
        "username": "$_username",
        "icon_emoji": "$_usericon",
        "text": "$_message"
    }
EOF
}

function slack::_json_attach() {
  local -r _channel=$1
  local -r _color=$2
  local -r _pretext=$3
  local -r _title=$4
  local -r _text=$5

  local _username=$SLACK_SENDER_NAME
  local _usericon=$SLACK_SENDER_ICON

  cat <<EOF
    {
        "channel": "$_channel",
        "username": "$_username",
        "icon_emoji": "$_usericon",
        "attachments": [
          {
            "color": "$_color",
            "pretext": "$_pretext",
            "title": "$_title",
            "text": "$_text"
          }
        ]
    }
EOF
}

function slack::_color_by_level() {
  local -r _level_name=$1

  case $_level_name in
       "info") echo "#FF00FF";;
    "warning") echo "#00FFFF";;
      "error") echo "#FF0000";;
            *) echo "#FFFF00";;
  esac
}

function slack::_reset_attach() {
  __LIB_SLACK_ATTACH_MESSAGES=() # flush
}

function slack::_curl_post() {
  local _message=$1

  local _params=(
      "$SLACK_WEBHOOK" 
      --compressed  
      --location
      --write-out "%{http_code}"
      --silent 
      --insecure
      -X POST 
      -H 'Content-type: application/json' 
      --data "$_message"
    )

  curl "${_params[@]}" 1>/dev/null 2>/dev/null
}