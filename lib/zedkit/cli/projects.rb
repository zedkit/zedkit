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
            puts show_projects Zedkit::Users::Projects.get(:user_key => opts[:user_key])
          rescue Zedkit::ZedkitError => zke
            puts zke end
        end

        def show(opts = {})
          begin
            puts show_project Zedkit::Projects.get(:user_key => opts[:user_key], :uuid => opts[:argv][0])
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

        protected
        def show_project(project)
          rs  = "\n" \
             << "Zedkit Project:\n" \
             << "  Name          : #{project['name']}\n" \
             << "  UUID          : #{project['uuid']}\n" \
             << "  Location      : #{project['location']}\n" \
             << "  Locales\n" \
             << "    Default     : #{project['locales']['default']}\n" \
             << "    Development : #{project['locales']['development']}\n" \
             << "    Production  : #{project['locales']['production']}\n" \
             << "  Shelves       : []\n" \
             << "  Blogs         : []\n" \
             << "  Version       : #{project['version']}\n" \
             << "  Created       : #{Time.at(project['created_at']).to_date}\n" \
             << "  Updated       : #{Time.at(project['updated_at']).to_date}\n" \
             << dashes(20) << "\n"
        end
        def show_projects(projects)
          rs  = dashes(122)
          rs << "| #{'Zedkit Projects'.ljust(118)} |\n"
          rs << dashes(122)
          rs << "| #{'UUID'.ljust(32)} | #{'Name'.ljust(32)} | #{'Location'.ljust(48)} |\n"
          rs << dashes(122)
          projects.each do |pp|
            rs << "| #{uuid(pp['project'])} | #{pp['project']['name'].ljust(32)} | #{pp['project']['location'].ljust(48)} |\n"
          end
          rs << dashes(122)
        end
      end
    end
  end
end
