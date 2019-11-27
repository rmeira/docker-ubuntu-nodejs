FROM ubuntu:18.04

LABEL maintainer="Althaia S/A Ind. Farmaceutica <tecnologia@althaia.com.br>"

ENV DEBIAN_FRONTEND=noninteractive

# UPDATE AND INSTALL INITIAL PACKAGES
RUN apt-get update && apt-get install software-properties-common -y && apt-get update

# INSTALL PACKAGES
RUN apt-get install -y \
    curl \
    wget \
    vim \
    unzip \
    zip

# INSTALL NODEJS AND YARN
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - && \
    apt-get install -y nodejs
RUN curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
     echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
     apt-get update && apt-get install yarn

# CLEAN DIRECTORY AND AJUST PERMISSIONS
RUN mkdir /var/www && chmod -R 755 /var/www && chown -R www-data:www-data /var/www

# DEFINE WORKDIR
WORKDIR /var/www

# FINAL CLEAN UP
RUN apt-get upgrade -y && apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    rm /var/log/lastlog /var/log/faillog

# UPDATE USER ACCESS
RUN usermod -u 1000 www-data

# COPY SHELLSCRIPT
COPY scripts/init.sh /scripts/init.sh

# FINAL POINT
ENTRYPOINT ["/scripts/init.sh"]
