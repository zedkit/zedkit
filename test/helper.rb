#
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
#

require "test/unit"
require "rubygems"
require "zedkit"

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), "..", "lib"))
$LOAD_PATH.unshift(File.dirname(__FILE__))

class Test::Unit::TestCase
  TEST_GEMS_PROJECT_KEY = "BE1OZog8gJogtQTosh"
  TEST_GEMS_LOCALES_KEY = "6yca7DsnBvaDVupKEZ"
  TEST_GEMS_LOGIN = "gems@zedkit.com"
  TEST_GEMS_LACKY = "lacky@zedkit.com"
  TEST_GEMS_TEMP  = "temp@zedkit.com"
  TEST_GEMS_PASSWORD = "NGIaDhr5vDlXo1tDs6bW3Gd"

  def setup
    Zedkit.configure do |zk|
      zk.api_host = "127.0.0.1"
      zk.api_port = "3000"
      zk.project_key = TEST_GEMS_PROJECT_KEY
    end
    @uu = Zedkit::Users.verify(:login => TEST_GEMS_LOGIN, :password => TEST_GEMS_PASSWORD)
  end
end
