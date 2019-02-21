**Creación: 2019/02/20**

**Última actualización: mira la fecha del último commit**

# INTRO
Este proyecto ha sido creado como método de aprendizaje sobre el uso Amazon Web Services (AWS). Los conocimientos previos sobre este sistema se podrían considerar inexistentes y está hecho de tal forma que puedas seguirlo paso a paso con pocos conocimientos previos.

El objetivo era crear una instancia EC2 (similar a usar un VPS) y con Docker Compose crear todos los contenedores necesarios para hacer funcionar un proyecto en Django.

# SISTEMA LOCAL EMPLEADO (NO AWS)

Ubuntu 18.04 LTS.

# ¿QUÉS ES AWS?

Son los servicios en la nube que ofrece Amazon para que puedas hacer toooodo lo que necesites. Servidor tipo VPS, servidor con aplicaciones preinstaladas, almacenamiento multimedia, base de datos, correo electrónico, control de versiones, múltiples opciones para desarrollo de apps y un largo etcétera.

# CREACIÓN DE LA CUENTA PARA AWS

**URL:** https://aws.amazon.com

Creamos una cuenta de AWS, si es tu primera cuenta tendrás 1 año gratuito. Te va a solicitar email, contraseña y tarjeta de débito / crédito entre otros. Tranquil@ que no te van a cobrar nada, puedes dejar una instancia abierta 24h al mes que no te cobrarán extra, tienes 750h.

[Límite de la capa gratuita durante los 12 primeros meses](https://aws.amazon.com/es/free/?awsf.Free%20Tier%20Types=categories%2312monthsfree#Elastic_Compute_Cloud_(EC2)).

# EL PANEL DE AWS

"¿Qué locura es esta?" Si pensaste esto es normal que te puedas sentir abrumad@.

Vayamos al grano, lo que necesitas es seleccionar la opción de EC2 "Ejecute una máquina virtual".

![ec2 icon][ec2-icon]

# CREACIÓN DE UNA INSTANCIA

Bien, ahora toca configurar nuestra instancia. Por simplicidad vamos a usar la configuración por defecto para un Ubuntu Server 18.04. Dentro de las opciones que te da marca "free tier only" y pulsa en "Review and Lauch". Ahora podrás revisar toda la configuración por defecto y cambiar lo que no te guste.

![ec2-create-instance][ec2-create-instance]

## **IMPORTANTE**
Cuando vayas a crear la instancia te pedirá que crees una "key pair", osea un **certificado** para que puedas acceder a esta por SSH. Ponle el nombre que quieras y guarda el fichero que te descargas en una ruta de fácil acceso ue recuerdes.


Puede tardar unos minutos en estar lista así que paciencia.

# ACCEDER A LA INSTANCIA

Lo más importante, cuando pulses en la instancia nueva dentro del listado de estas es que te fijes en la `IPv4 Public IP` y `Public DNS (IPv4)`. Así es como vas a acceder a tu servidor por SSH.

Con Windows puedes emplear Putty, para Linux (Ubuntu que es nuestro caso):
```shell
ssh -i nombre-nuestra-key.pem ubuntu@ip_o_dns_de_nuestra_maquina
```

De [aquí puedes obtener el usuario]((https://docs.aws.amazon.com/es_es/AWSEC2/latest/UserGuide/AccessingInstancesLinux.html#ssh-prereqs)) de tu máquina por si decidiste instalar otra cosa que no fuera Ubuntu Server.

**Anotación:** en muchos tutoriales, incluido el oficial verás que te dice que la extensión de la clave es `.pem`. Si te descargas un fichero `.cer` lo puedes usar también.

# COPIAR LOS FICHEROS DE CONFIGURACIÓN NECESARIOS

Empecemos a montar nuestro sistema pero antes te enseñaré un comando muy útil, scp, para copiar ficheros y carpetas hacia y desde tu servidor.

Aquí te dejo un [snippet (gist)](https://gist.github.com/mrroot5/658311314b17d7808a34cd055eecf8be) con un listado de comandos que puedes usar.

Como vamos a instalar en nuestra máquina lo que necesitamos copiaremos toda la carpeta de configuración.

```shell
scp -i nombre-nuestra-key.pem -r docker-config/ ubuntu@ip_o_dns_de_nuestra_maquina:/home/ubuntu/
```

# DEPENDENCIAS DE NUESTRA INSTANCIA

Antes de decirte qué fichero de la configuración puedes usar para instalar todas las dependencias de una vez, expliquemos un poco que es docker y docker-compose.

## ¿QUÉ ES DOCKER?
Resumidamente, encapsula nuestro sistema de tal forma que siempre que lo creemos sea igual. Para iformación más detallada te dejo estos enlaces:

- [Página oficial](https://www.docker.com/).

- [Página docker CE](https://docs.docker.com/install/) => versión gratuita de docker que usamos para el proyecto.

- [Instalación de docker para Ubuntu](https://docs.docker.com/install/linux/docker-ce/ubuntu/).

- [Guía de inicio con docker](https://docs.docker.com/get-started/).

## ¿QUÉ ES DOCKER-COMPOSE?
Es un orquestador para docker, dicho de otra forma, nos permite crear una configuración para crear simultáneamente múltiples contenedor de docker y así poder levantar un entorno completo en poco tiempo.

- [Página oficial](https://docs.docker.com/compose/).

- [Instalación](https://docs.docker.com/compose/install/).

## INSTALACIÓN

Entramos en la nueva carpeta que hemos copiada dentro de nuestra instancia:

```shell
cd docker-config
```

Comprueba que los ficheros tengan permisos de ejecución si no vas a copiar línea a línea su contenido y ejecutándolo en colsa:

```shell
ls -la requirements
```

Debe aparecer algo similar a `-rwxrwxr-x`, de lo contrario deberás darle permisos de ejecución con el siguiente comando:

```shell
chmod +x requirements/requirements-host.sh requirements/requirements-code.sh
```

Ahora podremos ejecutar el fichero de `requirements-host.sh` o ejecutar línea a línea lo que encontraremos dentro del fichero e ir comprobando que pasa.

```shell
./requirements/requirements-host.sh
```

# CLONAR NUESTRO REPOSITORIO

Aquí podemos ejecutar el fichero de `requirements-code.sh` o ejecutar línea a línea lo que encontraremos dentro del fichero e ir comprobando que pasa.

```shell
./requirements/requirements-code.sh
```

**Anotación:** puede que necesites usar el clone mediante https en lugar de ssh como está dentro del fichero de `requirements-code.sh`.

# CREAR LOS CONTENEDORES
A este punto deberíamos tener todo funcionando en el host. Pasemos a explicar los ficheros de Docker: `docker-compose.yml` y `Dockerfile-python`.

## FICHEROS DE CONFIGURACIÓN

### Dockerfile-python
Para este contenedor de python hemos usado la base de [python de docker hub](https://hub.docker.com/_/python/) y su [dockerfile](https://github.com/docker-library/python/blob/3189e185470f8abd8957c78973cda6b2413ca0fe/3.7/stretch/Dockerfile).

#### ¿Qué versión usar?
Pues en este caso nos centramos en **Python 3.7.2** con **Alpine 3.9** ya que Alpine nos proporciona un sistema suficiente como para llevar a cabo nuestro proyecto y con un consumo de disco duro muy reducido.

#### ¿Qué le hemos cambiado?
Como añadido tenemos agregado el `requirements-dev.txt` y después un pip install. También hemos dejado preparada una configuración de ejemplo del futuro trabajo de supervisor con el que arrancaremos el servidor, por ahora usaremos runserver en segundo plano (background).

### Dockerfile-postgres
En construcción

### docker-compose
Para el docker-compose hemos dejado preparada una configuración para la futura implementación del servicio de postgres.

Tenemos el servicio web que ejecutará nuestro contenedor con python y django. Expliquemos la configuración:

- **build:** aquí le especificamos la ruta donde se encuentra nuestro fichero de docker `context` y el nombre del fichero `Dockerfile-python`.

- **image:** usamos este parámetro para especificar el nombre final que tendrá nuestra imagen evitando que docker cree uno suyo propio poco intuitivo para nosotros.

- **command:** el comando que se ejecutará dentro de nuestro contenedor. Este comando en cuanto se ejecuta dejará bloqueado el contenedor al estar en proceso, por esto lo ejecutaremos después en background.

- **container_name:** usamos este parámetro por el mismo motivo que empleamos el de image.

- **volumes:** con esta cadena especificamos la ruta donde estará el código en nuestro host `/opt/english-dictionary` (Ubuntu) y dónde estará dentro del contenedor `/opt/english-dictionary` (Alpine).

- **ports:** aquí le especificamos el puerto del host `80` (Ubuntu) por el que le llegará la petición y al que debe redirigir en el contenedor `8000`(Alpine). Recordemos que estamos usando runserver en modo debug, el puerto por defecto lo hemos mantenido: 8000. En producción sería más recomendable usar `80:80`.

- **restart:** normalmente lo configuraremos con la opción de always pero en este caso como queremos que se pare si falla hemos quitado dicha opción.

## CONSTRUIR Y CREAR EL CONTENEDOR
Si todo ha ido bien ya deberías tener todo listo para crear la imagen de docker y el contenedor asociado a esta.

Para ello vamos a usar `docker-compose up` por simplicidad aunque deberíamos usar `docker stack deploy` ya que usamos un `docker stack init` al instalar docker. Esta operación **puede tardar varias minutos**. Si quieres ver el proceso completo entonces elimina del comando la parte de ` > /dev/null 2>&1 &`.

```shell
docker-compose up --build > /dev/null 2>&1 &
```

Explicación del comando:

- **docker-compose up:** comando que crea los contenedores necesarios para todos los servicios que encuentre dentro de `docker-composer.yml`. Se puede especificar otro fichero `yml` diferente.

- **--build:** parámetro para indicarle que cree o actualice las imágenes necesarias para levantar los contenedores.

- **>:** indicamos la redirección de la salida de `docker-compose up`.

- **/dev/null/:** explicado de una forma sencilla es como enviar la salida de `docker-compose up` a la eliminación, un contenedor donde va información innecesaria.

- **2>&1:** especifica que los errores (stderr) `2` serán redirigidos a las salida estándar (stdout) `1` y estos han sido enviados previamente a `/dev/null/`

- **&:** este sencillo parámemtro indica que todo el proceso debe hacerse en background.

# ACCEDER A LA WEB
Ahora queremos ver el resultado pero si intentamos acceder mediante la IP o DNS públicos de nuestra instancia nos daremos cuenta de que no podemos.

## ABRIR LOS PUERTO DE LA INSTANCIA

Lo primero es saber que grupo de seguridad tiene nuestra instancia. Si lo configuraste manualmente ya debería saber de todas formas en el listado de instancias de AWS podrás ver su "Security Group".

![security group][security-group]

Una vez lo tengas debemos editar los puertos para activar el acceso a los que queramos. A la izquierda en el panel de "network & security" pincha en "Security Groups".

![network panel][network-panel]

Selecciona el tuyo y en el panel que te aparecerá abajo del todo pincha en la pestaña de "Inbound"

![inbound][inbound]

Pulsamos en "Edit" y agregamos la regla HTTP. Guardamos y listo, ya podremos acceder por la IP o DNS a nuestra instancia.

# OTROS COMANDOS ÚTILES
- Consultar todos los contenedores, activos, con errores, etc.:
```shell
docker ps -a
```

- Parar todos los contenedores:
```shell
docker stop $(docker ps -a -q)
```

- Eliminar todos los contenedores:
```shell
docker rm $(docker ps -a -q)
```

[ec2-icon]: images/ec2-icon.jpeg "ec2 icon"

[ec2-create-instance]: images/ec2-create-instance.jpeg "ec2 create instance"

[security-group]: images/security-group.jpeg "security group"

[network-panel]: images/network-panel.jpeg "network panel"

[inbound]: images/inbound.jpeg "inbound"
