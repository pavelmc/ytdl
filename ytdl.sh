#!/bin/bash

#############################################################################
# Youtube mass downloader
#
# Autor: Pavel Milanes, pavelmc@gmail.com
# Consultor en TIC Conas, Cuba.
#
# Descargar videos de youtube desde archivos personales en carpetas de users
# desde un server.
#
# WARNING: yo no toco los permisos, es su responsabilidad que el script tenga
# los permisos necesarios para entrar a las carpetas de users.
#
# Idea de Roberto Estupiñan, sysAdmin EICMA CMW
##############################################################################

# carpeta que contiene los directorios de usuarios, todas las carpetas de primer
# nivel que estén debajo de esta es considerada una carpeta de usuario
#
# WARNING!!!!
# las carpetas de usuario no pueden tener espacios en los nombres
MF="/tmp/ytdl/Users"

# carpeta en el directorio de usuario donde trabajaremos
UFD="youtube-down"

# nombre del fichero donde el user tiene que poner los URLs a descargar
UF="download-list.txt"

# Carpeta dentro del UFD donde pondré las descargas.
UFF="Descargados"

# La estructura debe quedar como esto por ejemplo:
#
# Users/
#      /pavelmc/
#              youtube-down/
#                          Descargados/ <- aqui se ponen los videos al final
#                          download-list.txt <- aqui esta la lista de URLs
#      /yayo/ <- mismo para otro usuario

# Configuración del proxy, solo la declaras si la usas
# si estas directo usa
# val=""
http_proxy="http://pavelmc:mipassword@proxy.red.cu8080/"
https_proxy="http://pavelmc:mipassword@proxy.red.cu8080/"
export http_proxy
export https_proxy

###################################################################
# De aqui en adelante son variables de trabajo, no tocar

# Fichero temporal para almacenar URL|USER
TMP=`tempfile`
# Temp para la prueba de si está corriendo
TF="/tmp/test"
# Donde está el ejecutable
YTDL=`which youtube-dl`
# Log de corrida...
LOG="/tmp/ytdl.log"


###################################################################
## Funcion que recopila la info de las cosas a bajar y..
## las pone en un fichero temporal
###################################################################
function get_data() {
    # hacer un ciclo y recoger las URL si el usuario las ha declarado
    for user in `ls Users`; do
        # testear si es un directorio, para evitar problemas
        if [ -d "$MF/$user" ] ; then
            # definir una var del path del user para cada user
            UFOLDER="$MF/$user/$UFD/$UFF"
            UFILE="$MF/$user/$UFD/$UF"
            # verificar que existe el fichero de descargas y que es leible
            # solo hacer si existe y puedo leer.
            if [ -e "$UFILE" ] && [ -r "$UFILE" ] ; then
                # volcar contenido para prueba
                VIDC=`cat "$UFILE"`
                for sv in $VIDC ; do
                    echo "$UFOLDER|$sv" >> $TMP
                done
            else
                # file no existe lo creo para que el user sepa que es ahí
                touch "$UFILE"
            fi
        fi
    done

    # en este punto en $TMP (que es un fichero) tengo las URL donde tengo que
    # descargar las cosas y las URL que tengo que descargar
}


#####################################################################
## Descargador...
## $1 es el lugar donde debo ponerlo
## $2 es la URL
#####################################################################
function download() {
    echo "Descargando $2 en $1" >> "$LOG"

    # crear el dir destino si no existe, ignorar error si ya existe
    mkdir "$1" &> /dev/null
    # cambiarme a el
    cd "$1"

    # magia....
    $YTDL -i --proxy "$http_proxy" -R 20 -c -f 18 \
    --write-description --prefer-free-formats \
    --write-sub --all-subs -v "$2" >> "$LOG"
}


#####################################################################
## Saca las cosas del temp y se las pasa al downloader...
#####################################################################
function parse(){
    # hora de sacar la pulpa y
    for line in `cat $TMP` ; do
        DIR=`echo $line | cut -d "|" -f 1`
        URL=`echo $line | cut -d "|" -f 2`

        download "$DIR" "$URL"
    done
}


#####################################################################
## La candela es aqui...
#####################################################################

# verificar que está el soft.
if [ -z "$YTDL" ] ; then
    # No tienes el ejecutable... GGGGRRRR
    echo "No se donde diablos metiste el youtube-dl..."
    echo "descargalo, instálao y luego me llamas..."

    echo "No se donde está el youtube-dl WTF!" >> "$LOG"
else
    # tenemos papa
    echo "Youtuble DL encontrado en: $YTDL" >> "$LOG"

    # verificar si estoy corriendo
    ps aux | grep youtube-dl | grep -v grep > $TF

    if [ -s "$TF" ] ; then
        echo "$date está corriendo" >> "$LOG"
    else
        echo "A pinchar...."  >> "$LOG"
        # luces, cámara... acción:
        get_data

        # chequear que tengo algo que descargar
        if [ -s "$TMP" ] ; then
            # ok, hay algo que descargar...
            #ciclo por el con el download
            parse
        fi
    fi

fi


# limpiar la casa
rm $TMP
