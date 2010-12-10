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

module Zedkit
  module Client
    class << self
      def verify(username, password)
        submit_request(:verify, 'users/verify', nil, {}, { :user => username, :password => password })
      end

      def get(rs, user_key, params = {})
        submit_request(:get, rs, user_key, params)
      end
      def create(rs, user_key, params)
        submit_request(:post, rs, user_key, params)
      end
      def update(rs, user_key, params)
        submit_request(:put, rs, user_key, params)
      end
      def delete(rs, user_key)
        submit_request(:delete, rs, user_key)
      end

      protected
      def submit_request(method, rs, user_key = nil, params = {}, options = {})
        rvss = nil
        begin
          http = http_request(method, rs, user_key, params.flatten_zedkit_params!, options)
          rvss = JSON.parse(http)
          if rvss.is_a?(Hash) && rvss.has_key?('status') && Zedkit.configuration.exceptions?
            raise DataValidationError.new(:http_code => 200, :api_code => rvss['status']['code'],
                                          :message => rvss['status']['message'], :errors => rvss['errors'])
          end
        rescue Net::HTTPBadResponse
          ## TBD
        rescue Nestful::ResourceNotFound
          if Zedkit.configuration.exceptions?
            raise Zedkit::Client::ResourceNotFound.new(:http_code => 404, :message => "Resource Requested does not Exist")
          end
        rescue Nestful::UnauthorizedAccess
          if Zedkit.configuration.exceptions?
            raise Zedkit::Client::UnauthorizedAccess.new(:http_code => 401,
                                                         :message => "Access to the Resource Requested was Denied")
          end
        end
        rvss
      end

      private
      def http_request(method, rs, uk, params, options)
        http = nil
        case method
        when :verify
          http = Nestful.get(resource_url(rs), options.merge({ :params => merged_params(params) }))
        when :get
          http = Nestful.get(resource_url(rs), options.merge({ :params => merged_params(params, uk) }))
        when :post
          http = Nestful.post(resource_url(rs), options.merge({ :format => :form, :params => merged_params(params, uk) }))
        when :put
          http = Nestful.put(resource_url(rs), options.merge({ :format => :form, :params => merged_params(params, uk) }))
        when :delete
          http = Nestful.delete(resource_url(rs), options.merge({ :params => merged_params(params, uk) }))
        end
        http
      end

      def resource_url(rs)
        "#{Zedkit.configuration.api_url}/#{rs}"
      end
      def merged_params(params = {}, user_key = nil)
        rh = {}
        rh.merge!({ :project_key => Zedkit.configuration.project_key }) if Zedkit.configuration.has_project_key?
        rh.merge!({ :locales_key => Zedkit.configuration.locales_key }) if Zedkit.configuration.has_locales_key?
        rh.merge!({ :user_key => user_key }) unless user_key.nil?
        rh.merge!(params) unless params.empty?
        rh
      end
    end
  end
end
