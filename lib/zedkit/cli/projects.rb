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
  module CLI
    class Projects < Zedkit::CLI::Bottom
      class << self
        def list(opts = {})
          begin
            rs  = dashes(122) << "| #{'Zedkit Projects'.ljust(118)} |\n" << dashes(122)
            rs << "| #{'UUID'.ljust(32)} | #{'Name'.ljust(32)} | #{'Location'.ljust(48)} |\n" << dashes(122)
            Zedkit::Users::Projects.get(:user_key => opts[:user_key]) do |up|
              pp  = up['project']
              rs << "| #{pp['uuid'].ljust(32)} | #{pp['name'].ljust(32)} | #{pp['location'].ljust(48)} |\n"
            end
            puts rs << dashes(122)
          rescue Zedkit::ZedkitError => zke
            puts zke end
        end

        def show(opts = {})
          begin
            puts Zedkit::Project.new.replace Zedkit::Projects.get(:user_key => opts[:user_key], :uuid => opts[:argv][0])
          rescue Zedkit::ZedkitError => zke
            puts zke end
        end

        def create(opts = {})
          puts "\n" << Zedkit::CLI.ee(locale, :general, :not_done) << "\n\n"
        end

        def update(opts = {})
          puts "\n" << Zedkit::CLI.ee(locale, :general, :not_done) << "\n\n"
        end
        
        def delete(opts = {})
          puts "\n" << Zedkit::CLI.ee(locale, :general, :not_done) << "\n\n"
        end
      end
    end
  end
end
