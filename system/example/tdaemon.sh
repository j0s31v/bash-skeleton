#!/bin/bash
### BEGIN INIT INFO
# Provides:          {service}
# Required-Start:    $all
# Required-Stop:
# Default-Start:     2 3 4 5
# Default-Stop:
# Short-Description: Descripcion de {service}
### END INIT INFO

# configuration
declare -r DIR=/home/roy/test_daemon/


function start(){
  cd $DIR
  echo "hola mundo!!" > daemon.out
  echo "Start" >> daemon.out
  ls >> daemon.out

  setsid /home/roy/test_daemon/prueba.sh >/dev/null 2>&1 < /dev/null &
  #sudo start-stop-daemon --start --user root --startas "/home/roy/test_daemon/prueba.sh" --make-pidfile --pidfile "/home/roy/test_daemon/tdaemon.pid"  -b
  # al apagarlo queda funcionando hay que apagar y matar el proceso

}

function stop(){
  #RUBYPID=`ps aux | grep "ruby script/server -d -e production" | grep -v grep | awk '{print $2}'`
  #if [ "x$RUBYPID" != "x" ]; then
  #  kill -2 $RUBYPID
  #fi  
  cd $DIR
  echo "Stop !!!" >> daemon.out
  kill $(ps -fade | grep prueba.sh | grep -v grep | awk '{print $2}')
}

# Check if Redmine is running
function status(){
  #RUBYPID=`ps aux | grep "ruby script/server -d -e production" | grep -v grep | awk '{print $2}'`
  #if [ "x$RUBYPID" = "x" ]; then
  #  echo "* Redmine is not running"
  #else
  #  echo "* Redmine is running"
  #fi
  cd $DIR
  echo "status" >> daemon.out
}


case "$1" in
  start)
    start
    ;;
  
  stop)
    stop
    ;;
  
  status)
    status
    ;;
  
  restart|force-reload)
    stop
    start
    ;;

  *)
    echo "Usage: $0 {start|stop|restart|force-reload|status}"
    exit 1

esac