#!/bin/bash
declare -g -A _SLACK_SEND_PARAMS=(
    ["channel"]=""
    ["message"]=""
    ["send_as"]="default_user"
    ["no_attach"]=0
    ["no_files"]=0
)

function usage() {
    cat <<EOF >&2

Usage: cmd  [options]

    Example:
        cmd [channel] [message] --send-as=[username] 

    channel          Nombre del escenario configurado
    message          Mensaje a enviar
    --send-as        Nombre del usuario como se enviara el mensaje
    --no-attach      No envia los mensajes adjuntados
    --no-files       No envia los archivos adjuntados                    
    -h| --help       Esta pantalla.
    
EOF
}

function slack_send_arguments() {
  
  local _channel=$1
  local _message=$2  
  local _send_as="default_user"
  local _no_attach=0
  local _no_files=0

  for arg in "$@"
  do
    case ${arg} in
      --send-as=*) _send_as="${arg#*=}" && shift ;;
      --no-attach) _no_attach=1 && shift ;;
       --no-files) _no_files=1 && shift ;;
        -h|--help) usage && exit 1 ;;
                *) shift ;;
    esac
    shift
  done
  
  _SLACK_SEND_PARAMS["channel"]=$_channel
  _SLACK_SEND_PARAMS["message"]=$_message
  _SLACK_SEND_PARAMS["send_as"]=$_send_as
  _SLACK_SEND_PARAMS["no_attach"]=$_no_attach
  _SLACK_SEND_PARAMS["no_files"]=$_no_files

}

function slack::cli::send() {
  if [[ ! -v __SLACK_IS_LOADED ]]; then
    readonly __SLACK_IS_LOADED=true

    source "${SYS_DIR}/lib/slack/slack.sh"
  fi
  
  slack_send_arguments $@

  local -r _channel=${_SLACK_SEND_PARAMS["scenario"]}
  local -r _message=${_SLACK_SEND_PARAMS["message"]}
  local -r _send_as=${_SLACK_SEND_PARAMS["send_as"]}
  local -r _no_attach=${_SLACK_SEND_PARAMS["no_attach"]}
  local -r _no_files=${_SLACK_SEND_PARAMS["no_files"]}
  
  #slack::send::run "$_channel" "$_message" "$_send_as" "$_no_attach" "$_no_files"
}
