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

    def create_transaction!(bank_account, amount, transaction_type, recipient_id)
      AccountTransaction.create!(
        bank_account: bank_account,
        amount: amount,
        transaction_type: transaction_type,
        recipient_id: recipient_id
      )
      bank_account.update(balance: bank_account.balance - amount) if transaction_type = "withdraw"
      bank_account.update(balance: bank_account.balance + amount) if transaction_type = "deposit"
      raise ActiveRecord::Rollback unless bank_account.present?
    end


    def execute!
      if %w(withdraw deposit).include?(@transaction_type)
        create_transaction!(@bank_account, @amount, @transaction_type, @recipient_id)
      elsif  @transaction_type.eql? "transfer"
        create_transaction!(@bank_account, @amount, "withdraw", @recipient_id)
        create_transaction!(@recipient_account, @amount, "deposit", @bank_account.account_numbers)
      end
      @bank_account 
    end
  end
end