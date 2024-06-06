require 'test_helper'

class TransactionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @payer = users(:Caio_User)
    @payee = users(:Jose_lojista)

    @valid_attributes = {
      payer: @payer.id,
      payee: @payee.id,
      value: 100.0
    }

  end

  test "should return not_found if payer not found" do
    post transfer_url, params: { payer: -1, payee: @payee.id, value: 100.0 }
    assert_response :not_found
    assert_includes @response.body, 'Usuário não encontrado'
  end

  test "should return not_found if payee not found" do
    post transfer_url, params: { payer: @payer.id, payee: -1, value: 100.0 }
    assert_response :not_found
    assert_includes @response.body, 'Usuário não encontrado'
  end

  test "should return unprocessable_entity if payer is lojista" do
    post transfer_url, params: { payer: @payee.id, payee: @payer.id, value: 100.0 }
    assert_response :unprocessable_entity
    assert_includes @response.body, 'Usuário lojista não pode realizar transações'
  end

  test "should return unprocessable_entity if payer is payee" do
    post transfer_url, params: { payer: @payer.id, payee: @payer.id, value: 100.0 }
    assert_response :unprocessable_entity
    assert_includes @response.body, 'Usuário não pode transferir para si mesmo'
  end

  test "should return unprocessable_entity if payer has insufficient balance" do
    post transfer_url, params: { payer: @payer.id, payee: @payee.id, value: 100000000.0 }
    assert_response :unprocessable_entity
    assert_includes @response.body, 'Saldo insuficiente'
  end

  test "should return ok if transaction is successful" do
    post transfer_url, params: @valid_attributes
    assert_response :ok
    assert_includes @response.body, 'Transação realizada com sucesso'
  end
end
