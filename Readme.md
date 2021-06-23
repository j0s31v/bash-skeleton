# Perkins.

Sistema de comandos y aplicaciones utilizados en sysadmin y otros ambientes.

# Disclaimer.
Perkins esta pensado en ser un "framework" de bash en el que esten las librerias y elementos utilizados en los comandos bash que se deban desarrollar para el manejo de proactive.
Por lo mismo esta pensado para crear comandos y que estos tengan una base, estructura y forma de implementacion definida.

# Requisitos
Esta libreria esta para ser con bash, desde debian o ubuntu, en el que fue desarrollada y testeada en debian 8 y ubuntu 20.04.

# Instalación.
Para realizar la instalación de la aplicacion basta con ejecutar

~~~
$ ./install.sh
~~~

Este script instalara en el sistema, por defecto /opt/perkins.
En el proceso de instalación se haran revision e instalacion de los programas/modulos que seran requeridos, estos estan escritos en el archivo
requirements.list. 

Por otra parte para que los comandos queden disponibles para todos en el sistema se deberan instalar de forma manual en path, ej.

~~~
ln -sf /opt/perkins/bin/perkins /usr/lib/bin/perkins
~~~

La instalación de los demonios (daemon) se debe realizar en caso de que este proceso sea necesario en el sistema.

~~~
$ sudo cp init.d/webscenario /etc/init.d/webscenario
$ sudo chmod +x /etc/init.d/webscenario
$ sudo chown root:root /etc/init.d/webscenario
$ sudo update-rc.d webscenario defaults
$ sudo update-rc.d webscenario enable
~~~

Para actualizar el daemon generado ejecutar

~~~
$ sudo systemctl daemon-reload
~~~

Para terminar la instalación se debe realizar la configuración.

~~~
$ sudo cp /opt/perkins/application/config/parameters.yml.dist /opt/perkins/application/config/parameters.yml
~~~

Una vez copiado es archivo se deberan configurar los valores de todos los módulos que lo requieran.
