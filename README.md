# Script para tener un descargador masivo de videos multiusuario #

## Motivación ##

Antes que todo decir que este script está inspirado por la necesidad de muchos sysadmins cubanos que tienen que bajar a mano videos desde youtube para sus usuarios.

La idea original es de Roberto Estupiñan, sysadmin de la EICMA Camagüey, aunque yo ya había tenido una idea similar, el fue el que la completó y yo la hice realidad.

La idea es que los users puedan acceder a un server, poner en un file las URL del youtube y similares y en la noche el server las procesa y descarga; al amanecer el user revisa las carpetas de descarga y toma sus videos descargados.

OJO: El user debe eliminar el URL de la lista una vez descargado o el video será descargado de nuevo (TODO list...)

## Pre-requisitos ##

* Tener instalado la última versión de [youtube-dl](https://github.com/rg3/youtube-dl/) no se vale la del repositorio, la última...
* Un server Linux, no importa el sabor.
* Múltiples usuarios que acceden al server a sus carpetas personales (ssh/ftp/smb, el protocolo no importa) o incluso a carpetas compartidas públicas en la red; la lógica es que tiene que existir una carpeta padre dentro de la que hay carpetas de usuarios.
* Estas carpetas de usuarios tendrán un directorio donde pondremos las cosa a descargar y descargadas.
* Un fichero .txt que contendrá las URL de video de youtube y todos los otros servicios que youtube-dl soporta.

**Notas:**
* Este script no maneja los permisos, el esquema de permisos es muy particular de cada sysadmin/situación.
* Este script asume que tiene permisos de lectura y escritura en TODOS los directorios de usuario.
* Este script se distribuye con un ejemplo de directorios creados en un zip con ficheros de descargas con videos cortos en youtube para ejemplo.
* Se asume que el script es llamado cada cierto tiempo desde cron para ejecutarlo, el chequea y si ya existe ejecutándose muere.

## Probarlo... ##

* Descargue o clone el repositorio.
* Extraiga el script ytdl.sh, dele permisos de ejecución y pongalo en un lugar que usted o el user que ejecutará pueda acceder (/usr/local/bin es un buen lugar por ejemplo)
* Extraiga el comprimido Users.tar.gz en /tmp/ytdl
* Deberá tener una carpeta llamada ytdl (camino completo /tmp/ytdl/Users)
* Ejecute el script (ytdl.sh)
* Verifique el progreso en /tmp/ytdl.log

Y... si todo funciona... verá una pila de videos cómicos en sus respectivas carpetas de menos de 30 segundos cada uno...

## Disclaimer ##

Como siempre esto puede contener bugs, fallos, etc, usa la pestaña de Issues para reportarlos...

## Palabras finales ##

Si te gustó y resulta útil... si puedes dona algunos centavos a la causa (cell (+53) 53 847819) que los sysadmins/programadores también hablamos por celular...

Chau.
