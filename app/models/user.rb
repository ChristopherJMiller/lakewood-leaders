class User < ActiveRecord::Base
  before_create :add_token

  has_secure_password
  validates :name, presence: true
  validates :email, presence: true
  validates :email, email_format: { check_mx: true }
  validates :email, uniqueness: true
  validates :password, length: { minimum: 8 }
  validates :verified, inclusion: [true, false]

  def as_json(options={})
    options[:except] ||= [:password_digest]
    super(options)
  end

  private
    def add_token
      if self.verify_token.blank?
          self.verify_token = SecureRandom.uuid
      end
    end
end
