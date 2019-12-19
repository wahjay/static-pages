class User < ApplicationRecord
  # explicitly tells Rails the foreign_key is "follower_id"
  # An id used to connect two database tables is known as a foreign key
  # A follows B; This is an active relationship for A (who is a follower)
  has_many :active_relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy

  # A follows B but B doesn't follow back; This is a passive relationship for B (who is a followed)
  has_many :passive_relationships, class_name:  "Relationship", foreign_key: "followed_id", dependent: :destroy

  # explicitly tells Rails that the source of the 'following_id array' is the set of 'followed ids'.
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower

  #create association with microposts
  #also, when a user is deleted, all of its associated microposts should be deleted as well
  has_many :microposts, dependent: :destroy
  #virtual attributes
  attr_accessor :remember_token, :activation_token, :reset_token
  before_create :create_activation_digest
  before_save { self.email = email.downcase }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 },
            format: { with: VALID_EMAIL_REGEX },
            uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

  # Returns the hash digest of the given string.
  #  create a user fixture for a valid user
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # Returns a random token.
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  # Remember a user in the database for use in persistent session.
  def remember
    #remember_token is virtual
    #actually, there is no remember_token attribtue in User model
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # Returns true if the given token matches the digest.
  #def authenticated?(remember_token)
  #  return false if remember_digest.nil?
  #  BCrypt::Password.new(remember_digest).is_password?(remember_token)
  #end

  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  # Forgets a user by updating the remember digest with nil
  def forget
    update_attribute(:remember_digest, nil)
  end

  # Activates an account.
  def activate
    update_attribute(:activated,    true)
    update_attribute(:activated_at, Time.zone.now)
  end

  # Sends activation email.
  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  # Sets the password reset attributes.
  def create_reset_digest
    #create a reset token, which is virtual user attribute
    self.reset_token = User.new_token
    #get the reset_digest from the newly generated reset_token
    #and save it to the database for later authetication
    #also get the time when the reset_token is created
    update_columns(reset_digest:  User.digest(reset_token), reset_sent_at: Time.zone.now)
  end

  # Sends password reset email.
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  # Returns true if a password reset has expired.
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  # Returns a user's status feed.
  # this method utilize the combination of Rails, Ruby, and SQL for efficiency
  def feed
    #get all the user_ids the current_user are following
    following_ids = "SELECT followed_id FROM relationships WHERE follower_id = :user_id"

    #and then get all of the microposts correspoding to those user_ids, including the current_users's
    Micropost.where("user_id IN (#{following_ids}) OR user_id = :user_id", user_id: id)
  end

  #helper methods for User relationship model

  # Follows a user.
  def follow(other_user)
    following << other_user
  end

  # Unfollows a user.
  def unfollow(other_user)
    following.delete(other_user)
  end

  # Returns true if the current user is following the other user.
  def following?(other_user)
    following.include?(other_user)
  end

  private
  # Creates and assigns the activation token and digest.
    def create_activation_digest
      self.activation_token = User.new_token
      self.activation_digest = User.digest(activation_token)
    end
end
