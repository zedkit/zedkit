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

module Zedkit
  class Instance < Hash
    attr_accessor :user_key, :locale
    alias_method :uk, :user_key
    alias_method :lc, :locale

    def initialize(api = {})
      @user_key = api[:user_key] || nil
      @locale   = api[:locale]   || :en
      if api.has_key?(:owner) && api.has_key?(:uuid)
        set_with_owner_and_uuid(api[:owner], api[:uuid]) && respond_to?(:set_with_owner_and_uuid)
      elsif api.has_key?(:uuid) && respond_to?(:uuid)
        set_with_uuid(api[:uuid]) end
    end

    def set_with_hash(hh)
      replace hh
    end

    def method_missing(kk)
      return self[kk.to_s] if self.has_key? kk.to_s
      super
    end

    protected
    def time(i)
      Time.at(i).to_date
    end
    def dashes(length = 128)
      Array.new(length, '-').join << "\n"
    end
  end
end
