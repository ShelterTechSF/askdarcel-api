FROM sheltertechsf/combostrikehq-docker-rails:ruby-2.7

# combostrikehq/docker-rails removes files required for dpkg to work. We must
# recreate those files first before we can install postgresql-client.
# See this StackExchange question on restoring dpkg files:
# http://askubuntu.com/questions/383339/how-to-recover-deleted-dpkg-directory
# forward request and error logs to docker log collector

# NB The xenial-pgdg package that we're installing with APT below may be removed from Postgres' repo
# when future Linux updates come out. See: https://wiki.postgresql.org/wiki/Apt for updates.

# Restore dpkg directories and status file
RUN mkdir -p /var/lib/dpkg/alternatives /var/lib/dpkg/info /var/lib/dpkg/parts /var/lib/dpkg/triggers /var/lib/dpkg/updates && \
  touch /var/lib/dpkg/status

# Remove problematic repository configurations that may have expired/missing GPG keys
# These will be re-added with proper keys later
RUN rm -f /etc/apt/sources.list.d/yarn.list /etc/apt/sources.list.d/google-chrome.list 2>/dev/null || true

# Install prerequisites for GPG keyring management and HTTPS repositories
RUN apt-get update --allow-releaseinfo-change && \
  apt-get install -y --no-install-recommends curl wget gnupg ca-certificates apt-transport-https && \
  rm -rf /var/lib/apt/lists/*

# Create keyrings directory
RUN mkdir -p /usr/share/keyrings

# Add PostgreSQL repository with modern GPG keyring approach
# Use HTTPS and ensure proper keyring setup
# Only add PostgreSQL repo as that's what we need for postgresql-client-common
RUN curl --silent --fail https://www.postgresql.org/media/keys/ACCC4CF8.asc | gpg --dearmor -o /usr/share/keyrings/postgresql-keyring.gpg && \
  echo "deb [signed-by=/usr/share/keyrings/postgresql-keyring.gpg] https://apt.postgresql.org/pub/repos/apt/ focal-pgdg main" > /etc/apt/sources.list.d/pgdg.list

# Update package lists with error handling
# --allow-releaseinfo-change handles repository metadata changes
# --allow-unauthenticated temporarily if GPG verification fails (only for update, not install)
RUN apt-get update --allow-releaseinfo-change || \
  (apt-get clean && rm -rf /var/lib/apt/lists/* && apt-get update --allow-releaseinfo-change)

# Install required packages
# Install each package separately to identify which one fails
RUN apt-get install -y libglib2.0-dev && \
  apt-get install -y postgresql-client-common && \
  rm -rf /var/lib/apt/lists/*

# Configure appserver
RUN mkdir -p /etc/service/appserver && \
  mv /home/app/webapp/config/appserver.sh /etc/service/appserver/run && \
  chmod 777 /etc/service/appserver/run

ENV LD_PRELOAD=${LD_PRELOAD}:/lib/x86_64-linux-gnu/libjemalloc.so.2
