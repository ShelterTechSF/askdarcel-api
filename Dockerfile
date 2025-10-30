FROM sheltertechsf/combostrikehq-docker-rails:ruby-2.7

# combostrikehq/docker-rails removes files required for dpkg to work. We must
# recreate those files first before we can install postgresql-client.
# See this StackExchange question on restoring dpkg files:
# http://askubuntu.com/questions/383339/how-to-recover-deleted-dpkg-directory
# forward request and error logs to docker log collector

# NB The xenial-pgdg package that we're installing with APT below may be removed from Postgres' repo
# when future Linux updates come out. See: https://wiki.postgresql.org/wiki/Apt for updates.

RUN mkdir -p /var/lib/dpkg/alternatives /var/lib/dpkg/info /var/lib/dpkg/parts /var/lib/dpkg/triggers /var/lib/dpkg/updates && \
  touch /var/lib/dpkg/status && \
  apt-get update && \
  apt-get install -y --no-install-recommends curl wget gnupg ca-certificates && \
  install -m 0755 -d /etc/apt/keyrings && \
  curl -fsSL https://dl.yarnpkg.com/debian/pubkey.gpg | gpg --dearmor -o /etc/apt/keyrings/yarn.gpg && \
  wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | gpg --dearmor -o /etc/apt/keyrings/google.gpg && \
  echo 'deb [signed-by=/etc/apt/keyrings/yarn.gpg] https://dl.yarnpkg.com/debian/ stable main' > /etc/apt/sources.list.d/yarn.list && \
  mkdir -p /etc/service/appserver && \
  mv /home/app/webapp/config/appserver.sh /etc/service/appserver/run && \
  chmod 777 /etc/service/appserver/run && \
  curl -fsSL https://www.postgresql.org/media/keys/ACCC4CF8.asc | gpg --dearmor -o /etc/apt/keyrings/postgres.gpg && \
  echo 'deb [signed-by=/etc/apt/keyrings/postgres.gpg] http://apt.postgresql.org/pub/repos/apt/ focal-pgdg main' > /etc/apt/sources.list.d/pgdg.list && \
  apt-get update && \
  apt-get install -y libglib2.0-dev postgresql-client-common && \
  rm -rf /var/lib/apt/lists/*

ENV LD_PRELOAD=$LD_PRELOAD:/lib/x86_64-linux-gnu/libjemalloc.so.2
