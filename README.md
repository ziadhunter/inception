*This project has been created as part of the 42 curriculum by zfarouk.*

# Description

**Inception** is a system administration and Docker project from the 42 curriculum.

The goal of the project is to build a small infrastructure using **Docker Compose**, where each main service runs inside its own container.

The project is composed of:

* **NGINX** — web server and HTTPS entry point.
* **WordPress + PHP-FPM** — runs the WordPress website.
* **MariaDB** — database used by WordPress.

The services communicate through a private Docker network and use Docker named volumes to store persistent data.

## Main Design Choices

* Each service has its own Docker image and container.
* Docker Compose is used to create and manage the infrastructure.
* NGINX is the only service exposed to the host through port `443`.
* WordPress communicates with MariaDB through the Docker network.
* PHP-FPM executes PHP scripts for WordPress.
* HTTPS is configured with TLS.
* Docker named volumes are used for persistent WordPress and MariaDB data.
* Environment variables are used for general configuration.

# Instructions

## Requirements

You need:

* Docker
* Docker Compose

## Configuration

Create a `.env` file at the root of the project containing the required environment variables.

Example:

```env
DOMAIN_NAME=yourdomain.42.fr

MYSQL_DATABASE=wordpress
MYSQL_USER=wpuser
MYSQL_PASSWORD=your_password
MYSQL_ROOT_PASSWORD=your_root_password

WORDPRESS_ADMIN_USER=admin
WORDPRESS_ADMIN_PASSWORD=your_admin_password
WORDPRESS_ADMIN_EMAIL=admin@example.com
```

Do not commit `.env` if it contains real passwords or other sensitive information.

## Build and Run

From the root of the repository:

```bash
make
```

To build the Docker images:

```bash
make build
```

To start the infrastructure:

```bash
make up
```

To stop the infrastructure:

```bash
make down
```

To perform a full cleanup:

```bash
make fclean
```

To rebuild the entire infrastructure:

```bash
make re
```

To check the status of the containers:

```bash
make ps
```

To view the container logs:

```bash
make logs
```

# Architecture

The infrastructure follows this basic structure:

```text
                    HTTPS :443
                        |
                        v
                  +-----------+
                  |   NGINX   |
                  +-----------+
                        |
                        | FastCGI
                        v
              +-------------------+
              | WordPress +       |
              | PHP-FPM           |
              +-------------------+
                        |
                        | MySQL/MariaDB
                        v
                  +-----------+
                  |  MariaDB  |
                  +-----------+

          All services communicate
           through a Docker network

        +-----------------------------+
        |       Docker Network        |
        +-----------------------------+

        Persistent data:
        - WordPress files -> Docker volume
        - MariaDB data    -> Docker volume
```

# Docker Concepts and Comparisons

## Virtual Machines vs Docker

A **Virtual Machine (VM)** runs a complete guest operating system on top of a hypervisor. Each VM has its own kernel and virtual hardware.

**Docker containers** share the host Linux kernel. They isolate processes using Linux features such as namespaces and cgroups.

| Virtual Machines             | Docker                  |
| ---------------------------- | ----------------------- |
| Includes a complete guest OS | Shares the host kernel  |
| Usually heavier              | Lightweight             |
| Requires more resources      | Uses fewer resources    |
| Strong hardware/OS isolation | Process-level isolation |
| Slower to start              | Fast to start           |

For this project, Docker is appropriate because the goal is to create isolated services without requiring a complete operating system for each service.

## Docker Network vs Host Network

With a **Docker network**, containers communicate using Docker's networking system. Each container has its own network namespace and can communicate with other containers through the Docker network.

For example:

```text
nginx ---> wordpress:9000
wordpress ---> mariadb:3306
```

Docker's internal DNS allows services to be reached by their service names.

With **host networking**, the container uses the host's network namespace directly.

For this project, a Docker network is used because it provides service isolation and allows containers to communicate without exposing internal services directly to the host.

## Docker Volumes vs Bind Mounts

A **Docker named volume** is managed by Docker and is designed for persistent container data.

Example:

```yaml
volumes:
  wordpress_data:
  mariadb_data:
```

A **bind mount** directly maps a specific host directory into a container.

Example:

```text
/home/user/data:/var/lib/mysql
```

| Docker Volumes                       | Bind Mounts                                        |
| ------------------------------------ | -------------------------------------------------- |
| Managed by Docker                    | Managed by the user                                |
| Docker chooses the storage location  | User specifies the host path                       |
| Good for persistent application data | Useful for sharing specific host files/directories |
| More portable                        | Tightly connected to host filesystem               |

The Inception subject requires **Docker named volumes** for the WordPress files and MariaDB database, so bind mounts are not used for these persistent storages.

# Resources

## Documentation

* [Docker documentation](https://docs.docker.com/)
* [Docker Compose documentation](https://docs.docker.com/compose/)
* [NGINX documentation](https://nginx.org/en/docs/)
* [WordPress documentation](https://developer.wordpress.org/)
* [PHP documentation](https://www.php.net/docs.php)
* [MariaDB documentation](https://mariadb.com/docs/)
* [Linux documentation](https://www.kernel.org/doc/)
* [Docker tutorial video](https://www.youtube.com/watch?v=PrusdhS2lmo&t=3014s)

Useful topics studied during the project include:

* Docker images and containers
* Dockerfiles
* Docker Compose
* Docker networks
* Docker volumes
* Environment variables and secrets
* NGINX
* HTTPS/TLS
* PHP-FPM
* MariaDB
* Linux processes and permissions

## AI Usage

AI tools were used as a learning and development aid during the project.

They were mainly used to:

* Explain Docker and Docker Compose concepts.
* Understand Docker networking, containers, images, volumes and namespaces.
* Explain NGINX and PHP-FPM configuration.
* Troubleshoot configuration and build errors.
* Understand MariaDB initialization and connectivity.


