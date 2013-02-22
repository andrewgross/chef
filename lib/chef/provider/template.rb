#--
# Author:: Adam Jacob (<adam@opscode.com>)
# Author:: Daniel DeLeo (<dan@opscode.com>)
# Copyright:: Copyright (c) 2008, 2010 Opscode, Inc.
# License:: Apache License, Version 2.0
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

require 'chef/provider/template_finder'
require 'chef/provider/file'

class Chef
  class Provider
    class Template < Chef::Provider::File

      def initialize(new_resource, run_context)
        @content_strategy = Chef::Provider::FileStrategy::ContentFromTemplate
        super
      end

      def load_current_resource
        @current_resource = Chef::Resource::Template.new(@new_resource.name)
        super
      end

      def define_resource_requirements
        super

        requirements.assert(:create, :create_if_missing) do |a|
          a.assertion { ::File::exist?(content_object.template_location) }
          a.failure_message "Template source #{content_object.template_location} could not be found."
          a.whyrun "Template source #{content_object.template_location} does not exist. Assuming it would have been created."
          a.block_action!
        end
      end

    end
  end
end

