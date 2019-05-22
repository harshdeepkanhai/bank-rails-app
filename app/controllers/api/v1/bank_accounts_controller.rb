module Api
  module V1
    class BankAccountsController < ApplicationController
      def new_transaction 
        data = {
          amount: params[:amount]
          transaction_type: params[:transaction_type]
          bank_account_id: params[:bank_account_id]
          recipient_id: params[:recipient_id]
        }
        errors = ::BankAccounts::ValidateNewTransaction.new(data).execute!
        bank_account = ::BankAccounts::PerformTransaction.new(data).execute! unless errors.size > 0
        render json: { errors: errors }, status: 402 if errors.size > 0
        render json: { balance: bank_account.balance }  unless errors.size > 0        
      end
    end
  end
end