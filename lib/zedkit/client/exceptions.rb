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
  class ZedkitError < StandardError
  end

  module Client
    class ClientError < ZedkitError
      attr_reader :http_code, :api_code, :message, :errors

      def initialize(info = {})
        @http_code = info[:http_code]
        @api_code = info[:api_code]
        @message = info[:message]
        @errors = info[:errors]
      end

      def to_s
        rs  = "\nZedkit API Error Response.\n"
        rs << "  HTTP Code => #{http_code}. #{http_string(http_code)}\n"
        rs << "  API Status Code => #{api_code}.\n" unless api_code.nil?
        rs << "  API Response Message => #{message}.\n" unless message.nil?
        rs << "  API Error Attribute Details => #{@errors['attributes'].map {|k,v| "#{k} => #{v}" }}.\n" unless errors.nil?
        rs << "\n"
      end

      private
      def http_string(code)
        case code.to_i
        when 401
          "Unauthorized."
        when 404
          "Does Not Exist."
        when 200
          "OK."
        else
          "Undefined." end
      end
    end

    class UnauthorizedAccess < ClientError
    end
    class ResourceNotFound < ClientError
    end
    class DataValidationError < ClientError
    end
  end
end
