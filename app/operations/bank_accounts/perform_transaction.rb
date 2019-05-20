module BankAccounts
  class PerformTransaction
    def initialize(amount:, transaction_type:, bank_account_id:, recipient_id:)
      @amount = amount.try(:to_f)
      @transaction_type = transaction_type
      @bank_account_id = bank_account_id
      @recipient_id = recipient_id
      @bank_account = BankAccount.where(id: @bank_account_id).first
      @recipient_account = BankAccount.where(account_number: @recipient_id).first
    end

    def execute!
      if @transaction_type == "withdraw" || @transaction_type == "deposit"
        AccountTransaction.create!(
          bank_account: @bank_account,
          amount: @amount,
          transaction_type: @transaction_type,
          recipient_id: @recipient_id
        )
        if @transaction_type == "withdraw"
          @bank_account.update!(balance: @bank_account.balance - @amount)
        elsif  @transaction_type == "deposit"
          @bank_account.update!(balance: @bank_account.balance + @amount)
        end
      elsif  @transaction_type == "transfer"
        AccountTransaction.create!(
          bank_account: @bank_account,
          amount: @amount,
          transaction_type: "withdraw",
          recipient_id: @recipient_id
        )
        AccountTransaction.create!(
          bank_account: @recipient_account,
          amount: @amount,
          transaction_type: "deposit",
          recipient_id: @bank_account.account_number
        )
        @bank_account.update!(balance: @bank_account.balance - @amount)
        @recipient_account.update!(balance: @recipient_account.balance + @amount)
      end
      @bank_account 
    end
  end
end