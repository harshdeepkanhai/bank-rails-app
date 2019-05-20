module BankAccounts
  class ValidateNewTransaction
    def initialize(amount:, transaction_type:, bank_account_id:, recipient_id:)
      @amount = amount.try(:to_f)
      @transaction_type = transaction_type
      @bank_account_id = bank_account_id
      @recipient_id = recipient_id
      @bank_account = BankAccount.where(id: @bank_account_id).first
      @recipient_account = BankAccount.where(account_number: @recipient_id).first
      @errors = []
    end

    def execute!
      validate_existence_of_account!
      if (@transaction_type == "withdraw" or @transaction_type == "transfer") and @bank_account.present? and @recipient_account.present?
        validate_transaction!
      end
      @errors
    end

    private

      def validate_transaction!
        if @bank_account.balance - @amount < 0.00
          @errors << "Not enough funds"
        end
      end
      
      def validate_existence_of_account!
        if @bank_account.blank?
          @errors << "Account not found"
        end

        if @recipient_account.blank?
          @errors << "Recipient Account not found"
        end
      end
  end
end