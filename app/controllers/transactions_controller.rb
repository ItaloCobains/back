class TransactionsController < ApplicationController
  def create
    payer = User.find_by_id(transaction_params[:payer])
    payee = User.find_by_id(transaction_params[:payee])
    return render json: { message: 'Usuário não encontrado' }, status: :not_found if payer.nil? || payee.nil?

    transaction_service = TransactionsService.new(
      payer,
      payee,
      transaction_params[:value]
    )

    if transaction_service.payer_lojista
      return render json: { message: 'Usuário lojista não pode realizar transações' }, status: :unprocessable_entity
    end

    if transaction_service.verify_id_payer_payee
      return render json: { message: 'Usuário não pode transferir para si mesmo' }, status: :unprocessable_entity
    end

    unless transaction_service.balance?
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
