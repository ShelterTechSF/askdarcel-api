FROM ad2games/docker-rails:2.5.0

# ad2games/docker-rails removes files required for dpkg to work. We must
# recreate those files first before we can install postgresql-client.
# See this StackExchange question on restoring dpkg files:
# http://askubuntu.com/questions/383339/how-to-recover-deleted-dpkg-directory
RUN mkdir -p /var/lib/dpkg/alternatives /var/lib/dpkg/info /var/lib/dpkg/parts /var/lib/dpkg/triggers /var/lib/dpkg/updates && \
  touch /var/lib/dpkg/status && \
  echo 'deb http://apt.postgresql.org/pub/repos/apt/ xenial-pgdg main' > /etc/apt/sources.list.d/pgdg.list && \
  curl --silent https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - && \
  apt-get update && \
  apt-get install -y postgresql-client-9.5 && \
  rm -rf /var/lib/apt/lists/*
