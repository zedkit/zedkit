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
  class Project < Zedkit::Instance
    def to_s
         "\n" \
      << "Zedkit Project:\n" \
      << "  Name          : #{name}\n" \
      << "  UUID          : #{uuid}\n" \
      << "  Location      : #{location}\n" \
      << "  Locales\n" \
      << "    Default     : #{locales['default']}\n" \
      << "    Development : #{locales['development']}\n" \
      << "    Production  : #{locales['production']}\n" \
      << "  Shelves       : []\n" \
      << "  Blogs         : []\n" \
      << "  Version       : #{version}\n" \
      << "  Created       : #{time(created_at)}\n" \
      << "  Updated       : #{time(updated_at)}\n" \
      << dashes(20) << "\n"
    end

    protected
    def set(uuid)
      replace Zedkit::Projects.get(:user_key => uk, :locale => lc, :uuid => uuid)
    end
  end
end
