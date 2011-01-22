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
    class Runner
      attr_accessor :user_key, :username, :password, :locale
      attr_reader :config, :section, :command, :items

      SECTIONS = ['projects']

      def initialize
        @user_key, @username, @password = nil, nil, nil
        @locale = :en
        @config = File.expand_path('~') << "/.zedkit"
        if !ARGV.empty? && ARGV[0].include?(":")
          @section = ARGV[0].split(":")[0]
          @command = ARGV[0].split(":")[1]
        else
          @section = SECTIONS[0]
          ARGV.empty? ? @command = nil : @command = ARGV[0]
        end
        ARGV.shift
        begin
          set_credentials if has_section? && has_command?
          set_items
        rescue Zedkit::CLI::ZedkitError => zke
          puts zke end
      end

      def has_user_key?
        user_key && user_key.is_a?(String) && !user_key.nil?
      end
      def has_username?
        username && username.is_a?(String) && !username.nil?
      end
      def has_password?
        password && password.is_a?(String) && !password.nil?
      end
      def has_credentials?
        has_user_key? || (has_username? && has_password?)
      end

      def has_section?
        not section.nil?
      end
      def has_command?
        not command.nil?
      end

      def has_items?
        items && items.length > 0
      end
      def items_to_key_value_hash
        rh = {}
        items.each {|item| rh[item.split('=')[0]] = item.split('=')[1] if item.include?('=') } if has_items?
        rh
      end

      def go!
        begin
          if has_section? && has_command?
            if has_credentials?
              unless has_user_key?
                @user_key = Zedkit::Users.verify(:login => username, :password => password)['user_key']
              end
              run
            else
              raise Zedkit::CLI::MissingCredentials.new(:message => Zedkit::CLI.ee(locale, :runner, :credentials)) end
          else
            puts commands end
        rescue Zedkit::ZedkitError => zke
          puts zke end
      end

      protected
      def me
        Object.const_get('Zedkit').const_get('CLI')
      end
      def run
        is = items_to_key_value_hash
        ks = me.const_get(section.capitalize)          
        case command.to_sym
        when :list
          ks.send :before_list, :locale => locale, :items => is, :argv => ARGV if ks.respond_to?(:before_list)
        when :create
          ks.send :before_create, :locale => locale, :items => is, :argv => ARGV if ks.respond_to?(:before_create)
        when :show, :update, :delete
          if ks.respond_to?(:before_show_update_delete)
            ks.send :before_show_update_delete, :locale => locale, :items => is, :argv => ARGV end
        end
        ks.send command.to_sym, :locale => locale, :user_key => user_key, :items => items_to_key_value_hash, :argv => ARGV
      end
      def commands
           "\n" \
        << "== #{Zedkit::CLI.tt(locale, :commands, :projects)}\n\n" \
        << "list                                        # #{Zedkit::CLI.tt(locale, :commands, :projects_list)}\n" \
        << "show <uuid>                                 # #{Zedkit::CLI.tt(locale, :commands, :projects_show)}\n" \
        << "create <name> key=value [...]               # #{Zedkit::CLI.tt(locale, :commands, :projects_create)}\n" \
        << "update <uuid> key=value [...]               # #{Zedkit::CLI.tt(locale, :commands, :projects_update)}\n" \
        << "delete <uuid>                               # #{Zedkit::CLI.tt(locale, :commands, :projects_delete)}\n\n" \
        << "== User Commands\n\n" \
        << "users:list <project uuid>                   # #{Zedkit::CLI.tt(locale, :commands, :users_list)}\n" \
        << "users:show <project uuid> <login>           # #{Zedkit::CLI.tt(locale, :commands, :users_show)}\n" \
        << "users:create <project> key=value [...]      # #{Zedkit::CLI.tt(locale, :commands, :users_create)}\n" \
        << "users:update <uuid> key=value [...]         # #{Zedkit::CLI.tt(locale, :commands, :users_update)}\n" \
        << "users:delete <uuid>                         # #{Zedkit::CLI.tt(locale, :commands, :users_delete)}\n\n" \
        << "==\n\n"
      end

      private
      def set_credentials
        if File.exists?(config)
          st = File.open(config).readlines.map(&:strip).delete_if {|i| i.empty? }
          if st.length > 2
            @username = st[0]
            @password = st[1]
          else
            @user_key = st[0] end
        else
          raise Zedkit::CLI::MissingCredentials.new(:message => Zedkit::CLI.ee(locale, :runner, :zedkit_file)) end
      end
      def set_items
        ARGV.length > 1 ? @items = ARGV.slice(1, ARGV.length - 1) : @items = nil
      end
      def set_locale
        if File.exists?(config)
          st = File.open(config).readlines.map(&:strip).delete_if {|i| i.empty? }
          if st.length >= 2
            @locale = st[st.length - 1].to_sym if Zedkit::CLI.include?(st[st.length - 1].to_sym)
          end
        end
      end
    end
  end
end
