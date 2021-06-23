#!/bin/bash

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
SYS_DIR="$DIR/../../"

source "$SYS_DIR/lib/str.sh"
source "$SYS_DIR/lib/io.sh"
source "$SYS_DIR/lib/colors.sh"

template::colors

io::title "Lorem ipsum dolor sir amet" 
io::comment "Lorem ipsum dolor sir amet"
io::success "Lorem ipsum dolor sir amet"
io::error "Lorem ipsum dolor sir amet"
io::warning "Lorem ipsum dolor sir amet"
io::note "Lorem ipsum dolor sir amet"
io::caution "Lorem ipsum dolor sir amet"
io::writeln "Lorem ipsum dolor sir amet"
io::write "Lorem ipsum dolor sir amet"

io::newline
io::hr
io::newline

io::list::title "Ejemplo de listas" "green"
io::list "sdfsdfsd"
io::list::ul "sdfsdfsd"
io::list::li "sdfsdfsd"
io::list::success "sdfsdfsd"
io::list::error "sdfsdfsd"

io::hr "magenta"

io::colorized "blue"
printf "texto de color azul\n"
io::colorized
printf "texto sin color\n"
