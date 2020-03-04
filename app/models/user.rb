class User < ApplicationRecord
  rolify

  has_many :category_suggestions

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable

  after_create :assign_default_role

  def is_first_login?
    sign_in_count === 1
  end

private

  def assign_default_role
    self.add_role(:user) if self.roles.blank?
  end
end
