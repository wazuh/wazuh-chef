#
# Cookbook Name:: ossec
# Attributes:: default
#
# Copyright 2010-2015, Chef Software, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# general settings
if platform_family?('mac_os_x')
    default['ossec']['dir'] = '/Library/ossec'
    default['ossec']['address'] = '172.19.0.211'
    default['ossec']['ignore_failure'] = true
else
    default['ossec']['dir'] = '/var/ossec'
    default['ossec']['address'] = '172.19.0.211'
    default['ossec']['ignore_failure'] = true
end
