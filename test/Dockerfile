FROM chef/chefworkstation

RUN curl -fsSL https://get.docker.com -o get-docker.sh && \
    sh get-docker.sh

RUN cd $HOME && \
    git clone https://github.com/wazuh/wazuh-chef.git && \
    cd wazuh-chef && \
    git fetch --all

RUN gem install test-kitchen && \
    gem install kitchen-inspec && \
    gem install kitchen-docker -v 2.3 
    
COPY entrypoint.sh /entrypoint.sh
RUN chmod 755 /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]