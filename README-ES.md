**Fecha de creación: 2019/02/20**
**Fecha de última actualización: mira la fecha del último commit**

# Intro
Este proyecto ha sido creado como método de aprendizaje sobre el uso Amazon Web Services (AWS). Los conocimientos previos sobre este sistema se podrían considerar inexistentes y está hecho de tal forma que puedas seguirlo paso a paso casi sin conocimientos previos.

El objetivo era crear una instancia EC2 (similar a usar un VPS) y con Docker Compose crear todos los contenedores necesarios para hacer funcionar un proyecto en Django.

# Sistema local empleado (no AWS)

Ubuntu 18.04 LTS.

# ¿Qués es AWS?

Son los servicios en la nube que ofrece Amazon para que puedas hacer toooodo lo que necesites. Servidor tipo VPS, servidor con aplicaciones preinstaladas, almacenamiento multimedia, base de datos, correo electrónico, control de versiones, múltiples opciones para desarrollo de apps y un largo etcétera.

# Creación de la cuenta para AWS

**URL:** https://aws.amazon.com

Creamos una cuenta de AWS, si es tu primera cuenta tendrás 1 año gratuito. Te va a solicitar email, contraseña y tarjeta de débito / crédito entre otros. Tranquil@ que no te van a cobrar nada, puedes dejar una instancia abierta 24h al mes que no te cobrarán extra, tienes 750h.

[Límite de la capa gratuita durante los 12 primeros meses](https://aws.amazon.com/es/free/?awsf.Free%20Tier%20Types=categories%2312monthsfree#Elastic_Compute_Cloud_(EC2)).

# El panel de AWS

"¿Qué locura es esta?" Si pensaste esto es normal que te puedas sentir abrumad@.

Vayamos al grano, lo que necesitas es seleccionar la opción de EC2 "Ejecute una máquina virtual".

![ec2 icon][ec2-icon]

# Creación de una instancia

Bien, ahora toca configurar nuestra instancia. Por simplicidad vamos a usar la configuración por defecto para un Ubuntu Server 18.04. Dentro de las opciones que te da marca "free tier only" y pulsa en "Review and Lauch". Ahora podrás revisar toda la configuración por defecto y cambiar lo que no te guste.

![ec2-create-instance][ec2-create-instance]

## IMPORTANTE
Cuando vayas a crear la instancia te pedirá que crees una "key pair", osea un **certificado** para que puedas acceder a esta por SSH. Ponle el nombre que quieras y guarda el fichero que te descargas en una ruta de fácil acceso ue recuerdes.


Puede tardar unos minutos en estar lista así que paciencia.

# Acceder a la instancia

Lo más importante, cuando pulses en la instancia nueva dentro del listado de estas es que te fijes en la `IPv4 Public IP` y `Public DNS (IPv4)`. Así es como vas a acceder a tu servidor por SSH.

Con Windows puedes emplear Putty, para Linux (Ubuntu que es nuestro caso):
```shell
ssh -i nombre-nuestra-key.pem ubuntu@ip_o_dns_de_nuestra_maquina
```

De [aquí puedes obtener el usuario]((https://docs.aws.amazon.com/es_es/AWSEC2/latest/UserGuide/AccessingInstancesLinux.html#ssh-prereqs)) de tu máquina por si decidiste instalar otra cosa que no fuera Ubuntu Server.

**Anotación:** en muchos tutoriales, incluido el oficial verás que te dice que la extensión de la clave es `.pem`. Si te descargas un fichero `.cer` lo puedes usar también.

# Copiar los ficheros de configuración necesarios

Empecemos a montar nuestro sistema pero antes te enseñaré un comando muy útil, scp, para copiar ficheros y carpetas hacia y desde tu servidor.

Aquí te dejo un [snippet (gist)](https://gist.github.com/mrroot5/658311314b17d7808a34cd055eecf8be) con un listado de comandos que puedes usar.

Como vamos a instalar en nuestra máquina lo que necesitamos copiaremos toda la carpeta de configuración.

```shell
scp -i nombre-nuestra-key.pem -r docker-config ubuntu@ip_o_dns_de_nuestra_maquina:/home/ubuntu/
```

# Instalar las dependencias en nuestra instancia

Aquí podemos ejecutar el fichero de `requirements-host.sh` o ejecutar línea a línea lo que encontraremos dentro del fichero e ir comprobando que pasa.

```shell
./requirements-host.sh
```
¡Listo!

# Clonar nuestro repositorio

Aquí podemos ejecutar el fichero de `requirements-code.sh` o ejecutar línea a línea lo que encontraremos dentro del fichero e ir comprobando que pasa.

```shell
./requirements-host.sh
```
¡Listo!


# Comandos empleados

```shell
docker-compose up --build > /dev/null/ 2>&1 &
```

```shell
docker ps -a
```

```shell
docker stop $(docker ps -a -q)
```

```shell
docker rm $(docker ps -a -q)
```

## Problemas encontrados
- Al iniciar runserver dentro del servidor con docker-compose up este se quedaba congelado debido a la ejecución del comando anteriormente mencionado. Para solventarlo se ejecutó en background y sin recibir mensajes el comando "up".

```shell
docker-compose up --build > /dev/null/ 2>&1 &
```

[ec2-icon]: images/ec2-icon.jpeg "ec2 icon"

[ec2-create-instance]: images/ec2-create-instance.jpeg "ec2 create instance"
