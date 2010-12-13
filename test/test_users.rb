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

class TestUsers < Test::Unit::TestCase
  def test_verify_fails
    assert_nil Zedkit::Users.verify(:username => TEST_GEMS_LOGIN, :password => 'not.the.password')
  end
  def test_verify
    assert @uu.is_a? Hash
    assert_equal 32, @uu['uuid'].length
    assert_equal TEST_GEMS_LOGIN, @uu['email']
  end
  def test_verify_with_block
    Zedkit::Users.verify(:username => TEST_GEMS_LOGIN, :password => TEST_GEMS_PASSWORD) do |uu|
      assert @uu.is_a? Hash
      assert_equal 32, @uu['uuid'].length
    end
  end

  def test_projects_list
    pp = Zedkit::Users::Projects.get(:user_key => @uu['user_key'], :whatever => "yo")
    assert pp.is_a? Array
    assert_equal 1, pp.length
  end
  def test_projects_list_with_block
    Zedkit::Users::Projects.get(:user_key => @uu['user_key']) do |pp|
      assert_not_nil pp['project']
      assert_not_nil pp['permissions']
    end
  end

  def test_get_fails
    assert_nil Zedkit::Users.get(:user_key => 'whatever', :uuid => 'notvaliduuid')
  end
  def test_get
    uu = Zedkit::Users.get(:user_key => @uu['user_key'], :uuid => @uu['uuid'])
    assert uu.is_a? Hash
    assert_equal 32, uu['uuid'].length
    assert_equal TEST_GEMS_LOGIN, uu['email']
  end
  def test_get_with_block
    Zedkit::Users.get(:user_key => @uu['user_key'], :uuid => @uu['uuid']) do |uu|
      assert uu.is_a? Hash
      assert_equal 32, uu['uuid'].length
    end
  end

  def test_create
    uu = Zedkit::Users.create(:user_key => @uu['user_key'], :user => { :first_name => 'Fred', :surname => 'Flinstone',
                                                                       :email => 'gemusertest@zedkit.com',
                                                                       :password => 'password' })
    assert uu.is_a? Hash
    assert_equal 32, uu['uuid'].length
    assert_equal 'Fred', uu['first_name']
    assert_equal 'gemusertest@zedkit.com', uu['email']
  end
  def test_create_with_block
    Zedkit::Users.create(:user_key => @uu['user_key'], :user => { :first_name => 'Fred', :surname => 'Flinstone',
                                                                  :email => 'gemusertest@zedkit.com',
                                                                  :password => 'password' }) do |uu|
      assert uu.is_a? Hash
      assert_equal 32, uu['uuid'].length
    end
  end
end
