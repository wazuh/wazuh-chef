# Ruleset settings (Manager)
default['ossec']['conf']['ruleset']['decoder_dir'] = ['ruleset/decoders', 'etc/decoders']
default['ossec']['conf']['ruleset']['rule_dir'] = ['ruleset/rules', 'etc/rules']
default['ossec']['conf']['ruleset']['rule_exclude'] = '0215-policy_rules.xml'
default['ossec']['conf']['ruleset']['list'] = ['etc/lists/audit-keys', 'etc/lists/security-eventchannel', 'etc/lists/amazon/aws-eventnames']
