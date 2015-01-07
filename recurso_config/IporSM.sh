#!/bin/bash
echo "........................"
cd /home/nombre_directorio_usuario/nombre_entorno_virtual
echo "........................"
source bin/activate
echo "........................"
#*********************************************************
#importar archivos media y staticos
python /home/nombre_directorio_usuario/nombre_entorno_virtual/nombre_dir_app/manage.py collectstatic
deactivate
