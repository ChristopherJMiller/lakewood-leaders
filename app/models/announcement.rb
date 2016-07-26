# = Announcement
# Represents an announcement posted by an admin or advisor.
#
# == Data
# [title] String that contains the title of the announcement post.
# [post] Text that contains the body of the announcement post.
# [user] Author of the post.
# [created_at] The time at which the post was created.
# == Attributes
# * A title, post, and user must be present.
# * The title cannot be longer than 64 characters.
# * THe post cannot be longer than 1024 chracters.
class Announcement < ActiveRecord::Base
  belongs_to :user

  validates :title, presence: true
  validates :title, length: { maximum: 64 }
  validates :post, presence: true
  validates :post, length: { maximum: 5120 }
  validates :user, presence: true
end
