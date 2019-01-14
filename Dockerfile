FROM ad2games/docker-rails:2.8.0

# ad2games/docker-rails removes files required for dpkg to work. We must
# recreate those files first before we can in stall postgresql-client.
# See this StackExchange question on restoring dpkg files:
# http://askubuntu.com/questions/383339/how-to-recover-deleted-dpkg-directory
# forward request and error logs to docker log collector

RUN mkdir -p /var/lib/dpkg/alternatives /var/lib/dpkg/info /var/lib/dpkg/parts /var/lib/dpkg/triggers /var/lib/dpkg/updates && \
  touch /var/lib/dpkg/status && \
  curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
  mv /home/app/webapp/config/appserver.sh /etc/service/appserver/run && \
  chmod 777 /etc/service/appserver/run && \
  echo 'deb http://apt.postgresql.org/pub/repos/apt/ xenial-pgdg main' > /etc/apt/sources.list.d/pgdg.list && \
  curl --silent https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - && \
  apt-get update && \
  apt-get install -y libglib2.0-dev && \
  apt-get install -y postgresql-client-9.5 && \
  rm -rf /var/lib/apt/lists/* && \
  rake rswag:specs:swaggerize