ARG php
FROM php:$php-cli
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    nodejs \
    unzip \
    wget
COPY install_composer.sh /
RUN /install_composer.sh
RUN git clone https://github.com/simplesamlphp/simplesamlphp.git /simplesamlphp
WORKDIR /simplesamlphp
ARG version
ENV VERSION=$version
RUN git checkout origin/simplesamlphp-${VERSION} 
ENTRYPOINT ["bin/build-release.sh"]
