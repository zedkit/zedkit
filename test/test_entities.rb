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

require 'helper'

class TestEntities < Test::Unit::TestCase
  def test_entities
    zkes = Zedkit.entities(@uu['user_key'])
  end
  def test_entities_in_block
    Zedkit.entities(@uu['user_key']) do |zkes|
    end
  end

  def test_countries
    cnts = Zedkit.countries(@uu['user_key'])
    assert cnts.is_a? Array
    assert cnts.length >= 2
  end
  def test_countries_in_block
    Zedkit.countries(@uu['user_key']) {|cnts| assert cnts.length >= 2 }
  end

  def test_regions
    rgss = Zedkit.regions(@uu['user_key'])
    assert rgss.is_a? Array
    assert_not_nil rgss.detect {|region| region['code'] == 'WA' }
    assert_not_nil rgss.detect {|region| region['code'] == 'BC' }
  end
  def test_regions_in_block
    Zedkit.regions(@uu['user_key']) {|rgss| assert_not_nil rgss.detect {|region| region['code'] == 'WA' } }
  end

  def test_states_for_usa
    rgss = Zedkit.regions(@uu['user_key'], :country => { :code => 'US' })
    assert rgss.is_a? Array
    assert_nil rgss.detect {|region| region['code'] == 'BC' }
  end
  def test_states_for_usa_in_block
    Zedkit.regions(@uu['user_key'], :country => { :code => 'US' }) do |rgss|
      assert rgss.is_a? Array
      assert_nil rgss.detect {|region| region['code'] == 'BC' }
    end
  end

  def test_provinces_for_canada
    rgss = Zedkit.regions(@uu['user_key'], :country => { :code => 'CA' })
    assert rgss.is_a? Array
    assert_nil rgss.detect {|region| region['code'] == 'WA' }
  end
  def test_provinces_for_canada_in_block
    Zedkit.regions(@uu['user_key'], :country => { :code => 'CA' }) do |rgss|
      assert rgss.is_a? Array
      assert_nil rgss.detect {|region| region['code'] == 'WA' }
    end
  end
end
