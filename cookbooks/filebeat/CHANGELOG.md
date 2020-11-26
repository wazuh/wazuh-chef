## v0.1.0
1. Bump to filebeat OSS 7.9.1
2. Remove repository.rb since it is useless. To install filebeat, you need first to install first
wazuh manager in the same node. Filebeat use the same URI and GPG KEY repository as the latter 
to install the package
3. Added suse repository

*Note*: in future version, filebeat will be included into wazuh-manager cookbook

* Initial/current release
