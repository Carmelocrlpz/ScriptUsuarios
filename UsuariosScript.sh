#!/bin/bash

user=''
passwd=''
group=''
directory=''

echo "Add groups"
	for i in $(cat groups.txt);
		do
		group=$i
		groupadd $group
		echo "Grupo "$i" Agregado."
	done

echo ""

echo "Add users"
	for i in $(cat users.txt);
		do
			#awk »»»» Lee la entrada un renglón a la vez
		user=`echo $i | awk -F: '{print $1}'`
		passwd=`echo $i | awk -F: '{print $2}'`
		group=`echo $i | awk -F: '{print $3}'`
		directory=`echo $i | awk -F: '{print $4}'`

# aqui se agregan usuarios con su respectivo grupo.
useradd $user -g $group -d $directory -s /sbin/nologin

# establecer la contraseña al usuario recien creado.
echo -e "$passwd\n$passwd" | smbpasswd -a $user -s

# establecer el propietario y grupo al directorio personal del usuario.
chown $user:$group $directory

# asignar permiso total a su directorio solo al propietario.
chmod 700 $directory

# Genero el archivo con la configuración de los directorios 

echo -e "[$user]\n\tcomment = 
Carpeta personal de $user\n\tpath = 
$directory\n\twritable = yes\n\tvalid users = 
$user\n" &gt;&gt; smb.conf.txt

done

echo "Archivo smb.conf generado. 
Ahora solo falta agregar las lineas generadas del archivo 
smb.conf.txt en el archivo de configuración de samba (smb.conf)"