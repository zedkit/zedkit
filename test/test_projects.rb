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

class TestProjects < Test::Unit::TestCase
  def test_snapshot
    sn = Zedkit::Projects.snapshot(:user_key => @uu["user_key"], :uuid => @uu["projects"][0])
    assert_not_nil sn["project"]
  end
  def test_snapshot_with_block
    Zedkit::Projects.snapshot(:user_key => @uu["user_key"], :uuid => @uu["projects"][0]) do |sn|
      assert_not_nil sn["project"]
    end
  end

  def test_does_not_verify_invalid_locales_key
    assert_nil Zedkit::Projects.verify(:locales, "not.a.valid.key")
  end
  def test_verify_locales_key
    pp = Zedkit::Projects.verify(:locales, TEST_GEMS_LOCALES_KEY)
    assert_equal 32, pp["uuid"].length
    assert_equal "Zedkit Gems", pp["name"]
  end
  def test_verify_locales_key_with_block
    Zedkit::Projects.verify(:locales, TEST_GEMS_LOCALES_KEY) do |pp|
      assert_equal 32, pp["uuid"].length
      assert_equal "Zedkit Gems", pp["name"]
    end
  end

  def test_verify_project_key
    pp = Zedkit::Projects.verify(:project)
    assert_equal 32, pp["uuid"].length
    assert_equal "Zedkit Gems", pp["name"]
  end
  def test_verify_project_key_with_block
    Zedkit::Projects.verify(:project) do |pp|
      assert_equal 32, pp["uuid"].length
      assert_equal "Zedkit Gems", pp["name"]
    end
  end


  def test_get
    pp = Zedkit::Projects.get(:user_key => @uu["user_key"], :uuid => @uu["projects"][0])
    assert_equal "Zedkit Gems", pp["name"]
    assert_not_nil pp["uuid"]
    assert_not_nil pp["locales"]
    assert_not_nil pp["location"]
  end
  def test_get_with_block
    Zedkit::Projects.get(:user_key => @uu["user_key"], :uuid => @uu["projects"][0]) do |pp|
      assert_equal "Zedkit Gems", pp["name"]
      assert_not_nil pp["uuid"]
    end
  end

  def test_create
    pp = Zedkit::Projects.create(:user_key => @uu["user_key"], :project => { :name => "new_project" })
    assert_not_nil pp["location"]
    assert_equal "new_project", pp["name"]
  end
  def test_create_with_block
    Zedkit::Projects.create(:user_key => @uu["user_key"], :project => { :name => "new_project" }) do |pp|
      assert_not_nil pp["location"]
      assert_equal "new_project", pp["name"]
    end
  end

  def test_update
    pp = Zedkit::Projects.get(:user_key => @uu["user_key"], :uuid => @uu["projects"][0])
    uu = Zedkit::Projects.update(:user_key => @uu["user_key"], :uuid => pp["uuid"],
                                 :project => { :location => "new_location" })
    assert_equal "http://new_location.zedapi.com", uu["location"]
    assert_equal pp["uuid"], uu["uuid"]
  end
  def test_update_with_block
    Zedkit::Projects.get(:user_key => @uu["user_key"], :uuid => @uu["projects"][0]) do |pp|
      Zedkit::Projects.update(:user_key => @uu["user_key"], :uuid => pp["uuid"],
                              :project => { :location => "new_location" }) do |uu|
        assert_equal "http://new_location.zedapi.com", uu["location"]
        assert_equal pp["uuid"], uu["uuid"]
      end
    end
  end
  
  def test_delete
    assert_nil Zedkit::Projects.delete(:user_key => @uu["user_key"], :uuid => @uu["projects"][0])
  end


  def test_get_user_connections
    us = Zedkit::Projects::ProjectAdmins.get(:user_key => @uu["user_key"], :project => { :uuid => @uu["projects"][0] })
    assert us.is_a? Array
    assert_equal 2, us.length
    assert us.detect {|pu| pu["user"]["uuid"] == @uu["uuid"] }
  end
  def test_get_user_connections_in_block
    Zedkit::Projects::ProjectAdmins.get(:user_key => @uu["user_key"], :project => { :uuid => @uu["projects"][0] }) do |pu|
      assert_not_nil pu["user"]["uuid"]
      assert_not_nil pu["role"]
    end
  end

  def test_create_user_connection
  end
  def test_create_user_connection_with_block
  end

  def test_update_user_connection
    pp = Zedkit::Projects.get(:user_key => @uu["user_key"], :uuid => @uu["projects"][0])
    lk = Zedkit::Users.verify(:login => TEST_GEMS_LACKY, :password => TEST_GEMS_PASSWORD)
    uu = Zedkit::ProjectAdmins.update(:user_key => @uu["user_key"], :project => { :uuid => @uu["projects"][0] },
                                                                    :admin => { :uuid => pp["admins"][1] },
                                                                    :user => { :role => "P" })
    assert uu.is_a? Hash
    assert_equal "P", uu["role"]["code"]
  end
  def test_update_user_connection_with_block
    pp = Zedkit::Projects.get(:user_key => @uu["user_key"], :uuid => @uu["projects"][0])
    lk = Zedkit::Users.verify(:login => TEST_GEMS_LACKY, :password => TEST_GEMS_PASSWORD)
    Zedkit::ProjectAdmins.update(:user_key => @uu["user_key"], :project => { :uuid => @uu["projects"][0] },
                                                               :admin => { :uuid => pp["admins"][1] },
                                                               :user => { :role => "P" }) do |uu|
      assert uu.is_a? Hash
      assert_equal "P", uu["role"]["code"]
    end
  end

  def test_delete_user_connection
    pp = Zedkit::Projects.get(:user_key => @uu["user_key"], :uuid => @uu["projects"][0])
    lk = Zedkit::Users.verify(:login => TEST_GEMS_LACKY, :password => TEST_GEMS_PASSWORD)
    ud = Zedkit::ProjectAdmins.delete(:user_key => @uu["user_key"], :project => { :uuid => @uu["projects"][0] },
                                                                    :admin => { :uuid => pp["admins"][1] },
                                                                    :user => { :uuid => lk["uuid"] })
    assert_nil ud
  end
  def test_delete_user_connection_with_block
    pp = Zedkit::Projects.get(:user_key => @uu["user_key"], :uuid => @uu["projects"][0])
    lk = Zedkit::Users.verify(:login => TEST_GEMS_LACKY, :password => TEST_GEMS_PASSWORD)
    Zedkit::ProjectAdmins.delete(:user_key => @uu["user_key"], :project => { :uuid => @uu["projects"][0] },
                                                               :admin => { :uuid => pp["admins"][1] },
                                                               :user => { :uuid => lk["uuid"] }) do |ud|
      assert_nil ud
    end
  end


  def test_get_emails
    # ee = Zedkit::Projects::Emails.get(:user_key => @uu["user_key"], :project => { :uuid => @uu["projects"][0] })
    # assert_not_nil ee
    # assert ee.is_a? Array
  end
  def test_get_emails_with_block
    # Zedkit::Projects::Emails.get(:user_key => @uu["user_key"], :project => { :uuid => @uu["projects"][0] }) do |ee|
    #   assert_not_nil ee
    #   assert ee.is_a? Array
    # end
  end
end
