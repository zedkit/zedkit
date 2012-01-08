#
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
#

module Zedkit
  class Configuration
    attr_accessor :project_key, :user_key, :locales_key, :ssl, :exceptions, :api_host, :api_port, :debug

    API_HOSTNAME = "api.zedapi.com"
    API_PORT = 80
    PROJECT_KEY_LENGTH = 18
    LOCALES_KEY_LENGTH = 18

    def initialize
      @project_key, @user_key, @locales_key = nil, nil, nil
      @debug = false
      @ssl = false
      @exceptions = false
      @api_host, @api_port = API_HOSTNAME, API_PORT
    end

    def has_project_key?
      (not project_key.nil?) && project_key.is_a?(String) && project_key.length == PROJECT_KEY_LENGTH
    end
    def has_user_key?
      (not user_key.nil?) && user_key.is_a?(String)
    end
    def has_locales_key?
      (not locales_key.nil?) && locales_key.is_a?(String) && locales_key.length == LOCALES_KEY_LENGTH
    end

    def debug?
      debug
    end
    def ssl?
      ssl
    end
    def exceptions?
      exceptions
    end
    
    def api_url
      ssl? ? "https://#{api_host}:#{api_port}" : "http://#{api_host}:#{api_port}"
    end
  end
end
