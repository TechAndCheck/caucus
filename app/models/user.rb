class User < ApplicationRecord
  rolify

  has_many :category_suggestions

  has_one_attached :avatar

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable

  before_create :assign_avatar
  after_create :assign_default_role

  validates :name, presence: true

  # We use the Devise::Trackable module to track sign-in count and current/last sign-in timestamp.
  # However, we don't want to track IP address, but Trackable tries to, so we have to manually
  # override the accessor methods so they do nothing.
  def current_sign_in_ip; end
  def last_sign_in_ip=(_ip); end
  def current_sign_in_ip=(_ip); end

  def is_first_login?
    sign_in_count === 1
  end

private

  def assign_default_role
    self.add_role(:user) if self.roles.blank?
  end

  def assign_avatar
    avatars = Dir.entries("app/assets/images/avatars-monsters")
    random_index = rand(avatars.count)
    avatar_file_name = avatars[random_index]
    self.avatar.attach(
      io: File.open("app/assets/images/avatars-monsters/#{avatar_file_name}"),
      filename: avatar_file_name,
      content_type: "image/png"
    )
  end
end
