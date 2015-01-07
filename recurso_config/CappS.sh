#!/bin/bash
direccion_gitremoto_app='';
function ClonarR()
{
	echo "clonando el repositorio en el servidor........";
	cd /home/nombre_directorio_usuario/nombre_entorno_virtual
	git clone $1
	if [ "$?" -ne "0" ]
	then 
		
		echo "la ruta del repositorio remoto no se encuentra o esta mal escrita........";
		#puede volver a pedir la direccion atra ves		
		#Exit
		echo "volver a introducir la dirección o presionar Ctrl + c para salir de la instalación ........";	
		PRM
		ClonarR $direccion_gitremoto_app
	else 
		echo "El repositorio se clono correctamente en el servidor........" ;
	fi
	#cd ..;
}

function PRM()
{
	echo "Introduce la direccion del repositorio remoto....... ";
	read direccion_gitremoto_app;
	#direccion_gitremoto_app='https://github.com/GOG1991/aserprueba';
}
PRM
ClonarR $direccion_gitremoto_app
