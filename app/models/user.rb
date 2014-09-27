class User < ActiveRecord::Base
	attr_accessor :current_password

	has_secure_password({ validations: false })

  scope :users, -> { joins(:user_type).where(user_types: {name: "user"}).readonly(false) }

  belongs_to :user_type
  
  # User belongs to other users -> .users
  # User has many users -> .inverse_users
  has_many :parents, dependent: :destroy
  has_many :users, through: :parents
  has_many :inverse_parents, :class_name => "Parent", :foreign_key => "parent_id"
  has_many :inverse_users, :through => :inverse_parents, :source => :user

  has_many :ownerships
  has_many :verificator_comments
  has_many :activities
  has_many :articles
  has_many :connections
  has_many :subjects

  # User belongs to cards as responsables
  has_many :card_users, dependent: :destroy
  has_many :cards, through: :card_users
  has_one :orator, dependent: :destroy

  # User owned a card
  has_many :cards

  mount_uploader :avatar, AvatarUploader

  accepts_nested_attributes_for :orator

  with_options unless: :is_group? do |user|
    user.validates :firstname, presence: true, length: { maximum: 15 }
    user.validates :lastname, presence: true, length: { maximum: 15 }
    user.validates :email, :format => { :with => /\b[A-Z0-9._%a-z\-]+@(?:[A-Z0-9a-z\-]+\.)+[A-Za-z]{2,4}\z/ }, uniqueness: true
    user.validates :gravatar_email, :format => { :with => /\b[A-Z0-9._%a-z\-]+@(?:[A-Z0-9a-z\-]+\.)+[A-Za-z]{2,4}\z/ }, on: :update?

    user.after_validation :format
    user.before_save :create_remember_token
    user.before_create :assign_gravatar
  end
  validates :password, presence: true, length: { minimum: 5 }, confirmation: true, :unless => lambda { |v| v.validate_password? || v.is_group? }

  def send_password_reset
    self.reset_token =  SecureRandom.urlsafe_base64
    self.reset_sent_at = Time.zone.now
    save!
    # sends reset link
    UserMailer.password_reset(self).deliver
  end

  def full_name
    "#{firstname} #{lastname}"
  end

  def validate_password?
    password.blank? && password_confirmation.blank? && !self.new_record?
  end

  def is_group?
    user_type_id == UserType.find_by_name('group').id
  end

  def gravatar_url(size = 100)
    default_url = URI.escape "identicon"
    if self.gravatar_email
      "http://gravatar.com/avatar/#{Digest::MD5.hexdigest(self.gravatar_email.downcase)}.png?d=#{default_url}&s=#{size}"
    else
      "http://gravatar.com/avatar/#{Digest::MD5.hexdigest('no')}.png?d=#{default_url}&s=#{size}"
    end
  end

  def unconfirmed_cards
    card_users.where(user_validated: nil)
  end

  def confirmed_cards
    Card.joins(:card_users).where("card_users.user_validated = ? AND card_users.card_validated = ? AND card_users.user_id = ?", true, true, id) + Card.where(user_id: id)
  end

  def update_with_password(params)
    authenticated = authenticate(params[:current_password])
    if authenticated && update_attributes(params)
      true
    else
      errors.add(:current_password, "does not match") unless authenticated
      false
    end
  end

  def image
    if gravatar || avatar_url.nil?
      gravatar_url
    else
      avatar.thumb.url
    end
  end

  private

  # Remove spaces and capitales
  def format
    self.firstname.strip!
    self.lastname.strip!
    self.email.strip
    self.firstname.capitalize!
    self.lastname.capitalize!
    self.email.downcase!
  end

  def create_remember_token
    self.remember_token = SecureRandom.urlsafe_base64
  end

  def assign_gravatar
    self.gravatar_email = self.email
  end
end
