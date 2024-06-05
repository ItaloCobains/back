class TransactionsController < ApplicationController
  def create
    payer = User.find_by_id(transaction_params[:payer])
    return render json: { message: 'Usuário não encontrado' }, status: :not_found if payer.nil?

    if payer.kind == 'logista'
      return render json: { message: 'Usuário logista não pode realizar transações' }, status: :unprocessable_entity
    end

    if payer.id == transaction_params[:payee].to_i
      return render json: { message: 'Usuário não pode transferir para si mesmo' }, status: :unprocessable_entity
    end

    if payer.balance < transaction_params[:value].to_f
      return render json: { message: 'Saldo insuficiente' }, status: :unprocessable_entity
    end

    payee = User.find_by_id(transaction_params[:payee])
    return render json: { message: 'Usuário não encontrado' }, status: :not_found if payee.nil?

    autorize_transaction_request = autorize_transaction

    if autorize_transaction_request.code != 200 &&
       autorize_transaction_request['status'] != 'success' &&
       !autorize_transaction_request['data']['authorization']
      return render json: { message: 'Transação não autorizada' }, status: :unprocessable_entity
    end

    ActiveRecord::Base.transaction do
      Transaction.create!(user_id: payer.id, amount: transaction_params[:value], kind: :withdraw)
      Transaction.create!(user_id: payee.id, amount: transaction_params[:value], kind: :deposit)
    end

    NotifyJob.perform_later

    render json: { message: 'Transação realizada com sucesso' }, status: :ok
  end

  private

  def autorize_transaction
    HTTParty.get('https://util.devi.tools/api/v2/authorize')
  end

  def transaction_params
    params.permit(:value, :payer, :payee)
  end
end
