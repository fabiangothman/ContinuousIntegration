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
    docker run -d --name Container1 -p 8001:80 ubuntu
    docker ps
    docker run -d --name Container2 -p 8002:80 ubuntu
    docker ps
    docker network create myNetwork
    docker network ls
    docker network connect myNetwork Container1
    docker network connect myNetwork Container2
    docker network inspect myNetwork
  ```
- If we want to test the connection between `Container1` and `Container2`:
  - ```cmd
      docker exec -it Container1 sh
    ```
    - ```cmd
      apt-get update
      apt-get install -y apache2 php libapache2-mod-php inetutils-ping
      ping Container2
      exit
      ```
    - Once this done, you can browse the server for `Container1` listening `8001` port like this:
      - http://localhost:8001/
- If we want to test the connection between `Container2` and `Container1`:
  - ```cmd
      docker exec -it Container2 sh
    ```
    - ```cmd
      apt-get update
      apt-get install -y apache2 php libapache2-mod-php inetutils-ping
      ping Container1
      exit
      ```
    - Once this done, you can browse the server for `Container2` listening `8002` port like this:
      - http://localhost:8002/
- Finally we can stop the containers:
- ```cmd
    docker stop Container1
    docker stop Container2
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
- Then we can create/build a new image called `my-image`:
  - ```cmd
      docker build -t my-image .
    ```
- Finally, we serve the container for `Container1` and `Container2`:
  - ```cmd
      docker run -d --name Container1 -p 8001:80 -v ${PWD}/app1:/var/www/html --network myNetwork my-image
      docker run -d --name Container2 -p 8002:80 -v ${PWD}/app2:/var/www/html --network myNetwork my-image
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
- We can stop the containers:
  ```cmd
    docker stop Container1
    docker stop Container2
  ```
