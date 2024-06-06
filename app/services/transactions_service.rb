class TransactionsService
  def initialize(payer, payee, value)
    @payer = payer
    @payee = payee
    @value = value
  end

  def exec
    return false unless verify_response_autorize_transaction_request(fetch_authorization_request)

    make_transaction

    NotifyJob.perform_later
    true
  end

  def payer_lojista
    @payer.lojista?
  end

  def verify_id_payer_payee
    @payer.id == @payee.id
  end

  def balance?
    @payer.balance > BigDecimal(@value)
  end

  def build_transaction(entity, kind)
    Transaction.create!(user_id: entity.id, amount: @value, kind:)
  end

  def make_transaction
    ActiveRecord::Base.transaction do
      build_transaction(@payer, :withdraw)
      build_transaction(@payee, :deposit)
    end
  end

  private

  def verify_response_autorize_transaction_request(response)
    response.code == 200 &&
      response['status'] == 'success' &&
      response['data']['authorization']
  end

  def fetch_authorization_request
    HTTParty.get('https://util.devi.tools/api/v2/authorize')
  end
end
