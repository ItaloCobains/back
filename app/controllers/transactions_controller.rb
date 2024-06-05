class TransactionsController < ApplicationController
  def create
    payer = User.find_by_id!(transaction_params[:payer])

    if payer.kind == 'logista'
      render json: { message: 'Usuário logista não pode realizar transações' }, status: :unprocessable_entity
    end

    if payer.id == transaction_params[:payee].to_i
      render json: { message: 'Usuário não pode transferir para si mesmo' }, status: :unprocessable_entity
    end

    if payer.balance < transaction_params[:value].to_f
      render json: { message: 'Saldo insuficiente' }, status: :unprocessable_entity
    end

    payee = User.find_by_id!(transaction_params[:payee])

    autorize_transaction_request = autorize_transaction

    if autorize_transaction_request.code != 200 &&
       autorize_transaction_request['status'] != 'success' &&
       !autorize_transaction_request['data']['authorization']
      render json: { message: 'Transação não autorizada' }, status: :unprocessable_entitys
    end

    ActiveRecord::Base.transaction do
      Transaction.create!(payer, amount: transaction_params[:value], kind: :withdraw)
      Transaction.create!(payee, amount: transaction_params[:value], kind: :deposit)
    end

    NotifyJob.perform_later

    render json: { message: 'Transação realizada com sucesso' }, status: :ok
  end

  def autorize_transaction
    HTTParty.get('https://util.devi.tools/api/v2/authorize')
  end

  private

  def transaction_params
    params.permit(:value, :payer, :payee)
  end
end
