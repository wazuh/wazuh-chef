FROM chef/chefworkstation

LABEL "maintainer"="Wazuh"
LABEL "version"="0.0.1"
LABEL "repository"="https://github.com/wazuh/wazuh-chef"
LABEL "name"="Wazuh Chef Dockerfile"

# Adding systemd compatibility.
VOLUME [ "/sys/fs/cgroup", "/run", "/run/lock" ]

COPY entrypoint.sh /entrypoint.sh
RUN chmod 755 /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

