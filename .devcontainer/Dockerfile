
#-------------------------------------------------------------------------------------------------------------
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See https://go.microsoft.com/fwlink/?linkid=2090316 for license information.
#-------------------------------------------------------------------------------------------------------------

# Debian and Ubuntu based images are supported. Alpine images are not yet supported.
FROM debian:9

# Configure apt
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
    && apt-get -y install --no-install-recommends apt-utils 2>&1

# Install git, process tools, lsb-release (common in install instructions for CLIs)
RUN apt-get -y install git procps lsb-release

# *****************************************************
# * Add steps for installing needed dependencies here *
# ****************************************************
RUN apt-get -y install \
    unzip \
    curl \
    wget

# Install Azure cli
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash

# Install terraform 0.12
RUN wget https://releases.hashicorp.com/terraform/0.12.3/terraform_0.12.3_linux_amd64.zip
RUN unzip terraform_0.12.3_linux_amd64.zip
RUN mv terraform /usr/local/bin
RUN rm terraform_0.12.3_linux_amd64.zip

# Clean up
RUN apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*
ENV DEBIAN_FRONTEND=dialog

# Set the default shell to bash rather than sh
ENV SHELL /bin/bash