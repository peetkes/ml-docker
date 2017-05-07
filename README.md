# ml-docker

This project describes how to build a MarkLogic Docker container and is based on the work of Alan Johnson (https://github.com/alan-johnson/docker-marklogic) and Patrick McElwee (https://hub.docker.com/r/patrickmcelwee/marklogic-dependencies/).

Running MarkLogic inside a Docker container has the advantage that you can switch between versions very easily because they run in an isolated environment. The only thing to keep in mind is that all containers share the hosts cpus, memory and storage.

And because it is not allowed to distribute the MarkLogic installers you need to download your own copy of the appropriate version of MarkLogic.

You can get your own version of the installer here: https://developer.marklogic.com/products
And store it in the right folder
- MarkLogic 8 installer in folder ML8 and  
- MarkLogic 9 installer in folder ML9

Make sure you get the installer for CentOS 7

### Building the Docker image for MarkLogic 8

>docker build -f ML8-Dockerfile -t marklogic-img:8.0-6.4-preinstalled.

This will create an image with the name "marklogic-img" and the tag "8.0-6.4-preinstalled"

### Creating the container

>docker run -d --name=ml8-initial-build -p 8001:8001 marklogic-img:8.0-6.4-preinstalled

Because of the last line in the Dockerfile the MarkLogic post-initialization is already executed via the initialize-ml.sh script.

>docker commit ml8-initial-build marklogic-img:8.0-6.4-preinstalled

With this commit the complete initialized MarkLogic image is saved locally. This image can be used for creation of ML8 containers ready for use.

You should now stop and remove the first image with the following two commands:
>docker stop ml8-initial-build
docker rm ml8-initial-build

### Creating the final container ready for use

You can now start the real container ready for use. Here you have the option to set attached volumes, set which ports should be exposed to the host and some other settings.

>docker run  -d --name=ml8.build -p 8000-8002:8000-8002 marklogic-img:8.0-6.4-preinstalled

If you want to persist the database in case of accidental destruction of the container you can install the database on an attached volume with the option -v

>docker run  -d --name=ml8.build -p 8000-8002:8000-8002 -v volume:/var/opt/MarkLogic marklogic-img:8.0-6.4-preinstalled

If you want to expose more ports for your application you can add extra -p options

>docker run  -d --name=ml8.build -p 8000-8002:8000-8002 -p 8040-8042:8040:8042 marklogic-img:8.0-6.4-preinstalled

You have to be aware of the fact that the ports you use for your container need to be available.

### Starting, stopping and removing of the container

You can start the container with the following command:
>docker start ml8.build

You can stop the container with the following command:
>docker stop ml8.build

You can remove the container with the following command:
>docker rm ml8.build

### Building the Docker image for MarkLogic 9

This Dockerfile is based on an image that Patrick McElwee created that has all the MarkLogic 9 prerequisites pre-installed. You can find that one here: https://hub.docker.com/r/patrickmcelwee/marklogic-dependencies/

>docker build -f ML9-Dockerfile -t marklogic-img:9.0-1-preinstalled.

This will create an image with the name "marklogic-img" and the tag "8.0-6.4-preinstalled"


The steps for creating a ready for use ML9 container are exactly the same as above.

### Start a node
The script start-node.sh can be used to start a node. It will take 3 parameters, name image and tag
It will hard-code the following settings:

-p 8000-8002:8000-8002
-p 8040-8050:8040-8050
--cpus=4
--memory=4g
-v ~/Development/docker-volumes/$NAME:/var/opt/MarkLogic

> ./start-node.sh -n name -i image -t tag

### Stop a node
The script stop-node.sh can be used to stop a running node. It will take 1 parameter, the name.

>./stop-node.sh -n name
