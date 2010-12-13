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
  class Projects
    class << self
      def verify(type, key = nil, &block)
        rshh = nil
        case type.to_sym
        when :project
          rshh = Zedkit::Client.get('projects/verify', nil)
        when :locales
          rshh = Zedkit::Client.get('projects/verify/locales', nil, { :locales_key => key })
        end
        yield(rshh) unless rshh.nil? || !block_given?
        rshh
      end

      def get(zks = {}, &block)
        zks[:uuid] = 'uuid' if zks[:uuid].nil?                                  ## This avoids /projects/[nil] which is a 
        Zedkit::Client.crud(:get, "projects/#{zks[:uuid]}", zks, [], &block)    ## valid resource to list a user's projects.
      end

      def create(zks = {}, &block)
      end

      def update(zks = {}, &block)
      end
      
      def delete(zks = {}, &block)
      end
    end

    class Users
      class << self
        def get(zks = {}, &block)
          Zedkit::Client.crud(:get, "projects/#{zks[:project][:uuid]}/users", zks, %w(project), &block)
        end

        def create(zks = {}, &block)
          Zedkit::Client.crud(:create, "projects/#{zks[:project][:uuid]}/users", zks, %w(project), &block)
        end

        def update(zks = {}, &block)
          Zedkit::Client.crud(:update,
                              "projects/#{zks[:project][:uuid]}/users/#{zks[:user][:uuid]}", zks, %w(project), &block)
        end

        def delete(zks = {}, &block)
          Zedkit::Client.crud(:delete, "projects/#{zks[:project][:uuid]}/users/#{zks[:user][:uuid]}", zks, [], &block)
        end
      end
    end

    class Emails
      class << self
        def get(zks = {}, &block)
          Zedkit::Client.crud(:get, 'emails', zks, [], &block)
        end
      end
    end
  end
end
