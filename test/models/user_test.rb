require "test_helper"

class UserTest < ActiveSupport::TestCase
  setup do
    @user = users(:Caio_User)
  end

  test "should not save user without full_name" do
    @user.full_name = nil
    assert_not @user.save
  end

  test "should not save user without cpf" do
    @user.cpf = nil
    assert_not @user.save
  end

  test "should not save user without email" do
    @user.email = nil
    assert_not @user.save
  end

  test "should not save user without password" do
    @user.password = nil
    assert_not @user.save
  end

  test "should not save user without kind" do
    @user.kind = nil
    assert_not @user.save
  end

  test "should not save user with invalid email" do
    @user.email = "invalid_email"
    assert_not @user.save
  end

  test "should not save user with invalid cpf" do
    @user.cpf = "123.456.789-00"
    assert_not @user.save
  end

  test "should save user" do
    assert @user.save
  end

  test "should kind be usuario" do
    assert @user.usuario?
  end

  test "should kind be lojista" do
    @user.kind = "lojista"
    assert @user.lojista?
  end
end
