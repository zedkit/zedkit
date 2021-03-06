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
    class CommandLineError < Zedkit::ZedkitError
      attr_reader :locale, :message

      def initialize(info = {})
        @locale  = info[:locale]  || :en
        @message = info[:message] || nil
      end

      def to_s
        rs  = "\n" << Zedkit::CLI.ee(locale, :general, :error) << "\n"
        rs << "  #{Zedkit::CLI.ee(locale, :general, :message)} => #{message}.\n\n" unless message.nil?
      end
    end

    class MissingCredentials < CommandLineError
      def to_s
        rs  = "\n" << Zedkit::CLI.ee(locale, :general, :error) << "\n"
        rs << "  #{Zedkit::CLI.ee(locale, :general, :message)} => #{message}.\n" unless message.nil?
        rs << "  You need to setup your Zedkit login or user API key in ~/.zedkit to the use the Zedkit CLI.\n"
        rs << "  Example:\n"
        rs << "    fred@flintstone.com\n"
        rs << "    StRongPassWoRd\n\n"
      end
    end
    class UnknownCommand < CommandLineError
    end
    class MissingParameter < CommandLineError
    end
  end
end
