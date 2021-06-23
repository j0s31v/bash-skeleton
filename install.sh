#!/bin/bash  

CURRENT_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
source "${CURRENT_DIR}/system/cli/command.sh"
source "${SYS_DIR}/lib/os.sh"

readonly SUDO_CMD=`which sudo`
readonly USERNAME='perkins'

function usage() {
  cat <<EOF >&2

Usage: $0 [options]

    Example:
        $0 --version

      -h  --help                Esta pantalla.
      -v  --version             Version.
      --assume-yes|--vo-dale    Automaticamente asume como SI a todas las opciones en que se pregunte
      --install-dir             Seleccionar la carpeta de instalación 
      --build-only              Genera lo que sera instalado
    

EOF
exit 0
}

function validate_os() {
  OS=$(os::get_os_name)
  case $OS in
    'DEBIAN')
      if [[ ! "$(whoami)" == "root" ]]; then
        io::list::error "Instalación necesita ejecutarse como root en Debian!!"
        io::list::error "Se requiere el comando sudo instalado en el sistema."
        exit 1
      fi
    ;;
    'UBUNTU') ;;
    *)
      io::list::error "Instalación solo esta disponible para Debian y Ubuntu"
      exit 1
    ;;
  esac
  io::list::success "Sistema operativo detectado: $OS"  
}

function verify_and_install_packages() {

  local -A _packages_to_install=()

  while IFS= read -r _pkg
  do
    io::list::ul "Verificando ${_pkg}"

    if [[ $(os::is_installed_package "${_pkg}") ]]; then
      io::list::success "${_pkg} esta instalado."
    else
      io::list::error "${_pkg} no esta instalado"
      _packages_to_install+=("$_pkg")
    fi
  done < "requirements.list"

  if [[ -z ${_packages_to_install} ]]; then
    io::list::success "Todas las dependencias estan instaladas"
    return 0
  fi

  io::list::title "Se instalaran las dependencias faltantes"
  
  io::list::ul "Actualizando los repositorios"
  $SUDO_CMD apt-get update >/dev/null 2>&1

  for _pkg in ${_packages_to_install[@]}; do

    io::list::ul "Instalando el package ${_pkg}"
    $SUDO_CMD apt-get install "${_pkg}" >>/var/tmp/${_pkg}_install_package_output 2>&1

    if [[ ! $(os::is_installed_package "${_pkg}") ]]; then
        io::list:error "No se pudo instalar el package '${_pkg}'"
    fi
  done
}

function prepare_to_install() {
  local -r _install_dir=$1

  io::list::ul "Creando la estructura de carpetas en ${_install_dir}"

  local _folders=( 
    "${_install_dir}"
    "${_install_dir}/var/log"
    "${_install_dir}/var/tmp"
  )

  for _folder in ${_folders[@]}; do
    io::list::ul "Creando la carpeta ${_folder}"
    $SUDO_CMD mkdir -p ${_folder} > /dev/null 2>&1
    if [[ ! -d ${_folder} ]];then
      io::list::error "Carpeta ${_folder} no pudo ser creada"
      error "No se ha podido verificar la existencia de la carpeta '${_folder}'. Se detiene la instalación"
    fi
  done

}

function generate-build() {

  io::list::ul "Limpiando la carpeta build"
  rm -rf ${CURRENT_DIR}/build 

  local _params=(
    -avh ${CURRENT_DIR}/ ${CURRENT_DIR}/build/ 
    --exclude build 
    --exclude .git 
    --exclude .gitignore 
    --exclude .gitlab-ci.yml
    --exclude install.sh
    --exclude var
    --exclude application/config/parameters.yml
    --exclude application/config/parameters.yml.dist
    --exclude .gitkeep
  )

  io::list::ul "Contruyendo el build"
  rsync "${_params[@]}" >/dev/null 2>&1

  io::list::ul "Generando el archivo de configuracion parameters.yml"
  cp ${CURRENT_DIR}/application/config/parameters.yml.dist  ${CURRENT_DIR}/build/application/config/parameters.yml

}

function app_install() {
  local -r _install_dir=$1
  
  if id "$USERNAME" &>/dev/null; then
    io::list::ul "El usuario $USERNAME ya existe en el sistema."
  else

    io::list::ul "El usuario $USERNAME no existe, creandolo en el sistema."

    local _params=(
      --shell /bin/bash 
      --home /home/$USERNAME
      $USERNAME
    )
    $SUDO_CMD adduser "${_params[@]}" >/dev/null 2>&1

    io::list::ul "Asignando contraseña aleatoria."
    local -r _pass="$(< /dev/urandom tr -dc "[:alnum:]" | head -c250)"
    echo -e "$_pass\n$_pass" | $SUDO_CMD passwd $USERNAME >/dev/null 2>&1
  fi
  
  io::list::ul "Copiando los archivos a la carpeta '${_install_dir}'"
  $SUDO_CMD rsync -avh ${CURRENT_DIR}/build/ ${_install_dir}/ >/dev/null 2>&1

  io::list::ul "Asignando permisos a la carpeta de instalación."
  $SUDO_CMD chown -R $USERNAME:$USERNAME ${_install_dir}/
  $SUDO_CMD chmod 764 -R ${_install_dir}/var

  io::list::ul "Agregando la carpeta '${_install_dir}/var/log/' al logrotate"
cat <<EOF > /etc/logrotate.d/${APP_NAME}
${_install_dir}/var/log/*.log {
  daily
  missingok
  rotate 14
  compress
  delaycompress
  create 0755 root root
}
EOF
  
  io::list::ul "La instalacion de los servicios asociados se haran de forma manual, por ahora...."
}

# proceso de instalacion  
function main() {

  local -r _install_dir=${_argv['install-dir']}
  local -r  _assume_yes=${_argv['assume-yes']}
  local -r  _build_only=${_argv['build-only']}

  if [[ "$_build_only" = 1 ]]; then 
    io::list::title "Generando el build de la aplicacion"
    generate-build
    return 0
  fi

  if [[ $_install_dir == "" || $_install_dir == "/" ]]; then
    io::error "No se puede instalar en la carpeta ${_install_dir}"
    exit 1
  fi

  if [[ -d "${_install_dir}" ]];then
    io::warning "La carpeta en donde se instalara la aplicacion ya existe!!"
    io::warning "Continuar con la instalación reemplazara los archivos ya existentes"

    if [[ "$_assume_yes" = 0 ]]; then 
      read -n 1 -p "Desea reemplazar los archivos existentes? [s/N]: " -i "N" answer
      case $answer in
      s|S) echo -n ""; ;;
      n|N) echo -n ""; exit 1 ;;
        *) echo -n ""; msg::error "ERROR: Opción no soportada, abortando instalación!"; exit 1 ;;
      esac
    fi

    io::newline
    io::warning "Se procede a reemplazar los archivos!!."
    io::newline
  fi

  io::title "Instalando ${APP_NAME}#${APP_VERSION}"
  io::newline

  io::list::title "Verificando Sistema operativo"
  validate_os

  io::list::title "Verificando Dependencias"
  verify_and_install_packages  

  io::list::title "Generando build de la aplicación"
  generate-build

  io::list::title "Preparando el sistema para la instalación"
  prepare_to_install "${_install_dir}"

  io::list::title "Instalando la aplicacion"
  app_install "${_install_dir}" 

  io::list::title "Instalacion exitosa!!"

}

declare -A -g _argv=(
  ["install-dir"]="/opt/${APP_NAME}"
  ["assume-yes"]=0
  ["build-only"]=0
)

for _arg in "$@"; do  
  case ${_arg} in
    --install-dir=*)
      _argv["install-dir"]="${_arg#*=}"
      shift
    ;;
    --assume-yes|--vo-dale)
      _argv["assume-yes"]=1
      shift
    ;;
    --build-only)
      _argv["build-only"]=1
      shift
    ;;
    --help) 
      usage 
    ;;
  esac
  shift
done

# install --assume-yes --install-folder
excecute $@
