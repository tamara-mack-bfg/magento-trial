# Docker Environment for Developer Magento U Courses and Trainings

This guide will help you set up a local Magento environment for the developer courses and trainings, if you don't have one already

The goal is to have a local environment with:
- A web server (Apache) with php, starts from 7.2
- A MySQL-like (MariaDB) database server
- Magento Open Source Code
- Magento Open Source Sample Data

## Introduction

We are providing custom docker images so once loaded, you will be ready to start with the developer courses and trainings

At the end of this guide you will find the instructions for installing the environment with the custom docker images. You don't need to follow those instructions, they are provided for your reference

## Requirements

- MacOS, Linux or Windows with\without WSL (with subsystem for Linux)
- [Docker Desktop installed](https://www.docker.com/products/docker-desktop)
- [GIT](https://git-scm.com/downloads)
- (Optionally) [Mutagen utility installed](https://mutagen.io/documentation/introduction/installation). Mutagen is utility which is provides real-time file synchronization, at the moment available for MacOS and only for Windows 10 with WSL (with subsystem for Linux)   
- (Optionally) [Visual Studio Code](https://code.visualstudio.com/download) or [PhpStorm](https://www.jetbrains.com/phpstorm/download/) or others

## Step by step installation guide

- Once you have Docker Desktop running, copy docker environment to your working directory. For example this is could be ```YOUR\WORKING\DIRECORY\magento\magento2-dev-dk```

- Copy your public (username) and private (password) access keys generated on the Marketplace and put it to auth.json at the debian_config/composer/auth.json

Example:

auth.json:
```
 {
     "http-basic": {
         "repo.magento.com": {
             "username": "<public_key>",
             "password": "<private_key>"
         }
     }
 }
```

- Change your local hosts file to resolve the local magento2u.loc domain
Unix:
```
sudo nano /etc/hosts
127.0.0.1       magento2u.loc
```

Windows:
```
Windows host file location is C:\Windows\System32\drivers\etc\hosts
Open file as administrator (or use visual studio code editor), add the following line: 
127.0.0.1       magento2u.loc
then save the file
```

- Once you have Docker Desktop running, [Clone the following from GIT](https://github.com/mike61988/magento2-dk/) to the your working directory. For example this is could be ```YOUR\WORKING\DIRECORY\magento\magento2-dev-dk``` and create ```instances``` folder inside of magento2-dev-dk


- ####Step only for Windows without WSL - START
- Update docker-compose_windows.yml file for regular setup:
```
volumes:
- C:\PATH\TO\YOUR\magento\magento2-dev-dk\instances:/var/www/html/shared
```
- ####Step only for Windows without WSL - END


- Open a terminal in that folder and run the following command

For Unix/Windows with WSL
```
docker-compose up -d
```

- ####Step only for Windows without WSL - START
```
docker-compose -f docker-compose_windows.yml up -d
```
- ####Step only for Windows without WSL - END

- After docker images successfully built run this command to proceed inside the container 

Unix:
```
docker exec -ti <CONTAINER_ID> /bin/bash
```

Windows:
```
docker exec -it <CONTAINER_ID> //bin/sh
```

Example:

Unix:
```
docker exec -ti m23 /bin/bash
```

Windows:
```
winpty docker exec -it m23 //bin/sh
```

and inside the container run:
```
mv /var/www/html/magento2ce /var/www/html/shared/ && exit
```

- Now when Magento instance moved to the shared folder you're able to test it by opening a browser and entering `http://magento2u.loc:8080/`
You also, will be able to login to the admin `http://magento2u.loc:8080/admin` using the following credentials:

```
username: admin
pass: mageU123
```

### Final steps for Unix/Windows with WSL only
- You can use all mutagen CLI commands directly from [documentation](https://mutagen.io/documentation/introduction/getting-started) or you can use bash script below to read how to use instructions

Example for Unix:
```
sh mutagen_session.sh
```
Example for Windows with WSL:
```
bash mutagen_session.sh
```
or you can see the list of commands below:

- To create mutagen session you need to use 'create' command together with the path to your working directory on your local machine, example for Unix:
```
sh mutagen_session.sh create /Users/<YOUR_USER>/<PATH>/<TO>/<YOUR>/magento/magento2-dev-dk/instances/
```
After a Mutagen staged/synchronize all files, Magento instance will appear in `instances` folder of your working directory

Example for Windows with WSL:
```
bash mutagen_session.sh create C:\PATH\TO\YOUR\magento\magento2-dev-dk\instances\
```

- To pause mutagen session you need to use 'pause' command, example: for Unix:
```
sh mutagen_session.sh pause
```
Example for Windows with WSL:
```
bash mutagen_session.sh pause
```

- To resume mutagen session you need to use 'resume' command, example: for Unix:
```
sh mutagen_session.sh resume
```
Example for Windows with WSL:
```
bash mutagen_session.sh resume
```

- To terminate mutagen session you need to use 'terminate' command, example: for Unix:
```
sh mutagen_session.sh terminate
```
Example for Windows with WSL:
```
bash mutagen_session.sh terminate
```

- To list mutagen sessions you need to use 'list' command, example: for Unix:
```
sh mutagen_session.sh list
```
Example for Windows with WSL:
```
bash mutagen_session.sh list
```

## Other important information
- After docker images successfully built and up you can run the following command to go inside of the container 

Unix:
```
docker exec -ti <CONTAINER_ID> /bin/bash
```

Windows:
```
winpty docker exec -it <CONTAINER_ID> //bin/sh
```

Example:

Unix:
```
docker exec -ti m23 /bin/bash
```

Windows:
```
winpty docker exec -it m23 //bin/sh
```

- In case if you need restart the VM. Example: rebooting your computer will require restarting the VM
```
docker-compose stop
```

```
docker-compose start
```

- To run Magento CLI command in a running container
Unix
```
sh m23_config/bin/console execute ANY_MAGENTO_CLI_COMMAND
```

Windows
```
bash m23_config/bin/console execute ANY_MAGENTO_CLI_COMMAND
```

Example for Unix:
```
sh m23_config/bin/console execute cache:clean
```
Example for Windows:
```
bash m23_config/bin/console execute cache:clean
```

- That's it, you have your VM for learning purposes for Magento 2.2 and Magento 2.3

## How to uninstall the VM

- Open a terminal in your working directory and run the following command
```
docker-compose down
``` 

- Run the following command you should see something like table below
```
REPOSITORY            TAG                 IMAGE ID            CREATED             SIZE

mike/m23_config       latest              167961367de5        12 days ago         3.39GB

mike/magento_config   latest              d26f7cd51da1        12 days ago         1.74GB

mike/debian_config    latest              bd3e96686fa0        12 days ago         923MB

debian                latest              67e34c1c9477        3 weeks ago         114MB
``` 

- Now you need copy IMAGE ID and use following command:
```
docker rmi -f IMAGE ID
``` 
Example
```
docker rmi -f 167961367de5
```
for every single image from the table

