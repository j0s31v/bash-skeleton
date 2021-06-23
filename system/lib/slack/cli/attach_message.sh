#!/bin/bash
declare -g -A _SLACK_ATTACH_PARAMS=(
    ["message"]=""
    ["sender"]="default"
)

function usage() {
    cat <<EOF >&2

Usage: cmd  [options]

    Example:
        cmd [channel] [message]

    message          Mensaje a adjuntar
    --sender         Nombre de quien enviara los mensajes.                    
    -h| --help       Esta pantalla.
    
EOF
}

function slack_attach_arguments() {
  
  local _message=$1
  local _sender="default"

  for arg in "$@"
  do
    case ${arg} in
      --sender=*) _sender="${arg#*=}" && shift ;;
        -h|--help) usage && exit 1 ;;
                *) shift ;;
    esac
    shift
  done
  
  _SLACK_ATTACH_PARAMS["message"]=$_message
  _SLACK_ATTACH_PARAMS["sender"]=$_sender

}

function slack::cli::attach::message() {
  if [[ ! -v __SLACK_IS_LOADED ]]; then
    readonly __SLACK_IS_LOADED=true

    source "${SYS_DIR}/lib/slack/slack.sh"
  fi
  
  slack_attach_arguments $@

  local -r _message=${_SLACK_ATTACH_PARAMS["message"]}
  local -r _sender=${_SLACK_ATTACH_PARAMS["sender"]}

  #slack::attach::message "$_message" "$_sender"
}
