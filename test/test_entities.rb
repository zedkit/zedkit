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

require "helper"

class TestEntities < Test::Unit::TestCase
  def test_entities
    zkes = Zedkit.entities
    assert_not_nil zkes["languages"]
    assert_not_nil zkes["locales"]
    assert_not_nil zkes["timezones"]
  end
  def test_entities_with_block
    Zedkit.entities do |zkes|
      assert_not_nil zkes["languages"]
      assert_not_nil zkes["locales"]
      assert_not_nil zkes["timezones"]
    end
  end

  def test_countries
    cnts = Zedkit.countries
    assert cnts.is_a? Array
    assert cnts.length >= 2
  end
  def test_countries_with_block
    Zedkit.countries do |cnts|
      assert_not_nil cnts["code"]
      assert_not_nil cnts["name"]
      assert_not_nil cnts["locale"]
    end
  end

  def test_regions
    rgss = Zedkit.regions
    assert rgss.is_a? Array
    assert_not_nil rgss.detect {|region| region["code"] == "WA" }
    assert_not_nil rgss.detect {|region| region["code"] == "BC" }
  end
  def test_regions_with_block
    Zedkit.regions do |rgss|
      assert_not_nil rgss["code"]
      assert_not_nil rgss["name"]
    end
  end
  def test_states_for_usa
    rgss = Zedkit.regions(:country => { :code => "US" })
    assert rgss.is_a? Array
    assert_nil rgss.detect {|region| region["code"] == "BC" }
  end
  def test_provinces_for_canada
    rgss = Zedkit.regions(:country => { :code => "CA" })
    assert rgss.is_a? Array
    assert_nil rgss.detect {|region| region["code"] == "WA" }
  end
end
