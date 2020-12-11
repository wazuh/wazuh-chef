# frozen_string_literal: true

# Configure the Rakefile's tasks.

###
# Company and SSL Details
# Used with the ssl_cert task.
###

# The company name - used for SSL certificates, and in srvious other places
COMPANY_NAME = 'Wazuh'

# The Country Name to use for SSL Certificates
SSL_COUNTRY_NAME = 'US'

# The State Name to use for SSL Certificates
SSL_STATE_NAME = 'VA'

# The Locality Name for SSL - typically, the city
SSL_LOCALITY_NAME = 'Leesburg'

# What department?
SSL_ORGANIZATIONAL_UNIT_NAME = 'Operations'

# The SSL contact email address
SSL_EMAIL_ADDRESS = 'info@wazuh.com'

# License for new Cookbooks
# Can be :apachev2 or :none
NEW_COOKBOOK_LICENSE = :all_rights

## Useful Extras (which you probably don't need to change)
# The top of the repository checkout
TOPDIR = File.expand_path(File.join(File.dirname(__FILE__), '..'))

# Where to store certificates generated with ssl_cert
CADIR = File.expand_path(File.join(TOPDIR, 'certificates'))
