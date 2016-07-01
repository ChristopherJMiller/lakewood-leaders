class Token < ActiveRecord::Base
  belongs_to :user
  validates :user, presence: true
  validates :token, presence: true
end
