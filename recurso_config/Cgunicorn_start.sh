#!/bin/bash
NAME="n0app" # Nombre de la aplicación
DJANGODIR=/home/n1cuser/n2nentor/n3ndapp # Ubicación de donde esta tu proyecto django
SOCKFILE=/home/n1cuser/n2nentor/run/gunicorn.sock # Nos comunicaremos usando unix socket
USER=n4nuserd # Usuario del directorio donde esta la app
GROUP=n5nguserd # El grupo al que pertenece
NUM_WORKERS=3 # Cuantos procesos debería trabajar Gunicorn spawn
DJANGO_SETTINGS_MODULE=n0app.settings # El archivo de configuración donde esta
DJANGO_WSGI_MODULE=n0app.wsgi # WSGI module name
# Activamos el entorno virtual
cd $DJANGODIR
echo "************************************************";
source ../bin/activate
export DJANGO_SETTINGS_MODULE=$DJANGO_SETTINGS_MODULE
export PYTHONPATH=$DJANGODIR:$PYTHONPATH
echo "************************************************";
echo "introduce Ctrl + c para continuar.........xD";
# Creando el directorio run si por casualidad no existe. 
RUNDIR=$(dirname $SOCKFILE)
#echo "dirname tiene: $RUNDIR"
test -d $RUNDIR || mkdir -p $RUNDIR
exec ../bin/gunicorn ${DJANGO_WSGI_MODULE}:application \
	--name $NAME \
	--workers $NUM_WORKERS \
	--user=$USER \
	--group=$GROUP \
	--log-level=debug \
	--bind=unix:$SOCKFILE
