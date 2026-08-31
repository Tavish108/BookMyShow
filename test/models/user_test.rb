require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "creates a valid user" do
    user = User.new(
      name: "Test User",
      email: "test@example.com",
      phone: "9999999999",
      password: "password123",
      password_confirmation: "password123"
    )

    assert user.valid?
  end

  test "requires an email" do
    user = User.new(
      name: "Test User",
      password: "password123",
      password_confirmation: "password123"
    )

    assert_not user.valid?
    assert_includes user.errors[:email], "can't be blank"
  end

  test "rejects duplicate email" do
    User.create!(
      name: "First User",
      email: "test@example.com",
      password: "password123",
      password_confirmation: "password123"
    )

    duplicate_user = User.new(
      name: "Second User",
      email: "test@example.com",
      password: "password123",
      password_confirmation: "password123"
    )

    assert_not duplicate_user.valid?
    assert_includes duplicate_user.errors[:email], "has already been taken"
  end

  test "authenticates with the correct password" do
    user = User.create!(
      name: "Test User",
      email: "test@example.com",
      password: "password123",
      password_confirmation: "password123"
    )

    assert user.authenticate("password123")
  end

  test "does not authenticate with an incorrect password" do
    user = User.create!(
      name: "Test User",
      email: "test@example.com",
      password: "password123",
      password_confirmation: "password123"
    )

    assert_not user.authenticate("wrongpassword")
  end
end