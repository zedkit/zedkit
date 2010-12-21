##
# Copyright (c) Zedkit.
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation
# files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy,
# modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the
# Software is furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all copies or substantial portions of the
# Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
# WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
# COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
# ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
##

require 'rubygems'
require 'json'
require 'nestful'

require 'zedkit/ext/hash.rb'

module Zedkit
  class << self
    def countries(user_key)
      rs = Zedkit::Client.get('entities/countries', user_key)
      if rs && block_given?
        rs.is_a?(Array) ? rs.each {|i| yield(i) } : yield(rs)
      end
      rs
    end
    def regions(user_key, zks = {})
      rs = Zedkit::Client.get('entities/regions', user_key, zks)
      if rs && block_given?
        rs.is_a?(Array) ? rs.each {|i| yield(i) } : yield(rs)
      end
      rs
    end

    def entities(user_key)
      rs = Zedkit::Client.get('entities/zedkit', user_key)
      if rs && block_given?
        rs.is_a?(Array) ? rs.each {|i| yield(i) } : yield(rs)
      end
      rs
    end

    #
    # == Configuration
    #
    # Call the configure method within an application configuration initializer to set your project key,
    # and other goodies:
    #   Zedkit.configure do |zb|
    #     zb.project_key = 'from.zedkit.com.members.area'
    #     zb.ssl = true
    #   end
    #

    attr_accessor :configuration
    def configure
      self.configuration ||= Configuration.new
      yield configuration
    end
  end
end

require 'zedkit/client/configuration.rb'
require 'zedkit/client/client.rb'
require 'zedkit/client/exceptions.rb'

require 'zedkit/cli/bottom.rb'
require 'zedkit/cli/exceptions.rb'
require 'zedkit/cli/projects.rb'
require 'zedkit/cli/runner.rb'
require 'zedkit/cli/text.rb'

require 'zedkit/instances/instance.rb'
require 'zedkit/instances/project.rb'

require 'zedkit/resources/projects.rb'
require 'zedkit/resources/users.rb'

require 'zedkit/rails/sessions' if defined?(Rails::Railtie)
