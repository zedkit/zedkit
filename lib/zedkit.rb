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

Dir["#{File.dirname(__FILE__)}/zedkit/ext/*.rb"].each {|ci| require ci }

module Zedkit
  class << self
    def countries(user_key)
      rs = Zedkit::Client.get('entities/countries', user_key)
      yield(rs) if rs && block_given?
      rs
    end
    def regions(user_key, zks = {})
      rs = Zedkit::Client.get('entities/regions', user_key, zks)
      yield(rs) if rs && block_given?
      rs
    end

    def entities(user_key)
      rs = Zedkit::Client.get('entities/zedkit', user_key)
      yield(rs) if rs && block_given?
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
      yield(configuration)
    end
  end
end

Dir["#{File.dirname(__FILE__)}/zedkit/client/*.rb"].each {|ci| require ci }
Dir["#{File.dirname(__FILE__)}/zedkit/cli/*.rb"].each {|ci| require ci }
Dir["#{File.dirname(__FILE__)}/zedkit/resources/*.rb"].each {|ci| require ci }
