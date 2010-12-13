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
      def crud(method, resource, zks, da, &block)
        rs = nil
        case method
        when :get
          rs = submit_request(:get, resource, zks[:user_key], zks.zdelete_keys!(%w(user_key uuid) + da))
        when :create
          rs = submit_request(:post, resource, zks[:user_key], zks.zdelete_keys!(%w(user_key) + da))
        when :update
          rs = submit_request(:put, resource, zks[:user_key], zks.zdelete_keys!(%w(user_key uuid) + da))
        when :delete
          rs = submit_request(:delete, resource, zks[:user_key])
        end
        if rs && block_given?
          rs.is_a?(Array) ? rs.each {|i| yield(i) } : yield(rs)
        end
        rs
      end

      def verify(username, password)
        submit_request(:verify, 'users/verify', nil, {}, { :user => username, :password => password })
      end
      def get(resource, user_key, params = {})
        submit_request(:get, resource, user_key, params)
      end

      protected
      def submit_request(method, resource, user_key = nil, params = {}, options = {})
        rvss = nil
        begin
          http = http_request(method, resource, user_key, params.flatten_zedkit_params!, options)
          rvss = JSON.parse(http)
          if rvss.is_a?(Hash) && rvss.has_key?('status') && Zedkit.configuration.exceptions?
            raise DataValidationError.new(:http_code => 200, :api_code => rvss['status']['code'],
                                          :message => rvss['status']['message'] << " [#{method.upcase} #{resource_url(rs)}]",
                                          :errors => rvss['errors'])
          end
        rescue Net::HTTPBadResponse
          ## TBD
        rescue Nestful::UnauthorizedAccess
          if Zedkit.configuration.exceptions?
            raise Zedkit::Client::UnauthorizedAccess.new(:http_code => 401,
                                           :message => "User Credentials are Invalid [#{method.upcase} #{resource_url(rs)}]")
          end
        rescue Nestful::ResourceNotFound
          if Zedkit.configuration.exceptions?
            raise Zedkit::Client::ResourceNotFound.new(:http_code => 404,
                                      :message => "Resource Requested does not Exist [#{method.upcase} #{resource_url(rs)}]")
          end
        rescue Nestful::ForbiddenAccess
          if Zedkit.configuration.exceptions?
            raise Zedkit::Client::ForbiddenAccess.new(:http_code => 403,
                                :message => "Access Denied to the Resource Requested [#{method.upcase} #{resource_url(rs)}]")
          end
        end
        rvss
      end

      private
      def http_request(method, resource, uk, params, options)
        full = "#{Zedkit.configuration.api_url}/#{resource}"
        http = nil
        case method
        when :verify
          http = Nestful.get(full, options.merge({ :params => merged_params(params) }))
        when :get
          http = Nestful.get(full, options.merge({ :params => merged_params(params, uk) }))
        when :post
          http = Nestful.post(full, options.merge({ :format => :form, :params => merged_params(params, uk) }))
        when :put
          http = Nestful.put(full, options.merge({ :format => :form, :params => merged_params(params, uk) }))
        when :delete
          http = Nestful.delete(full, options.merge({ :params => merged_params(params, uk) }))
        end
        http
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
