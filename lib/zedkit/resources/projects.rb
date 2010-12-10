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
      def verify(type, key = nil)
        rshh = nil
        case type.to_sym
        when :project
          rshh = Zedkit::Client.get('projects/verify', nil)
          yield(rshh) if (not rshh.nil?) && block_given?
        when :locales
          rshh = Zedkit::Client.get('projects/verify/locales', nil, { :locales_key => key })
          yield(rshh) if (not rshh.nil?) && block_given?
        end
        rshh
      end

      def get(*args)
        zopts = args.extract_zedkit_options!
        zopts[:uuid] = 'uuid' if zopts[:uuid].nil?
        reshh = Zedkit::Client.get("projects/#{zopts[:uuid]}", zopts[:user_key], zopts.zdelete_keys!(%w(uuid user_key)))
        yield(reshh) if (not reshh.nil?) && block_given?
        reshh
      end

      def create(*args)
      end

      def update(*args)
      end
      
      def delete(*args)
      end
    end

    class Users
      class << self
        def get(*args)
          zopts = args.extract_zedkit_options!
          reshh = Zedkit::Client.get("projects/#{zopts[:project][:uuid]}/users", zopts[:user_key],
                                                                zopts.zdelete_keys!(%w(user_key)))
          yield(reshh) if (not reshh.nil?) && block_given?
          reshh
        end

        def create(*args)
          zopts = args.extract_zedkit_options!
          reshh = Zedkit::Client.create("projects/#{zopts[:project][:uuid]}/users", zopts[:user_key],
                                                           zopts.zdelete_keys!(%w(user_key project)))
          yield(reshh) if (not reshh.nil?) && block_given?
          reshh
        end

        def update(*args)
          zopts = args.extract_zedkit_options!
          reshh = Zedkit::Client.update("projects/#{zopts[:project][:uuid]}/users/#{zopts[:user][:uuid]}", zopts[:user_key],
                                                                                  zopts.zdelete_keys!(%w(user_key project)))
          yield(reshh) if (not reshh.nil?) && block_given?
          reshh
        end
        
        def delete(*args)
          zopts = args.extract_zedkit_options!
          reshh = Zedkit::Client.delete("projects/#{zopts[:project][:uuid]}/users/#{zopts[:user][:uuid]}", zopts[:user_key])
          yield(reshh) if (not reshh.nil?) && block_given?
          reshh
        end
      end
    end

    class Emails
      class << self
        def get(*args)
          zopts = args.extract_zedkit_options!
          reshh = Zedkit::Client.get('emails', zopts[:user_key], zopts.zdelete_keys!(%w(user_key)))
          yield(reshh) if (not reshh.nil?) && block_given?
          reshh
        end
      end
    end
  end
end
