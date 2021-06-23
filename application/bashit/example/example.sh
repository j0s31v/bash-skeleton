#!/bin/bash

if [[ ! -v __PERKINS_SCENARIO_IS_LOADED ]]; then
  readonly __PERKINS_SCENARIO_IS_LOADED=true

  readonly SCENARIO_DIR="${APP_DIR}/perkins/scenario"
  readonly -A LOADED_SCENARIOS=(
    ["check_po3_login_status"]="${SCENARIO_DIR}/proactiveoffice/check_po3_login_status.sh" 
    ["check_po3_status"]="${SCENARIO_DIR}/proactiveoffice/check_po3_status.sh"  
  )

  declare -g  __SCENARIO_OUTPUT_STATUS_FILE="$LOG_DIR/output_status_scenario.log"

  add_exception "IsNotValidRequestException" 100 "Is Not Valid Request" 
  add_exception "MaxExcecutionTimeException" 101 "Max Excecution Time"
fi

function scenario::run {
  local -r _scenario=$1
  local -r _env=$2
  local _output_status_file=$3

  if [[ " ${SCENARIO_AVAILABLE_ENVIRONMENTS[*]} " != *" $(str::lower "$_env") "* ]];then
    failed "environment $_env no configurado!!"
  fi
  
  [[ -z "$_output_status_file" ]] && __SCENARIO_OUTPUT_STATUS_FILE=$_output_status_file

  local _url_base=$(eval "echo \$SCENARIO_"$(str::upper "$_env")"_URL_BASE")
  local _username=$(eval "echo \$SCENARIO_"$(str::upper "$_env")"_USERNAME")
  local _password=$(eval "echo \$SCENARIO_"$(str::upper "$_env")"_PASSWORD")
  local _max_execution_time=$SCENARIO_DEFAULT_MAX_TIME  
  local _tmp_folder=$(tmp::folder "scenario")
  local _cookie=$(tmp::cookie "$_tmp_folder")
  
  if [[ `type -t scenario::${_scenario}::run`"" != 'function' ]] ; then
    source ${LOADED_SCENARIOS[$_scenario]}
  fi

  try 
  (

    log::debug "Se ejecuta WEB ESCENARIO"
    log::debug "========================================"
    log::debug "          scenario= $_scenario"
    log::debug "               env= $_env"
    log::debug "               url= $_url_base"
    log::debug "           timeout= $CURL_TIMEOUT"
    log::debug "max_execution_time= $_max_execution_time"
    log::debug "========================================"

    time::add_timer "scenario_run" >/dev/null
        
    scenario::${_scenario}::run "$_url_base" "$_username" "$_password" "$_tmp_folder" "$_cookie" "$_max_execution_time"  
        
    (( ($(time::enlapsed "scenario_run")-$_max_execution_time) > 0 )) && throw $MaxCurlExcecutionTimeException
    [[ "$(curl::is_valid_requests)" == "false" ]] && throw $IsNotValidCurlRequestException

    io::newline
    io::writeln "[OK] Finalizada ejecución del scenario ${_scenario} ${_url_base}!!"

    scenario::save_last_status "[success] ${_url_base}"

  ) 
  catch || {

    scenario::save_last_status "[error] ${_url_base}"   
    case $ex_code in
      $MaxCurlExcecutionTimeException) log::error "Escenario '${_scenario}' excede el tiempo de execucion permitido ${_max_execution_time} " ;;
      $IsNotValidCurlRequestException) log::error "Ocurrio un error al un request del scenario '${_scenario}'" ;;
            $FailCurlRequestException) log::error "Curl request exception del scenario '${_scenario}'" ;;
                                    *) log::error "Ocurrio algun error al ejecutar el scenario '${_scenario}'" ;;
    esac

  }

  curl::reset_request_status
  
}

function scenario::save_last_status() {
  local -r _msg=$1
  echo "${_msg}" > "$__SCENARIO_OUTPUT_STATUS_FILE"
}
