ARG ARCH
ARG VERSION

FROM public.ecr.aws/sam/build-ruby3.3:latest-$ARCH

WORKDIR /build

ARG MYSQL_VERSION
ENV MYSQL_VERSION=$MYSQL_VERSION

RUN dnf install -y chrpath mariadb105-devel && \
  gem install mysql2 -v $MYSQL_VERSION

RUN mkdir -p /build/share && \
  cp -r /var/lang/lib/ruby/gems/3.3.0/gems/mysql2-${MYSQL_VERSION}/* /build/share && \
  cp /usr/lib64/{libmysqlclient.so,libmariadb.so.3} /build/share/lib/mysql2/ && \
  rm -rf /build/share/ext /build/share/README.md /build/share/support && \
  chrpath -r '$ORIGIN' /build/share/lib/mysql2/mysql2.so
