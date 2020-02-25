class User < ApplicationRecord
  rolify

  has_many :category_suggestions

  has_one_attached :avatar

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :validatable

  before_create :assign_avatar
  after_create :assign_default_role

private

  def assign_default_role
    self.add_role(:user) if self.roles.blank?
  end

  def assign_avatar
    self.avatar.attach(io: File.open("app/assets/images/avatars-monsters/001-monster-27.png"), filename: "001-monster-27.png", content_type: "image/png")
  end
end
