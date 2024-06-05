require "test_helper"

class TransactionTest < ActiveSupport::TestCase
  setup do
    @transaction = transactions(:one)
  end

  test "should be valid" do
    assert @transaction.valid?
  end

  test "amount should be present" do
    @transaction.amount = nil
    assert_not @transaction.valid?
  end

  test "amount should be greater than 0" do
    @transaction.amount = 0
    assert_not @transaction.valid?
  end

  test "kind should be present" do
    @transaction.kind = nil
    assert_not @transaction.valid?
  end

  test "kind should be deposit or withdraw" do
    assert_raises(ArgumentError) do
      @transaction.assign_attributes(kind: "invalid")
    end
  end

  test "kind should be valid when set to deposit" do
    @transaction.kind = "deposit"
    assert @transaction.valid?
  end

  test "kind should be valid when set to withdraw" do
    @transaction.kind = "withdraw"
    assert @transaction.valid?
  end


  test "user should be present" do
    @transaction.user = nil
    assert_not @transaction.valid?
  end
end
