# Change Log
All notable changes to this project will be documented in this file.

## Wazuh Chef v4.0.3_1.11.0

### Added
- Update to Wazuh version 4.0.3
- Add Opendistro with version 1.11.0
- Update Elastic Stack to version 7.9.3
- Install Wazuh Kibana plugin 4.0.3_7.9.3 version
- Add support for SUSE repository

## Wazuh Chef v4.0.1

### Added

- Update to Wazuh version 4.0.1
## Wazuh Chef v3.13.2_7.9.1

### Added

- Update to Wazuh version 3.13.2_7.9.1

## Wazuh Chef v3.13.1_7.8.0

### Added

- Update to Wazuh version 3.13.1_7.8.0

## Wazuh Chef v3.13.0_7.7.1

### Added

- Update to Wazuh version 3.13.0_7.7.1

## Wazuh Chef v3.12.3_7.6.2

### Added

- Update to Wazuh version 3.12.3_7.6.2

## Wazuh Chef v3.12.2_7.6.2

### Added

- Update to Wazuh version 3.12.2_7.6.2

## Wazuh Chef v3.12.0_7.6.1

### Added

- Update to Wazuh version 3.12.0_7.6.1

- Upgrade to NodeJS v10 ([@xr09](https://github.com/xr09)) [PR#92](https://github.com/wazuh/wazuh-chef/pull/92)

## Wazuh Chef v3.11.4_7.6.1

### Added

- Update to Wazuh version 3.11.4_7.6.1

## Wazuh Chef v3.11.3_7.5.2

### Added

- Update to Wazuh version 3.11.3_7.5.2


## Wazuh Chef v3.11.2_7.5.1

### Added

- Update to Wazuh version 3.11.2_7.5.1


## Wazuh Chef v3.11.1_7.5.1

### Added

- Update to Wazuh version 3.11.1_7.5.1

- Changes to make `ossec.conf` equivalent to the default version ([rshad](https://github.com/rshad)) [PR#74](https://github.com/wazuh/wazuh-chef/pull/74)

- Implement new API configuration ([@jm404](https://github.com/jm404)) [PR#78](https://github.com/wazuh/wazuh-chef/pull/78)

- Remove Old Wazuh APP ([@jm404](https://github.com/jm404)) [PR#80](https://github.com/wazuh/wazuh-chef/pull/80)

## Wazuh Chef v3.11.0_7.5.1

### Added

- Update to Wazuh version 3.11.0_7.5.1

- Add Nginx SSL authentication for Kibana ([rshad](https://github.com/rshad)) [PR#69](https://github.com/wazuh/wazuh-chef/pull/69)


## Wazuh Chef v3.10.2_7.3.2

### Added

- Update to Wazuh version 3.10.2_7.3.2


## Wazuh Chef v3.10.0_7.3.2

### Added

- Update to Wazuh version 3.10.0_7.3.2

## Wazuh Chef v3.9.5_7.2.1

### Added

- Update to Wazuh version 3.9.5_7.2.1

## Wazuh Chef v3.9.4_7.2.0

### Added

- Update to Wazuh version 3.9.4_7.2.0
- Added the option to choose between registering agent after installation or not ([rshad](https://github.com/rshad)) [PR#50](https://github.com/wazuh/wazuh-chef/pull/50)

- Added Filebeat's module installation to the installation tasks ([rshad](https://github.com/rshad)) [PR#55](https://github.com/wazuh/wazuh-chef/pull/55)

### Changed

- Upgraded wazuh_api to accept Vault, Data Bags or none of them to configure Wazuh API ([@jm404](https://github.com/jm404)) [PR#47](https://github.com/wazuh/wazuh-chef/pull/47)

### Fixed

- Fixed Rootkit paths in wazuh-agent's cookbook configuration ([rshad](https://github.com/rshad)) [PR#48](https://github.com/wazuh/wazuh-chef/pull/48)

- Add agent.conf configuration for Wazuh Manager ([@jm404](https://github.com/jm404)) [PR#46](https://github.com/wazuh/wazuh-chef/pull/46)


## Wazuh Chef v3.9.3_7.2.0

### Added

- Update to Wazuh version 3.9.3_7.2.0

## Wazuh Chef v3.9.2_7.1.1

### Added

- Filebeat recipe now supports versioning. ([@jm404](https://github.com/jm404)) [#26b41ce](https://github.com/wazuh/wazuh-chef/commit/26b41ce35edf3177425092e9ecb547401e1b2be2)



## Wazuh Chef v3.9.1_7.1.0

### Changed

- Added version option for Wazuh Manager ([@jm404](https://github.com/jm404)) [#561cf11](https://github.com/wazuh/wazuh-chef/commit/561cf11994b227758fbfd57151e77191da69afa3)
- Updated Filebeat Recipes and templates ([@jm404](https://github.com/jm404)) [#190a8f7](https://github.com/wazuh/wazuh-chef/commit/190a8f75f085389f7aa64fca7076e740a5288eb9)
- Elasticsearch recipes and templates upgraded to 7.1 ([@jm404](https://github.com/jm404)) [#5184a35](https://github.com/wazuh/wazuh-chef/commit/5184a351472391cb6ca4cb4879c83aa2d605803b), [#9d35c94](https://github.com/wazuh/wazuh-chef/commit/9d35c94b0cf2cf912b8cfc8a8f60af4e32977f30)
- Elasticsearch attributes have been enhanced  ([@jm404](https://github.com/jm404)) [#eb20501](https://github.com/wazuh/wazuh-chef/commit/eb20501f28c724f01ff0709138abeb9610e03fdb)
- Node have been upgraded to 8.x and API versioning have been added. ([@jm404](https://github.com/jm404)) [#83050d0](https://github.com/wazuh/wazuh-chef/commit/83050d07ee7259dbeddf7638e3ae512b97fd79ca)

### Fixed

- Kibana listen to Elasticsearch now uses a dynamic value.  ([@jm404](https://github.com/jm404)) [#5db4bda](https://github.com/wazuh/wazuh-chef/commit/5db4bdaf9acc47668911eeeabeb5de6b13974747)

### Removed

- Java and Logstash recipes are no longer required and have been removed. ([@jm404](https://github.com/jm404)) [#15cf987](https://github.com/wazuh/wazuh-chef/commit/5db4bdaf9acc47668911eeeabeb5de6b13974747)


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

### Fixed

- Resolved Elasticsearch and Kibana RAM problems during installation. ([@jm404](https://github.com/jm404)) ([#25](https://github.com/wazuh/wazuh-chef/pull/25))
- Configuration URLs for Logstash and elasticsearch ([@jm404](https://github.com/jm404)) ([#25](https://github.com/wazuh/wazuh-chef/pull/25))

### Removed

- Removed old secrets and unnecesary files ([@jm404](https://github.com/jm404)) ([#22](https://github.com/wazuh/wazuh-chef/pull/22))
