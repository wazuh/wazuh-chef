FROM ruby

LABEL "maintainer"="Wazuh"
LABEL "version"="0.0.1"
LABEL "repository"="https://github.com/wazuh/wazuh-chef"
LABEL "name"="Wazuh Chef Dockerfile"

RUN apt-get update && apt install docker.io git curl wget -y && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN gem install kitchen-docker && \
    gem install rbnacl && \
    gem install rbnacl-libsodium && \
    gem install bcrypt_pbkdf && \
    gem install berkshelf && \
    gem install httpclient

RUN cd $HOME && \
    git clone https://github.com/wazuh/wazuh-qa.git && \
    cd $HOME/wazuh-qa && \
    git fetch --all && \
    git checkout devel && \
    git pull origin devel

RUN cd $HOME/wazuh-qa/kitchen/wazuh-chef/ && \
    bundle install

RUN gem_name=`ls /usr/local/bundle/gems | grep 'kitchen-docker'` && \
    rm -rf /usr/local/bundle/gems/$gem_name/* && \
    cp -rf $HOME/wazuh-qa/kitchen/kitchen-docker/* /usr/local/bundle/gems/$gem_name/

# Standard SSH port
EXPOSE 22

COPY entrypoint.sh /entrypoint.sh
RUN chmod 755 /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

