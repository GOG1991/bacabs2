#!/bin/bash
#script para realizar dployd
#variables
host='';
#agregar dominio o ip del servidor
dominio='192.168.1.50'; 
gun1='8370';
gun2='8371';
nombre_usuario_directorio='';
nombre_app='';
nombre_dir_app='';
direccion_gitremoto_app='';
puerto_nginx='';
vercion_python='';
manage='manage.py';
settings='settings.py';
requirements='requirements.txt';
wsgi='wsgi.py';
Ldirectorio='';
Adirectorio='';
nasuper='';
nanginx='';
###FUNCIONES
function Limpiar_D()
{
	clear
	rm -r -f config_r/*
	rm -r -f recurso_app/*
	rm -r -f config_app/*

}
function Exit()
{
	if read -t 10 -p "Corrija correctamente su aplicacion para continuar con el proceso ..........  " 
	then
		Limpiar_D
		exit
	else
		Limpiar_D
		exit
	fi
}
function Limpiar_CrearD()
{
	clear
	mkdir -p config_r recurso_app config_app
	rm -r -f config_r/*
	rm -r -f recurso_app/*
	rm -r -f config_app/*

}
function Mgunicor_statrt() 
{
	echo " preparando script Cgunicor_statrt.sh para la configurarcion........";
	sed -e 's/n0app/'$1'/g' -e 's/n1cuser/'$2'/g' -e 's/n2nentor/'$3'/g' -e 's/n3ndapp/'$4'/g' -e 's/n4nuserd/'$5'/g' -e 's/n5nguserd/'$5'/g' recurso_config/Cgunicorn_start.sh > config_r/Cgunicorn_start.sh;
	echo "script Cgunicor_statrt.sh configurado........";
}

function Mapp_conf()
{
	echo " preparando el archivo CSapp.conf para la configurarcion........";
	sed -e 's/n0app/'$1'/g' -e 's/n1cuser/'$2'/g' -e 's/n2nentor/'$3'/g' -e 's/rootx1/'$4'/g' recurso_config/CSapp.conf > config_r/CS$nombre_app$nombre_usuario_directorio.conf;

	echo "Archivo CS$nombre_app$nombre_usuario_directorio.conf creado........";
nasuper="CS$nombre_app$nombre_usuario_directorio.conf";
}
function MNapp_conf()
{
	echo " preparando el archivo CNapp.conf para la configurarcion........";
	sed -e 's/n0app/'$1'/g' -e 's/n1cuser/'$2'/g' -e 's/n2nentor/'$3'/g' -e 's/n6puerte/'$4'/g' -e 's/n7host/'$5'/g' recurso_config/CNapp.conf > config_r/CN$nombre_app$nombre_usuario_directorio.conf;

	echo "Archivo CN$nombre_app$nombre_usuario_directorio.conf creado........";
nanginx="CN$nombre_app$nombre_usuario_directorio.conf";
}
function ClonarR()
{
	echo "clonando el repositorio........";
	cd recurso_app/;
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
		echo "El repositorio se clono correctamente........" ;
	fi
	cd ..;
}

function Localisar()
{
	
	Ldirectorio=$(find . -name $1 );
	if [ "$Ldirectorio" != "" ]
	then 
		
		echo "Archivo localisado, se encuentra en el directorio $Ldirectorio";
			
	else 
		echo "El uarchivo $nombre_archivo no existe en el directorio";
		Exit 
	fi
}
function ObtenerD()
{
	Adirectorio=$(dirname $1);
	if [ "$Adirectorio" != "" ]
	then 
		
		echo "la Ruta del archivo es $Adirectorio";
			
	else 
		echo "El uarchivo $nombre_archivo no existe en el directorio" ;
		Exit 
	fi	
}
function Msenttings_py()
{
	echo " preparando el archivo settings.py para la configurarcion........";
 
	staticroot=$(sed -n -e '/STATIC_ROOT/p' $loc_settings);
	echo $staticroot;
	mediaroot=$(sed -n -e '/MEDIA_ROOT/p' $loc_settings);
	echo $mediaroot;
	sed -e "s:$staticroot:STATIC_ROOT = '/home/$nombre_directorio_usuario/$nombre_entorno_virtual/static/':g" -e "s:$mediaroot:MEDIA_ROOT = '/home/$nombre_directorio_usuario/$nombre_entorno_virtual/media/':g" $loc_settings > config_app/settings.py
	echo "Archivo settings.py configurado........";
}
######################################
#pedir parametros
Limpiar_CrearD
function PIP()
{
	read -p "dame la ip del servidor: " host;
	#host='192.168.1.50';
	read -p "dame el puerto ssh del servidor: " portssh;
	ssh root@$host -p$portssh echo "conectando........";
	if (( "$?" != "0" ))
	then
		echo "la conexion fallo, asegurate de introducir la IP del servidor correcta, o el puerto ssh correcto  preciona Ctrl + c para salir........";
	PIP
	else
		echo "conexion realizada exitosa mente........";
	fi
}
#pedir ip
PIP
#clonar el repositorio remoto
function PRM()
{
	read -p "Introduce la direccion del repositorio remoto: " direccion_gitremoto_app;
#direccion_gitremoto_app='https://github.com/GOG1991/aserprueba';
}
PRM
ClonarR $direccion_gitremoto_app
#localizar los archivos y rutas
Localisar $manage
Localisar $settings
ObtenerD $Ldirectorio
loc_settings=$Ldirectorio;
ruta_settings=$Adirectorio;
Localisar $requirements
ObtenerD $Ldirectorio
ruta_requirements=$Adirectorio;
Localisar $wsgi
#pedir nombre de la appp
function Nomapp()
{
	read -p "Dame el nombre de la app: " nombre_app;
	#nombre_app='aser'
	 nombre_dir_app=$(ls recurso_app/);
	echo "Directorio base de la app: $nombre_dir_app";
	Appdirectorio=$(find . -name $nombre_app );
	if [ "$Appdirectorio" != "" ]
	then 
		
		echo "Nombre localisado, se encuentra en el directorio $Appdirectorio............"
			
	else 
		echo "El Nombre $nombre_app de la aplicasion no conincide. asegurese de que la aplicacion contenga la estrutura requerida........";
		Exit 
	fi
	nombre_entorno_virtual="entorno$nombre_app";
	echo "el entrono virtual se llamara: $nombre_entorno_virtual"; 
}
Nomapp
##################
function PideNUseryApp()
{
	read -p "Dame el nombre del Usuario para la aplicasion: " nombre_usuario_directorio;
	#nombre_usuario_directorio='nombre';
	
}
function CreaUserDir()
{
	
	nombre_directorio_usuario="dir$nombre_usuario_directorio$nombre_app";
	#--system
	ssh root@$host -p$portssh useradd --system -d /home/$nombre_directorio_usuario -m -s /bin/bash $nombre_usuario_directorio
	if [ "$?" -ne "0" ]
	then 
		echo "el usuario $nombre_usuario_directorio ya existe dame otro nombre, introduce Ctrl +c para salir";
		PideNUseryApp
		CreaUserDir 	
	else 
		echo "El usuario $nombre_usuario_directorio se creo correctamente........" ; 
		ssh root@$host -p$portssh chown -R $nombre_usuario_directorio:$nombre_usuario_directorio /home/$nombre_directorio_usuario
	fi

}
#pide usuario de app
PideNUseryApp
#crea usuario de app
CreaUserDir 
#pedir datos de la bd esapareser
function PDBD()
{

	read -p "Dame el nombre del usuario de la base de datos: " nombre_user_bd;
	nombre_user_bd='aser_adminbd2';
	read -p "dame el passwd del usuario de la base de datos: " passwd_userbd;
	passwd_userbd='JUvX8O08';
	read -p "dame el nobre de la base de datos: " nombre_base_datos;
	nombre_base_datos='aserdb080814';

}
#PDBD
#pedir vercion de Python y pueto Nginx sshhh
function PVercPNginxSsh()
{
	read -p "Dame el puerto por el cual escucha Nginx: " puerto_nginx;
	#puerto_nginx='80';
	read -p "Dame el numero de la vercion de Python ejemplo 2.7, 3.0, 3.4 : " vercion_python;
}
PVercPNginxSsh
#ssh $userservidor@$dominio -p$puerto 'apt-get update'
###############################################
#modificar el archivo Cgunicor_statrt.sh y rediereccionarlo a carpeta config_r
Mgunicor_statrt $nombre_app $nombre_directorio_usuario $nombre_entorno_virtual $nombre_dir_app $nombre_usuario_directorio
#modificar el archivo CSapp.conf y rediereccionarlo a carpeta config_r
Mapp_conf $nombre_app $nombre_directorio_usuario $nombre_entorno_virtual $nombre_usuario_directorio
#modificar el archivo CNapp.conf y rediereccionarlo a carpeta config_r
MNapp_conf $nombre_app $nombre_directorio_usuario $nombre_entorno_virtual $puerto_nginx $dominio

#revisar que el archivo senttings 
#Rsenttings_py
#modificar el fichero senttings.py y redirecionarlo a config_app
Msenttings_py

#comensar con la actualizacion del sistema
function ActualizarSO()
{
	ssh root@$host -p$portssh apt-get -y $1
	if (( "$?" == "0" ))
	then 
		echo "........"
	else
		echo "el servicio no dio respuesta puede ser que notengas conexion a internet o que el servicio ya no tenga soporte";
		Exit
	fi
}
ActualizarSO update
ActualizarSO upgrade
#instalar dependencias
function InstalarD()
{
	ssh root@$host -p$portssh apt-get -y install $1
	if (( "$?" == "0" ))
	then 
	echo "la dependencia $1 se instalo correctamente"
	else
		echo "la dependencia $1 no tubo respuesta, puede ser que notengas conexion a internet o que la dependencia ya no tenga soporte";
		#Exit
	fi
}
InstalarD libpq-dev
InstalarD python-dev
InstalarD python-setuptools
InstalarD python3-dev 
InstalarD python3-setuptools
InstalarD build-essential 
InstalarD python-imaging
InstalarD libjpeg-dev
InstalarD libjpeg8-dev
InstalarD libfreetype6
InstalarD libfreetype6-dev
InstalarD zlib1g-dev
InstalarD zlib1g-dev
InstalarD python-dateutil 
InstalarD python-docutils 
InstalarD python-feedparser 
InstalarD python-gdata 
InstalarD python-jinja2 
InstalarD python-ldap 
InstalarD python-libxslt1 
InstalarD python-lxml 
InstalarD python-mako 
InstalarD python-mock 
InstalarD python-openid 
InstalarD python-psycopg2 
InstalarD python-psutil 
InstalarD python-pybabel 
InstalarD python-pychart 
InstalarD python-pydot 
InstalarD python-pyparsing 
InstalarD python-reportlab 
InstalarD python-simplejson 
InstalarD python-tz 
InstalarD python-unittest2 
InstalarD python-vatnumber 
InstalarD python-vobject 
InstalarD python-webdav 
InstalarD python-werkzeug 
InstalarD python-xlwt 
InstalarD python-yaml 
InstalarD python-zsi
InstalarD libjpeg-dev 
InstalarD libfreetype6 
InstalarD libfreetype6-dev 
InstalarD zlib1g-dev
InstalarD libjpeg62 
InstalarD libjpeg62-dev
InstalarD libjpeg8-dev 
InstalarD libfreetype6 
InstalarD libfreetype6-dev 
InstalarD zlib1g-dev
InstalarD libjpeg62 
InstalarD libjpeg62-dev
InstalarD zlib1g-dev
InstalarD libfreetype6 
InstalarD libfreetype6-dev
InstalarD libmysqlclient-dev
InstalarD build-essential 
InstalarD autoconf 
InstalarD libtool 
InstalarD python-opengl 
InstalarD python-imaging 
InstalarD python-pyrex 
InstalarD python-pyside.qtopengl 
InstalarD idle-python2.7 
InstalarD qt4-dev-tools 
InstalarD qt4-designer 
InstalarD libqtgui4 
InstalarD libqtcore4 
InstalarD libqt4-xml 
InstalarD libqt4-test 
InstalarD libqt4-script 
InstalarD libqt4-network 
InstalarD libqt4-dbus 
InstalarD python-qt4 
InstalarD libgle3 
InstalarD libjpeg8 
InstalarD libjpeg62-dev 
InstalarD libfreetype6 
InstalarD libfreetype6-dev
InstalarD build-essential 
InstalarD autoconf 
InstalarD libtool 
#InstalarD pkg-config 
InstalarD python-opengl 
InstalarD python-imaging 
InstalarD python-pyrex 
InstalarD python-pyside.qtopengl 
InstalarD idle-python2.7 
InstalarD qt4-dev-tools 
InstalarD qt4-designer 
InstalarD libqtgui4 
InstalarD libqtcore4 
InstalarD libqt4-xml 
InstalarD libqt4-test 
InstalarD libqt4-script 
InstalarD libqt4-network 
InstalarD libqt4-dbus 
InstalarD python-qt4 
InstalarD python-qt4-gl 

#crear enlaces sinbolicos
function InstalaE()
{
	ssh root@$host -p$portssh ln -s /usr/lib/`uname -i`-linux-gnu/libfreetype.so /usr/lib/
	if (( "$?" == "0" ))
	then 
		echo "el enlase $1 se instalo correctamente";
	else
		echo "el enlase ya a sido creado";
		
	fi
	ssh root@$host -p$portssh ln -s /usr/lib/`uname -i`-linux-gnu/libjpeg.so /usr/lib/
	if (( "$?" == "0" ))
	then 
		echo "el enlase $1 se instalo correctamente";
	else
		echo "el enlase ya a sido creado";
		
	fi
	ssh root@$host -p$portssh ln -s /usr/lib/`uname -i`-linux-gnu/libz.so /usr/lib/
	if (( "$?" == "0" ))
	then 
		echo "el enlase $1 se instalo correctamente";
	else
		echo "el enlase ya a sido creado";
		
	fi
}
InstalaE 
#instalar servicios 
function InstalaS()
{
	ssh root@$host -p$portssh apt-get -y install $1
	if (( "$?" == "0" ))
	then 
		echo "";
	else
		echo "el servicio no dio respuesta puede ser que notengas conexion a internet o que el servicio ya no tenga soporte";
		#Exit
	fi
}	
InstalaS supervisor
InstalaS nginx
InstalaS postgresql 
InstalaS postgresql-contrib 
InstalaS git
InstalaS python-virtualenv 
InstalaS ufw 

#crear entorno virtual 
ssh root@$host -p$portssh virtualenv /home/$nombre_directorio_usuario/$nombre_entorno_virtual -p /usr/bin/python$vercion_python

#clonar la app en el servidor **********************

function MCappSR()
{
	echo " preparando el archivo CappS.sh para la configurarcion........";
	sed -e 's/nombre_directorio_usuario/'$1'/g' -e 's/nombre_entorno_virtual/'$2'/g' recurso_config/CappS.sh > config_r/CappS.sh
	echo "Archivo CappS.sh creado........";
}
MCappSR $nombre_directorio_usuario $nombre_entorno_virtual

scp -P$portssh config_r/CappS.sh root@$host:/home/$nombre_directorio_usuario
#
ssh root@$host -p$portssh chmod 755 /home/$nombre_directorio_usuario/CappS.sh
ssh root@$host -p$portssh . /home/$nombre_directorio_usuario/CappS.sh
ssh root@$host -p$portssh rm -r /home/$nombre_directorio_usuario/CappS.sh
#-----------------------------------------------x
#remplasar el archivo settings.py de la app en el servidor
#rm recurso_app/$nombre_dir_app/$nombre_app/settings.py
ssh root@$host -p$portssh rm -r /home/$nombre_directorio_usuario/$nombre_entorno_virtual/$nombre_dir_app/$nombre_app/settings.py
#cp config_app/settings.py recurso_app/$nombre_dir_app/$nombre_app/
scp -P$portssh config_app/settings.py root@$host:/home/$nombre_directorio_usuario/$nombre_entorno_virtual/$nombre_dir_app/$nombre_app
#scp -r -P$portssh recurso_app/* root@$host:/home/$nombre_directorio_usuario/$nombre_entorno_virtual
#----------------------------------------------x
#instalar requiremens.txt
function MInsR()
{
	echo " preparando el archivo InsR.sh para la configurarcion........";
	sed -e 's/nombre_directorio_usuario/'$1'/g' -e 's/nombre_entorno_virtual/'$2'/g' -e 's/nombre_dir_app/'$3'/g' -e 's/hostx/'$4'/g' -e 's/puertox1/'$5'/g' recurso_config/InsR.sh > config_r/InsR.sh
	echo "Archivo InsR.sh creado........";
}
MInsR $nombre_directorio_usuario $nombre_entorno_virtual $nombre_dir_app $host $gun1

scp -P$portssh config_r/InsR.sh root@$host:/home/$nombre_directorio_usuario
#
ssh root@$host -p$portssh chmod 755 /home/$nombre_directorio_usuario/InsR.sh
ssh root@$host -p$portssh . /home/$nombre_directorio_usuario/InsR.sh
ssh root@$host -p$portssh rm -r /home/$nombre_directorio_usuario/InsR.sh

function MDirG()
{
	echo " preparando el archivo InsR.sh para la configurarcion........";
	sed -e 's/nombre_directorio_usuario/'$1'/g' -e 's/nombre_entorno_virtual/'$2'/g' -e 's/nombre_dir_app/'$3'/g' -e 's/hostx/'$4'/g' -e 's/nombre_app/'$5'/g' -e 's/puertox2/'$6'/g' recurso_config/DirG.sh > config_r/DirG.sh
	echo "Archivo DirG.sh creado........";
}
MDirG $nombre_directorio_usuario $nombre_entorno_virtual $nombre_dir_app $host $nombre_app $gun2
scp -P$portssh config_r/DirG.sh root@$host:/home/$nombre_directorio_usuario
#dar permisos de ejecucion
ssh root@$host -p$portssh chmod 755 /home/$nombre_directorio_usuario/DirG.sh
ssh root@$host -p$portssh . /home/$nombre_directorio_usuario/DirG.sh
ssh root@$host -p$portssh rm -r /home/$nombre_directorio_usuario/DirG.sh

#crear directorios dentro del entorno virtual
ssh root@$host -p$portssh mkdir /home/$nombre_directorio_usuario/$nombre_entorno_virtual/logs
#ssh root@$host -p22 mkdir /home/$nombre_directorio_usuario/$nombre_entorno_virtual/run
ssh root@$host -p$portssh mkdir /home/$nombre_directorio_usuario/$nombre_entorno_virtual/media
ssh root@$host -p$portssh mkdir /home/$nombre_directorio_usuario/$nombre_entorno_virtual/static
#guardar el archivo Cgunicorn_start.sh en bin
scp -P$portssh config_r/Cgunicorn_start.sh root@$host:/home/$nombre_directorio_usuario/$nombre_entorno_virtual/bin
#dar permisos de ejecucion
ssh root@$host -p$portssh chmod 755 /home/$nombre_directorio_usuario/$nombre_entorno_virtual/bin/Cgunicorn_start.sh
echo "..."
ssh root@$host -p$portssh . /home/$nombre_directorio_usuario/$nombre_entorno_virtual/bin/Cgunicorn_start.sh

#configurar supervisor
# cd /etc/supervisor/conf.d/ 
ssh root@$host -p$portssh mkdir -p /etc/supervisor/conf.d/
	#ssh root@$host -p$portssh rm -r -f /etc/supervisor/conf.d/*
scp -P$portssh config_r/$nasuper root@$host:/etc/supervisor/conf.d/
ssh root@$host -p$portssh supervisorctl reread 
ssh root@$host -p$portssh supervisorctl update
ssh root@$host -p$portssh supervisorctl status $nombre_app
ssh root@$host -p$portssh supervisorctl stop $nombre_app
ssh root@$host -p$portssh supervisorctl start $nombre_app 
ssh root@$host -p$portssh supervisorctl restart $nombre_app
#configurar Nginx
ssh root@$host -p$portssh service nginx start
	#ssh root@$host -p22 mkdir -p /etc/nginx/sites-available
ssh root@$host -p$portssh mkdir -p /etc/nginx/sites-enabled
	#ssh root@$host -p$portssh rm -r -f /etc/nginx/sites-available/*
	#ssh root@$host -p$portssh rm -r -f /etc/nginx/sites-enabled/*
scp -P$portssh config_r/$nanginx root@$host:/etc/nginx/sites-available/
echo "----------->$nanginx ";
ssh root@$host -p$portssh ln -s /etc/nginx/sites-available/$nanginx /etc/nginx/sites-enabled/$nanginx
ssh root@$host -p$portssh service nginx restart
#ssh root@$host -p22 reboot
#importAR ARCHIVOS MEDIA Y STATIC
function MIporSM()
{
	echo " preparando el archivo IporSM.sh para la configurarcion........";
	sed -e 's/nombre_directorio_usuario/'$1'/g' -e 's/nombre_entorno_virtual/'$2'/g' -e 's/nombre_dir_app/'$3'/g' recurso_config/IporSM.sh > config_r/IporSM.sh
	echo "Archivo IporSM.sh creado........";
}
MIporSM $nombre_directorio_usuario $nombre_entorno_virtual $nombre_dir_app
scp -P$portssh config_r/IporSM.sh root@$host:/home/$nombre_directorio_usuario
ssh root@$host -p$portssh chmod 755 /home/$nombre_directorio_usuario/IporSM.sh
ssh root@$host -p$portssh . /home/$nombre_directorio_usuario/IporSM.sh
ssh root@$host -p$portssh rm -r /home/$nombre_directorio_usuario/IporSM.sh
#/////////////////////
#asignarle todos los archivos al usuario para que corra con su directorio
#usa el comando chmd -R user:gurmpo dir/*
echo ".................................";
ssh root@$host -p$portssh chown -R $nombre_usuario_directorio:$nombre_usuario_directorio /home/$nombre_directorio_usuario/*
echo "...................................";
echo ">>>>>>>>>>>>>>>>>>>>>> Deployd Start !! <<<<<<<<<<<<<<<<<<<<<";

