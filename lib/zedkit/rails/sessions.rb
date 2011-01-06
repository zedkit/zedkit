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
  module Sessions
    protected
    def session_fresh?(options = {})
      options[:idle_maximum_in_seconds] = 900 unless options.has_key? :idle_maximum_in_seconds
      set_last_seen if session[:last_seen].nil?
      return true   if session[:last_seen] > (Time.now.to_i - options[:idle_maximum_in_seconds])
      Rails.logger.info "Session has EXPIRED [#{options[:idle_maximum_in_seconds]}]"
      end_session
      false
    end
    def session_fresh_with_redirect?(options = {})
      options[:idle_maximum_in_seconds] = 900 unless options.has_key? :idle_maximum_in_seconds
      options[:url] = new_session_url unless options.has_key? :url
      return true if session_fresh?(options)
      redirect_to options[:url]
      end_session
      false
    end

    def has_session?
      return true if @user && @user.is_a?(Hash)
      if session[:user_json] && session[:user_json].is_a?(Hash)
        @user = session[:user_json]
        return true
      end
      false
    end
    def has_session_with_redirect?(url = root_url)
      return true if has_session?
      redirect_to url
      false
    end

    def has_had_a_session?
      set_user_login unless @user_login && @user_login.is_a?(String)
      return true if @user_login.present?
      false
    end
    def has_user_login?
      @user_login.present?
    end

    def start_session(login, password)
      case request.method.downcase.to_sym
      when :post

        Rails.logger.info "User Verification Request via Zedkit [#{login.downcase}]"
        Zedkit::Users.verify(:username => login.downcase, :password => password) do |json|
          Rails.logger.info "User VERIFIED [#{json['uuid']}]"
          set_session(json, login.downcase)
          return true
        end

      else set_user_login end
      false
    end
    def set_session(json, login)
      @user = json
      session[:user_json] = @user          ## This does not contain the user's password.
      cookies[:user_login] = { :value => login.downcase, :expires => 365.days.from_now }
    end
    def end_session
      session[:user_json] = nil
    end

    def set_user_login
      cookies[:user_login] ? @user_login = cookies[:user_login] : @user_login = nil
      Rails.logger.info "User Login SET [#{@user_login}]"
    end
    def set_last_seen
      session[:last_seen] = Time.new.to_i
    end
    def set_logout_method(method)
      session[:logout_method] = method
    end
  end
end
