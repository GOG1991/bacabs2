#!/bin/bash
echo "........................"
cd /home/nombre_directorio_usuario/nombre_entorno_virtual
echo "........................"
source bin/activate
echo "........................" 
pip install -r /home/nombre_directorio_usuario/nombre_entorno_virtual/nombre_dir_app/requirements.txt
echo "........................"
pip freeze

echo ".....................................";
#python manage.py runserver 104.131.3.169:8000
echo "intruduce Ctrl + c para contnuar...........xD";
python /home/nombre_directorio_usuario/nombre_entorno_virtual/nombre_dir_app/manage.py runserver hostx:puertox1
echo "fallo la conexion revisa el puerto de gunicor";
deactivate

