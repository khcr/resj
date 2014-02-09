class User < ActiveRecord::Base
	attr_accessor :current_password

	has_secure_password({ validations: false })

  belongs_to :user_type
  has_many :card_verifications, dependent: :destroy
  has_many :cards, through: :card_verifications
  has_many :ownerships
  has_many :parents
  has_many :users, through: :parents
  has_many :verificator_comments

  before_save :format, :create_remember_token

  validate :match_current_password

  def send_password_reset
    self.reset_token =  SecureRandom.urlsafe_base64
    self.reset_sent_at = Time.zone.now
    save!
    UserMailer.password_reset(self).deliver
  end

  private

  # Control by an update if the current_password is right
  def match_current_password
    if current_password && !self.authenticate(current_password)
  		errors.add(:current_password, "does not match password")
    end
  end

  # Remove spaces and capitales
  def format
    self.email.try(:strip!)
    self.email.try(:downcase!)
    self.name.try(:strip!)
  end

  def create_remember_token
    self.remember_token = SecureRandom.urlsafe_base64
  end
end
