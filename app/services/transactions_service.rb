class TransactionsService
  def initialize(payer, payee, value)
    @payer = payer
    @payee = payee
    @value = value
  end

  def exec
    if not verifyResponseAutorizeTransactionRequest(autorizeTransactionRequest) return false

    makeTransaction

    NotifyJob.perform_later
    return true
  end

  def payerIsLogista
    @payer.logista?
  end

  def verifyIdPayerPayee
    @payer.id == @payee.id
  end

  def haveBalance
    @payer.balance > @value
  end

  def buildTransaction(entity, kind)
    Transaction.create!(user_id: entity.id, amount: @value, kind:)
  end

  def makeTransaction
    ActiveRecord::Base.transaction do
      buildTransaction(@payer, :withdraw)
      buildTransaction(@payee, :deposit)
    end
  end

  private

  def verifyResponseAutorizeTransactionRequest(response)
    response.code == 200 &&
    response['status'] == 'success' &&
    response['data']['authorization']
  end

  def autorizeTransactionRequest
    HTTParty.get('https://util.devi.tools/api/v2/authorize')
  end
end
