# Continuous Integration
Team members:
- Tovar Hernandez, Diana Carolina.
- Villafane Perez, Ivan Dario.
- Cardenas Contreras, Ivan.
- Avila Dueñas, Cristian Andres.
- Murillo Rodriguez, Eduar Fabian.

## First commands steps:
In order to start testing and building the commands to create the Docker image, we use the following commands:
- ```cmd
    docker run -d --name ContainerTest1 -p 9001:80 ubuntu
    docker ps
    docker run -d --name ContainerTest2 -p 9002:80 ubuntu
    docker ps
    docker network create myNetworkTest
    docker network ls
    docker network connect myNetworkTest ContainerTest1
    docker network connect myNetworkTest ContainerTest2
    docker network inspect myNetworkTest
  ```
- If we want to test the connection between `ContainerTest1` and `ContainerTest2`:
  - ```cmd
      docker exec -it ContainerTest1 sh
    ```
    - ```cmd
      apt-get update
      apt-get install -y apache2 php libapache2-mod-php inetutils-ping
      ping ContainerTest2
      exit
      ```
    - Once this done, you can browse the server for `ContainerTest1` listening `9001` port like this:
      - <a href="http://localhost:9001/" target="_blank">http://localhost:9001</a>
- If we want to test the connection between `ContainerTest2` and `ContainerTest1`:
  - ```cmd
      docker exec -it ContainerTest2 sh
    ```
    - ```cmd
      apt-get update
      apt-get install -y apache2 php libapache2-mod-php inetutils-ping
      ping ContainerTest1
      exit
      ```
    - Once this done, you can browse the server for `ContainerTest2` listening `9002` port like this:
      - <a href="http://localhost:9002/" target="_blank">http://localhost:9002</a>
- Finally we can stop the containers:
- ```cmd
    docker stop ContainerTest1
    docker stop ContainerTest2
  ```

## Dockerfile build:
So, based on the previous executed commands, we will build the Dockerfile as following:
  - ```docker
    # Base image
    FROM ubuntu

    # Set non-interactive mode
    ENV DEBIAN_FRONTEND=noninteractive

    # Expose port 80
    EXPOSE 80

    # Install Apache, PHP, and other required packages
    RUN apt-get update -y
    RUN apt-get install -y apache2 php libapache2-mod-php inetutils-ping

    # Start Apache and PHP
    CMD ["apache2ctl", "-D", "FOREGROUND"]

    ```
- So first, we can create/build a new image called `my-image` and create the newtwork `myNetwork`:
  - ```cmd
      docker build -t my-image .
      docker network create myNetwork
    ```
- Finally, open a Terminal instance (In Windows use `PowerShell` terminal) and serve the container for `Container1` and `Container2`:
  - ```cmd
      docker run -d --name Container1 -p 9001:80 -v ${PWD}/app1:/var/www/html --network myNetwork my-image
      docker run -d --name Container2 -p 9002:80 -v ${PWD}/app2:/var/www/html --network myNetwork my-image
    ```
  - ```cmd
      docker exec -it Container1 sh
    ```
    - ```cmd
        ping Container2
        exit
      ```
  - ```cmd
      docker exec -it Container2 sh
    ```
    - ```cmd
        ping Container1
        exit
      ```
- Also you'll see that the projects are available at the urls:
  - <a href="http://localhost:9001/" target="_blank">http://localhost:9001</a>
  - <a href="http://localhost:9002/" target="_blank">http://localhost:9002</a>
- We can stop the containers:
  ```cmd
    docker stop Container1
    docker stop Container2
  ```
