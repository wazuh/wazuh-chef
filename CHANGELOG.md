# Change Log
All notable changes to this project will be documented in this file.

## Wazuh Chef v3.9.1_6.8.0

### Changed

- Re-factored whole repository structure to match the Chef-Repo standards.([@jm404](https://github.com/jm404)) ([#22](https://github.com/wazuh/wazuh-chef/pull/22))
- Divided cookbooks for Agent and Manager ([@jm404](https://github.com/jm404)) ([#22](https://github.com/wazuh/wazuh-chef/pull/22))
- Adapted attributes and splitted attributes in different files for clarification ([@jm404](https://github.com/jm404)) ([#22](https://github.com/wazuh/wazuh-chef/pull/22))
- Improved README's  ([@jm404](https://github.com/jm404)) ([#22](https://github.com/wazuh/wazuh-chef/pull/22))

### Added

- Support for ```agent-authp``` parameters. ([@jm404](https://github.com/jm404)) ([#22](https://github.com/wazuh/wazuh-chef/pull/22))
- Flexibility to either declare secrets or not. ([@jm404](https://github.com/jm404)) ([#22](https://github.com/wazuh/wazuh-chef/pull/22))
- Curl verification to ensure that Elasticsearch is properly installed ([@jm404](https://github.com/jm404)) ([#22](https://github.com/wazuh/wazuh-chef/pull/22))
- Created roles folder that contains the JSON files for creating the client roles. ([@jm404](https://github.com/jm404)) ([#22](https://github.com/wazuh/wazuh-chef/pull/22))
- Added  support to RHEL / Centos / Amazon and derivates. ([@jm404](https://github.com/jm404)) [#1f73cd8](https://github.com/wazuh/wazuh-chef/commit/1f73cd82678c96010b99e786ea40e7f26880248b) 
- Elastic components now support versioning  ([@jm404](https://github.com/jm404)) [#1f73cd8](https://github.com/wazuh/wazuh-chef/commit/1f73cd82678c96010b99e786ea40e7f26880248b) 
- Wazuh Manager Versioning ([@jm404](https://github.com/jm404))  [#1f73cd8](https://github.com/wazuh/wazuh-chef/commit/1f73cd82678c96010b99e786ea40e7f26880248b) 
- Wazuh Agent Versioning ([@jm404](https://github.com/jm404)) [#a488a0d](https://github.com/wazuh/wazuh-chef/commit/a488a0da30c99651f482bf87fca87b76ebbe0868)

### Fixed 

- Resolved Elasticsearch and Kibana RAM problems during installation. ([@jm404](https://github.com/jm404)) ([#25](https://github.com/wazuh/wazuh-chef/pull/25))
- Configuration URLs for Logstash and elasticsearch ([@jm404](https://github.com/jm404)) ([#25](https://github.com/wazuh/wazuh-chef/pull/25))
- Fixed block that would only listen to `localhost` when searching ES.  ([@jm404](https://github.com/jm404)) [#835ae05](https://github.com/wazuh/wazuh-chef/blob/835ae0563588edc3a840b7f98fbb0c9b0d0d24fa/cookbooks/wazuh_elastic/recipes/kibana.rb#L45-l52)

### Removed

- Removed old secrets and unnecesary files ([@jm404](https://github.com/jm404)) ([#22](https://github.com/wazuh/wazuh-chef/pull/22))