# Odoo On Ubuntu In A Container
This project configures a [Docker](https://docs.docker.com/) environment to host an *extremely* lightweight [Ubuntu](https://ubuntu.com/server/docs) instance ready for hosting [Odoo](https://www.odoo.com/documentation/). 

## Introduction
This image DOES NOT CONTAIN THE ODOO SOURCE. Please see the **Docker Volumes for Odoo** section.

We start from the latest Ubuntu LTS core and add a few administrative tools as well as packages required *for a L->R language only Odoo instance.*

The following is not installed on the image:
- apache/nginx
- nodejs - [Required for L<-R language support.](https://www.odoo.com/documentation/16.0/administration/install/source.html#:~:text=Download%20and%20install%20nodejs%20and%20npm%20with%20a%20package%20manager.)
- odoo
- postgresql

### Odoo on Docker
There are two fundamental considerations to containerizing Odoo.
- The source code is quite large.
- The Odoo data-dir needs to be persistent, yet accessible by many running containers.

One way to handle this is to just bind mount a directory holding the Odoo source on the Docker host to every container. That didn't seem very containerized.
If you plan to use an NFS mount or some other method of managing the Odoo filestore, then you should proceed as you intend and ignore this next section.

### Docker Volumes for Odoo
The Dockerfile creates two [Volumes](https://docs.docker.com/storage/volumes/) - one at */srv/odoo* and one at */srv/odoo-filestore*.

The -v options on the command ```sh docker run -v named_volume:/path/on/container ``` in the installation guide results in two named volumes being created, one named odoo and the other odoo-filestore. This provides an easy way for multiple Docker Containers running Odoo on the same Docker Engine to share the same filestore. It also dramatically reduces the size of the Docker image responsible for running the source.

The installation guide provides a crude way of loading the [Odoo source code](https://github.com/odoo/odoo) onto the 'odoo' named Docker volume. You'll need to have an accessible instance of Postgres to use as your database to run that source.

### Final Thoughts
You could ultimately benefit from using an [Odoo configuration file](https://www.odoo.com/documentation/16.0/developer/reference/cli.html#reference-cmdline-config-file) and setting *'odoo-bin'* to run as your [ENTRYPOINT](https://docs.docker.com/engine/reference/builder/#entrypoint) when the container starts. That suggestion is just one solution for turning a containerized version of the Odoo source into a service. This image is meant to be just a starting point for many options.

One example of how to securely store credentials and start Odoo can be found here.

## Getting Started
These instructions will get you a copy of the image up and running on your local machine for development and testing purposes.

### Prerequisites
Ensure you have the latest version of Docker installed on your machine. If not, follow the official guidelines for installation from [Docker's website](https://docs.docker.com/).

### Getting The Image
There are two ways to get the image. Building it yourself from the Dockerfile is recommended.

#### Build from the Dockerfile - Recommended
1. Clone this repository: ```sh git clone https://github.com/gadgetjoejoe/odoo-on-ubuntu.git ```
2. Navigate to the project directory: ```sh cd odoo-on-ubuntu ```
3. Build the Docker image: ```sh docker build --tag odoo-on-ubuntu . ```
4. Start the Docker container: ```sh docker run --name odoo-container -it odoo-on-ubuntu ```

#### Download from GitHub - Linux/AMD64 Only
You can also pull the image directly from the GitHub Package Registry.

After pulling the image, start the Docker container: ```sh docker run --name odoo-container -it odoo-on-ubuntu ```

### Installing Odoo
One simple way to install Odoo onto your volume is to use git. Confirm you're in /srv/odoo then run: ```sh git clone https://github.com/odoo/odoo.git . ```

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change. 

## License
This project is licensed under the MIT License - see the LICENSE.md file for details. 

## Contact
Joe Clark - joe.clark@advance.enterprises

Project Link: https://github.com/gadgetjoejoe/odoo-on-ubuntu  

Happy coding!