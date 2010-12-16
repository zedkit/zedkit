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
    class << self
      def tt(locale, key, item)
        Zedkit::CLI.lookup_tt("Zedkit::CLI", locale, key, item)
      end
      def ee(locale, key, item)
        Zedkit::CLI.lookup_ee("Zedkit::CLI", locale, key, item)
      end
    end

    LOCALES = %w(en).freeze
    CONTENT = {
      :en => {
        :commands => {
          :projects => "Project Commands",
          :projects_list => "List Zedkit projects",
          :projects_show => "Show Zedkit project details",
          :projects_create => "Create a new Zedkit project",
          :projects_update => "Update an existing Zedkit project",
          :projects_delete => "Delete an existing Zedkit project"
        }
      }
    }
    ERRORS = {
      :en => {
        :runner => {
          :credentials => "Missing Zedkit Credentials",
          :zedkit_file => "Missing Zedkit Credentials in ~/.zedkit"
        },
        :general => {
          :error => "Zedkit CLI ERROR.",
          :message => "Message",
          :section => "Unknown Section",
          :unknown => "Unknown Command",
          :not_done => "This operation is not yet implemented."
        },
        :project => {
          :nil => "Project UUID is nil"
        }
      }
    }.freeze

    class << self
      def lookup_tt(ch, locale, key, item)
        rs = lookup(eval("#{ch}::CONTENT"), locale, key, item)
        rs = lookup(eval("Zedkit::CLI::CONTENT"), locale, key, item) if rs.nil?
        rs
      end
      def lookup_ee(ch, locale, key, item)
        rs = lookup(eval("#{ch}::ERRORS"), locale, key, item)
        rs = lookup(eval("Zedkit::CLI::ERRORS"), locale, key, item) if rs.nil?
        rs
      end

      protected
      def lookup(set, locale, key, item)
        if set.has_key?(locale) && set[locale].has_key?(key) && set[locale][key].has_key?(item)
          set[locale][key][item]
        elsif set[:en].has_key?(key) && set[:en][key].has_key?(item)
          set[:en][key][item]
        else
          nil end
      end
    end
  end
end
