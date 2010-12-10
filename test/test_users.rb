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
    assert_not_nil @uu
    assert @uu.is_a? Hash
    assert_equal 32, @uu['uuid'].length
    assert_equal TEST_GEMS_LOGIN, @uu['email']
  end

  def test_get_fails
    assert_nil Zedkit::Users.get(:user_key => 'whatever', :uuid => 'notvaliduuid')
  end

  def test_get
    json = Zedkit::Users.get(:user_key => @uu['user_key'], :uuid => @uu['uuid'])
    assert_not_nil json
    assert json.is_a? Hash
    assert_equal 32, json['uuid'].length
    assert_equal TEST_GEMS_LOGIN, json['email']
  end

  def test_create
    json = Zedkit::Users.create(:user_key => @uu['user_key'],
                                :user => { :first_name => 'Fred', :surname => 'Flinstone',
                                           :email => 'gemusertest@zedkit.com', :password => 'password' })
    assert_not_nil json
    assert json.is_a? Hash
    assert_equal 32, json['uuid'].length
    assert_equal 'Fred', json['first_name']
    assert_equal 'gemusertest@zedkit.com', json['email']
  end

  def test_users_projects_list
    json = Zedkit::Users::Projects.get(:user_key => @uu['user_key'])
    assert_not_nil json
    assert json.is_a? Array
    assert_equal 1, json.length
  end
end
