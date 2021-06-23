#!/bin/bash

current_version=" v3.196.08 "
current_version=$(echo "$current_version" | xargs)
echo $current_version
echo "............................................."

preffix="v"
suffix="-"$(cut -d "-" -f2- <<< "$current_version")

version=${current_version#"$preffix"} 
version=${version%"$suffix"}
echo $version
echo "............................................."

mmp=( ${version//./ } )
#printf '%s\n' "${mmp[@]}"

#echo "-----------------"
#mayor=$(expr ${mmp[0]} + 1)
#minor=$(expr ${mmp[1]} + 1)
#patch=$(expr ${mmp[2]} + 1)

mayor=${mmp[0]}
minor=${mmp[1]}
patch=${mmp[2]}

echo $mayor
echo $minor
echo $patch
echo "............................................."
#printf "%02d\n" $patch # --> solo numeros

echo "${preffix}${mayor}.${minor}.${patch}${suffix}"

echo "............................................."
echo "Aumentando patch"
ma=${mayor}
mi=${minor}
pa=$(expr ${patch} + 1)
pa=$(printf "%02d\n" $pa)
echo "${preffix}${ma}.${mi}.${pa}${suffix}"

echo "............................................."
echo "Aumentando minor"
ma=${mayor}
mi=$(expr ${minor} + 1)
mi=$(printf "%03d\n" $mi)
pa=0
pa=$(printf "%02d\n" $pa)
echo "${preffix}${ma}.${mi}.${pa}${suffix}"

echo "............................................."
echo "Aumentando mayor"
ma=$(expr ${mayor} + 1)
mi=0
mi=$(printf "%03d\n" $mi)
pa=0
pa=$(printf "%02d\n" $pa)
echo "${preffix}${ma}.${mi}.${pa}${suffix}"

echo "#################################################################################################################"

echo "Add new stage pre-release # to new patch "
echo ">> v3.196.08"

current_version=" v3.196.08 "
current_version=$(echo "$current_version" | xargs)

preffix="v"
suffix="-"$(cut -d "-" -f2- <<< "$current_version")

version=${current_version#"$preffix"} 
version=${version%"$suffix"}

mmp=( ${version//./ } )

mayor=${mmp[0]}
minor=${mmp[1]}
patch=${mmp[2]}

# agregar el minor
ma=${mayor}
mi=${minor}
pa=$(expr ${patch} + 1)
pa=$(printf "%02d\n" $pa)


# agregar build -pre-release rc

# obtener el ultimo rc
suffix="-rc.01"


# si se elimina 
sffx="stage.0001"
echo "${preffix}${ma}.${mi}.${pa}${suffix}"

