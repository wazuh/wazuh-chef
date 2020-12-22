FROM chef/chefworkstation

LABEL "maintainer"="Wazuh"
LABEL "version"="0.0.1"
LABEL "repository"="https://github.com/wazuh/wazuh-chef"
LABEL "name"="Wazuh Chef Dockerfile"

COPY entrypoint.sh /entrypoint.sh
RUN chmod 755 /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

