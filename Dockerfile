FROM ubuntu:jammy

SHELL ["/bin/bash", "-xo", "pipefail", "-c"]

ARG DEBIAN_FRONTEND=noninteractive

ENV LANG C.UTF-8

# Set a default timezone for python3-tz
ENV TZ=Etc/UTC

# Expose the default ports for browser and web traffic.
EXPOSE 8069 8071 8072

# Create a persistent volume for storing the odoo source.
# Create a persistent volume for storing cached and/or user uploaded files.
VOLUME /srv/odoo/src /srv/odoo/filestore

# Copy any temp files needed into the image.
# You can add files you need to ./sources/
# The directory will be deleted from the image later, so move the files you need to persist somewhere else on the image.
COPY sources /run/sources

# Install packages needed by Odoo.
# This list comes from the file /debian/control in the Odoo 16.0 source & the odoo/docker GitHub repo.

# Latest version of Odoo Debian Dependencies
RUN apt-get update && \
# Install the new packages
xargs apt-get install -y --no-install-recommends < /run/sources/pkglist  && \
# Clean up after ourselves.
apt-get clean && \
rm -rf /var/lib/apt/lists/* && \
rm -rf /run/sources

# Install rtlcss
RUN npm install -g rtlcss

# Root is the only user so far.
# We need to add a system user for Odoo.
RUN adduser --system odoo && \
adduser --group odoo && \
adduser --group srv && \
usermod -aG odoo odoo && \
usermod -aG srv odoo

# Let's run Odoo from /srv/odoo/src
# We created a group called srv in the last RUN command.
RUN mkdir /srv/odoo && \
kdir /srv/odoo/src && \
mkdir /srv/odoo/filestore && \
chown odoo /srv/odoo && \
chown odoo /srv/odoo/filestore && \
chgrp -R srv /srv && \
chmod -R 750 /srv

# Moving forward our default user is going to be Odoo.
USER odoo

# Set the working directory to the future location of the Odoo source code.
WORKDIR /srv/odoo