class TransactionsController < ApplicationController
  def create
    payer = User.find_by_id(transaction_params[:payer])
    payee = User.find_by_id(transaction_params[:payee])
    return render json: { message: 'Usuário não encontrado' }, status: :not_found if payer.nil? || payee.nil?

    transaction_service = TransactionsService.new(
      payer: ,
      payee: ,
      value: transaction_params[:value]
    )

    if transaction_service.payerIsLogista
      return render json: { message: 'Usuário logista não pode realizar transações' }, status: :unprocessable_entity
    end

    if transaction_service.verifyIdPayerPayee
      return render json: { message: 'Usuário não pode transferir para si mesmo' }, status: :unprocessable_entity
    end

    if not transaction_service.haveBalance
      return render json: { message: 'Saldo insuficiente' }, status: :unprocessable_entity
    end

    if transaction_service.exec
      return render json: { message: 'Transação não autorizada' }, status: :unprocessable_entity
    end

    render json: { message: 'Transação realizada com sucesso' }, status: :ok
  end

  private

  def transaction_params
    params.permit(:value, :payer, :payee)
  end
end
