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
        rs = nil
        case type.to_sym
        when :project
          rs = Zedkit::Client.get('projects/verify', nil)
        when :locales
          rs = Zedkit::Client.get('projects/verify/locales', nil, { :locales_key => key })
        end
        yield(rs) if rs && block_given?
        rs
      end
      def snapshot(zks = {}, &block)
        Zedkit::Client.get("projects/#{zks[:uuid]}/snapshot", nil, {}, &block)
      end

      def get(zks = {}, &block)                                           ## This avoids /projects/[nil] which is a
        zks[:uuid] = 'uuid' if zks[:uuid].nil?                            ## valid resource to list a user's projects.
        Zedkit::Client.crud(:get, "projects/#{zks[:uuid]}", zks, [], &block)
      end

      def create(zks = {}, &block)
        Zedkit::Client.crud(:create, 'projects', zks, [], &block)
      end

      def update(zks = {}, &block)
        Zedkit::Client.crud(:update, "projects/#{zks[:uuid]}", zks, [], &block)
      end
      
      def delete(zks = {}, &block)
        Zedkit::Client.crud(:delete, "projects/#{zks[:uuid]}", zks, [], &block)
      end
    end

    class ProjectKeys
      class << self
        def get(zks = {}, &block)
          Zedkit::Client.crud(:get, "projects/#{zks[:project][:uuid]}/keys", zks, %w(project), &block)
        end
      end
    end
    class ProjectUsers
      class << self
        def get(zks = {}, &block)
          Zedkit::Client.crud(:get, "projects/#{zks[:project][:uuid]}/users", zks, %w(project), &block)
        end
      end
    end

    class Blogs
      class << self
        def get(zks = {}, &block)
          Zedkit::Client.crud(:get, 'blogs', zks, [], &block)
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
    class EmailSettings
      class << self
        def get(zks = {}, &block)
          Zedkit::Client.crud(:get, 'emails/settings', zks, [], &block)
        end
      end
    end
  end
end
