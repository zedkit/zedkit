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

##
# We want to transform something like this:
#   { :user => { :email => "whatever@zedkit.com", :password => "pwd", :first_name => "Fred", :surname => "Flintstone" } }
#
# Into something like this for submission to the ZedAPI:
#   { 
#     "user[email]" => "whatever@zedkit.com",
#     "user[password]" => "pwd", "user[first_name]" => "Fred", "user[surname]" => "Flintstone"
#   }
#
# The API only ever uses a single level, never something like [user][project][name]. If more than a single level is 
# submitted we don't bother to try and sort it out here, as it will not work anyway. Let the caller figure that out and
# resolve it on their end.
#
# FYI, the API's backend controllers do NOT use mass assignment for attributes submitted, EVER. Submitting anything other
# than documented object data items for each API method has no negative impact. Inapplicable attributes, or nefarious
# submissions on update, such as user[uuid], are simply ignored.
##

class Hash
  def flatten_zedkit_params!                      ## The implementation of this did not require a staging hash until
    tmph = {}                                     ## 1.9.2: RuntimeError: can't add a new key into hash during iteration
    each do |k,v|
      if v.is_a?(Hash)                                          # self.each do |k,v|
        v.each {|vk,vv| tmph["#{k}[#{vk}]"] = vv }              #   if v.is_a?(Hash)
        delete(k)                                               #     v.each {|vk,vv| merge!({ "#{k}[#{vk}]" => vv }) }
      end                                                       #     self.delete(k)
    end                                                         #   end
    merge!(tmph)                                                # end
  end
  def zdelete_keys!(zedkeys = [])
    delete_if {|k| zedkeys.include?(k.to_s) }
  end

  def zedkit_object?
    self.has_key?('uuid') && self['uuid'].is_a?(String) && self['uuid'].length == 32
  end
  def has_zedkit_errors?
    has_key?("status") && self["status"]["result"] == "ERROR"
  end
end
