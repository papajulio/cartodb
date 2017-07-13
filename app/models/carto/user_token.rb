require 'active_record'

module Carto
  class UserToken < ActiveRecord::Base
    PERMISSIONS_READ_ONLY = 'R'
    PERMISSIONS_READ_WRITE = 'RW'

    belongs_to :user_table, inverse_of: :user_tokens

    def is_read_only?
      permissions == PERMISSIONS_READ_ONLY
    end

    def is_valid?(user_token_passed, permissions_passed = PERMISSIONS_READ_ONLY)
      user_token_passed == user_token && permissions.include? permissions_passed 
    end

  end
end
