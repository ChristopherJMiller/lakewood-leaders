# = Token
# Represents a user via a token for use off of the site
#
# == Data
# [token] String of a token
# [user] Reference to user the token is defined for
#
# == Attributes
# * Belongs to a single user
# * User and Token must be present
class Token < ActiveRecord::Base
  belongs_to :user
  validates :user, presence: true
  validates :token, presence: true
end
