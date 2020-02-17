require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "New user cannot have already existant email" do
    assert_raises(ActiveRecord::RecordInvalid) do
      User.create!({ email: "test@test.com", password: "test1234" })
    end
  end

  test "New user should have default 'user' role" do
    user = User.create!({ email: "test123@test.com", password: "test1234" })

    assert user.has_role?(:user), "User should have default 'user' role"
    assert_not user.has_role?(:admin), "User should not have admin role by default"
  end
end
