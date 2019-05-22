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
      if account_present && transaction_deduction
        validate_transaction!
      end
      @errors
    end

    private

      def validate_transaction!
        @errors << "Not enough funds" if @bank_account.balance - @amount < 0.00
      end

      def account_present
        @bank_account.present? && @recipient_account.present?
      end
      def transaction_deduction
        %w(withdraw transfer).include?(@transaction_type
      end
      
      def validate_existence_of_account!
        @errors << "Account not found" if @bank_account.blank?
        @errors << "Recipient Account not found" if @recipient_account.blank?
      end
  end
end