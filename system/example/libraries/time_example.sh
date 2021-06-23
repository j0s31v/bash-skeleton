#!/bin/bash

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
SYS_DIR="$DIR/../../"

source "$SYS_DIR/lib/str.sh"
source "$SYS_DIR/lib/io.sh"
source "$SYS_DIR/lib/colors.sh"

colors::colorized

source "$SYS_DIR/lib/time.sh"

io::title "Ejemplo funcionamiento libreria time"

io::write "time::add_timer starter at => "
io::colorized "green"
io::writeln "$(time::add_timer "timer")"  
io::colorized

io::write "time:epoch => "
io::colorized "green"
io::writeln "$(time::epoch)"  
io::colorized

io::write "time::now => "
io::colorized "green"
io::writeln "$(time::now)"  
io::colorized

io::write "time::today => "
io::colorized "green"
io::writeln "$(time::today)"  
io::colorized

sleep 5

io::write "time::enlapsed \"time enlapsed of timer\" => "
io::colorized "green"
io::writeln "$(time::enlapsed "timer")"  
io::colorized

