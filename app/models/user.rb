class User < ApplicationRecord
  rolify

  has_many :category_suggestions

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable

  after_create :assign_default_role

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
end
